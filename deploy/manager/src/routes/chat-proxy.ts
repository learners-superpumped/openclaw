import type { IncomingMessage } from "node:http";
import type { Duplex } from "node:stream";
import { randomUUID } from "node:crypto";
import WebSocket, { WebSocketServer } from "ws";
import { config } from "../config.js";
import { ensureInstanceReady } from "../services/instance-auth.js";

const wss = new WebSocketServer({ noServer: true });

/** Internal service DNS for a user's gateway endpoint. */
function gatewayWsUrl(userId: string): string {
  const name = `${userId}-openclaw`;
  return `ws://${name}.${config.namespace}.svc.cluster.local:${config.gateway.port}`;
}

/**
 * Perform the gateway handshake on the upstream WebSocket.
 * Resolves once the handshake succeeds, rejects on failure or timeout.
 */
function performHandshake(
  upstream: WebSocket,
  gatewayToken: string,
  timeoutMs = 30_000,
): Promise<void> {
  return new Promise<void>((resolve, reject) => {
    const connectId = randomUUID();
    let settled = false;

    const timer = setTimeout(() => {
      if (!settled) {
        settled = true;
        upstream.removeListener("message", onMessage);
        reject(new Error("Gateway handshake timed out"));
      }
    }, timeoutMs);

    const onMessage = (raw: WebSocket.RawData) => {
      let msg: {
        type: string;
        id?: string;
        event?: string;
        ok?: boolean;
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
        upstream.send(
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
              scopes: ["operator.admin"],
              auth: { token: gatewayToken },
            },
          }),
        );
        return;
      }

      // Step 3: receive hello-ok response for connect
      if (msg.type === "res" && msg.id === connectId) {
        if (settled) {
          return;
        }
        settled = true;
        clearTimeout(timer);
        upstream.removeListener("message", onMessage);
        if (!msg.ok) {
          reject(new Error(`Gateway handshake failed: ${msg.error?.message || "unknown"}`));
          return;
        }
        // Step 4: handshake complete
        resolve();
      }
    };

    upstream.on("message", onMessage);
  });
}

/**
 * Handle HTTP upgrade for chat WebSocket proxy.
 * Path: /api/instances/:userId/chat?token=<key>
 */
export function handleChatUpgrade(req: IncomingMessage, socket: Duplex, head: Buffer): void {
  const url = new URL(req.url || "", `http://${req.headers.host}`);
  const match = url.pathname.match(/^\/api\/instances\/([^/]+)\/chat$/);
  if (!match) {
    socket.destroy();
    return;
  }

  const userId = match[1];

  // Validate API key from query param
  if (config.apiKey) {
    const token = url.searchParams.get("token");
    if (token !== config.apiKey) {
      socket.write("HTTP/1.1 401 Unauthorized\r\n\r\n");
      socket.destroy();
      return;
    }
  }

  // Verify instance is ready, then proxy
  ensureInstanceReady(userId)
    .then((check) => {
      if (!check.ok) {
        socket.write(`HTTP/1.1 ${check.status} ${check.error}\r\n\r\n`);
        socket.destroy();
        return;
      }

      const gatewayToken = check.token;

      wss.handleUpgrade(req, socket, head, (clientWs) => {
        const targetUrl = gatewayWsUrl(userId);
        const upstream = new WebSocket(targetUrl);

        // Buffer client messages during handshake
        const pendingMessages: { data: WebSocket.RawData; isBinary: boolean }[] = [];
        let handshakeComplete = false;

        clientWs.on("message", (data, isBinary) => {
          if (!handshakeComplete) {
            pendingMessages.push({ data, isBinary });
            return;
          }
          if (upstream.readyState === WebSocket.OPEN) {
            upstream.send(data, { binary: isBinary });
          }
        });

        upstream.on("open", () => {
          performHandshake(upstream, gatewayToken)
            .then(() => {
              handshakeComplete = true;

              // Flush buffered client messages
              for (const msg of pendingMessages) {
                if (upstream.readyState === WebSocket.OPEN) {
                  upstream.send(msg.data, { binary: msg.isBinary });
                }
              }
              pendingMessages.length = 0;

              // Bi-directional pass-through (upstream → client)
              upstream.on("message", (data, isBinary) => {
                if (clientWs.readyState === WebSocket.OPEN) {
                  clientWs.send(data, { binary: isBinary });
                }
              });
            })
            .catch(() => {
              upstream.close();
              clientWs.close();
            });
        });

        upstream.on("close", () => clientWs.close());
        upstream.on("error", () => clientWs.close());
        clientWs.on("close", () => upstream.close());
        clientWs.on("error", () => upstream.close());
      });
    })
    .catch(() => {
      socket.write("HTTP/1.1 500 Internal Server Error\r\n\r\n");
      socket.destroy();
    });
}
