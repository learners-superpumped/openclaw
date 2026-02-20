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
    let settled = false;

    const settle = (fn: () => void) => {
      if (settled) {
        return;
      }
      settled = true;
      clearTimeout(timer);
      fn();
    };

    const timer = setTimeout(() => {
      settle(() => {
        ws.close();
        reject(new Error(`RPC timeout after ${timeoutMs}ms`));
      });
    }, timeoutMs);

    const connectId = randomUUID();
    const rpcId = randomUUID();

    ws.on("error", (err) => {
      settle(() => {
        ws.close();
        reject(err);
      });
    });

    ws.on("close", () => {
      settle(() => reject(new Error("WebSocket closed before RPC completed")));
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
        // Step 2: send connect request
        ws.send(
          JSON.stringify({
            type: "req",
            id: connectId,
            method: "connect",
            params: {
              minProtocol: 3,
              maxProtocol: 3,
              client: {
                id: "gateway-client",
                displayName: "OpenClaw Manager",
                version: "0.1.0",
                platform: "server",
                mode: "backend",
              },
              role: "operator",
              scopes: ["operator.read", "operator.write", "operator.admin"],
              auth: { token: gatewayToken },
            },
          }),
        );
        return;
      }

      // Step 3: receive hello-ok response for connect
      if (msg.type === "res" && msg.id === connectId) {
        if (!msg.ok) {
          settle(() => {
            ws.close();
            reject(new Error(`Gateway handshake failed: ${msg.error?.message || "unknown"}`));
          });
          return;
        }

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
        settle(() => {
          ws.close();
          resolve({
            ok: msg.ok ?? false,
            payload: msg.payload,
            error: msg.error,
          });
        });
      }
    });
  });
}
