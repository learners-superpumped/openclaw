import { randomUUID } from "node:crypto";
import WebSocket from "ws";
import { config } from "../config.js";

/** Internal service DNS for a user's gateway pod. */
function gatewayWsUrl(userId: string): string {
  const name = `${userId}-openclaw`;
  return `ws://${name}.${config.namespace}.svc.cluster.local:${config.gateway.port}`;
}

interface RpcResponse {
  ok: boolean;
  payload?: unknown;
  error?: { code: string; message: string };
}

/**
 * Open a WebSocket to the user's OpenClaw gateway, perform the
 * protocol-v2 handshake, send one RPC request, and return the result.
 */
export async function gatewayRpc(
  userId: string,
  gatewayToken: string,
  method: string,
  params: Record<string, unknown> = {},
  timeoutMs = 60_000,
): Promise<RpcResponse> {
  const url = gatewayWsUrl(userId);

  return new Promise<RpcResponse>((resolve, reject) => {
    const ws = new WebSocket(url);
    const timer = setTimeout(() => {
      ws.close();
      reject(new Error(`RPC timeout after ${timeoutMs}ms`));
    }, timeoutMs);

    let handshakeDone = false;
    const connectId = randomUUID();
    const rpcId = randomUUID();

    ws.on("error", (err) => {
      clearTimeout(timer);
      reject(err);
    });

    ws.on("close", () => {
      clearTimeout(timer);
      if (!handshakeDone) {
        reject(new Error("WebSocket closed before handshake completed"));
      }
    });

    ws.on("message", (raw) => {
      let msg: {
        type: string;
        id?: string;
        event?: string;
        ok?: boolean;
        payload?: unknown;
        error?: { code: string; message: string };
      };
      try {
        msg = JSON.parse(String(raw));
      } catch {
        return;
      }

      // Step 1: server sends connect.challenge event
      if (msg.type === "event" && msg.event === "connect.challenge") {
        const nonce =
          msg.payload &&
          typeof msg.payload === "object" &&
          "nonce" in msg.payload
            ? (msg.payload as { nonce: string }).nonce
            : undefined;
        // Step 2: send connect request
        ws.send(
          JSON.stringify({
            type: "req",
            id: connectId,
            method: "connect",
            params: {
              minProtocol: 2,
              maxProtocol: 2,
              client: {
                id: "openclaw-manager",
                displayName: "OpenClaw Manager",
                version: "0.1.0",
                platform: "server",
                mode: "backend",
              },
              role: "operator",
              scopes: ["operator.admin"],
              auth: { token: gatewayToken },
              ...(nonce ? { device: { nonce } } : {}),
            },
          }),
        );
        return;
      }

      // Step 3: receive hello-ok response for connect
      if (msg.type === "res" && msg.id === connectId) {
        if (!msg.ok) {
          clearTimeout(timer);
          ws.close();
          reject(
            new Error(
              `Gateway handshake failed: ${msg.error?.message || "unknown"}`,
            ),
          );
          return;
        }
        handshakeDone = true;

        // Step 4: send the actual RPC request
        ws.send(
          JSON.stringify({
            type: "req",
            id: rpcId,
            method,
            params,
          }),
        );
        return;
      }

      // Step 5: receive RPC response
      if (msg.type === "res" && msg.id === rpcId) {
        clearTimeout(timer);
        ws.close();
        resolve({
          ok: msg.ok ?? false,
          payload: msg.payload,
          error: msg.error,
        });
      }
    });
  });
}
