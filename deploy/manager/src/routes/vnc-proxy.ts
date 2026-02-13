import type { IncomingMessage } from "node:http";
import type { Duplex } from "node:stream";
import WebSocket, { WebSocketServer } from "ws";
import { config } from "../config.js";
import { ensureInstanceReady } from "../services/instance-auth.js";

const wss = new WebSocketServer({ noServer: true });

/** Internal service DNS for a user's NoVNC endpoint. */
function novncWsUrl(userId: string): string {
  const name = `${userId}-openclaw`;
  return `ws://${name}.${config.namespace}.svc.cluster.local:${config.browser.novncPort}`;
}

/**
 * Handle HTTP upgrade for VNC WebSocket proxy.
 * Path: /api/instances/:userId/vnc?token=<key>
 */
export function handleVncUpgrade(req: IncomingMessage, socket: Duplex, head: Buffer): void {
  const url = new URL(req.url || "", `http://${req.headers.host}`);
  const match = url.pathname.match(/^\/api\/instances\/([^/]+)\/vnc$/);
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

      wss.handleUpgrade(req, socket, head, (clientWs) => {
        const targetUrl = novncWsUrl(userId);
        const upstream = new WebSocket(targetUrl);

        upstream.on("open", () => {
          clientWs.on("message", (data, isBinary) => {
            if (upstream.readyState === WebSocket.OPEN) {
              upstream.send(data, { binary: isBinary });
            }
          });

          upstream.on("message", (data, isBinary) => {
            if (clientWs.readyState === WebSocket.OPEN) {
              clientWs.send(data, { binary: isBinary });
            }
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
