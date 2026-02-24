import type { JwtService } from "@nestjs/jwt";
import type { IncomingMessage } from "node:http";
import type { Duplex } from "node:stream";
import { WebSocketServer, WebSocket } from "ws";
import type { PrismaService } from "../prisma/prisma.service.js";

interface ChatProxyDeps {
  jwt: JwtService;
  managerUrl: string;
  managerApiKey: string;
  prisma: PrismaService;
}

const AUTH_TIMEOUT_MS = 10_000;

let deps: ChatProxyDeps;
let wss: WebSocketServer;

export function initChatProxy(d: ChatProxyDeps): void {
  deps = d;
  wss = new WebSocketServer({ noServer: true });
}

export function handleChatUpgrade(req: IncomingMessage, socket: Duplex, head: Buffer): void {
  wss.handleUpgrade(req, socket, head, (clientWs) => {
    handleConnection(clientWs, req).catch(() => {
      if (clientWs.readyState === WebSocket.OPEN) {
        clientWs.close(4500, "Internal error");
      }
    });
  });
}

async function handleConnection(clientWs: WebSocket, req: IncomingMessage): Promise<void> {
  // 1. Parse instanceId from URL: /instances/:instanceId/chat
  const url = new URL(req.url || "", `http://${req.headers.host}`);
  const match = url.pathname.match(/^\/instances\/([^/]+)\/chat$/);
  if (!match) {
    clientWs.close(4400, "Invalid path");
    return;
  }
  const instanceId = match[1];

  // 2. Send auth_required
  clientWs.send(JSON.stringify({ type: "auth_required" }));

  // 3. Wait for auth message with timeout
  const authPayload = await waitForAuth(clientWs);
  if (!authPayload) {
    // Timeout or connection closed — already handled inside waitForAuth
    return;
  }

  // 4. Verify JWT
  let userId: string;
  try {
    const payload = await deps.jwt.verifyAsync(authPayload.token);
    userId = payload.sub;
  } catch {
    clientWs.close(4001, "Unauthorized");
    return;
  }

  // 5. Verify instance ownership via Prisma
  let instance: { instanceId: string; userId: string };
  try {
    const found = await deps.prisma.instance.findUnique({
      where: { instanceId },
    });
    if (!found) {
      clientWs.close(4004, "Instance not found");
      return;
    }
    if (found.userId !== userId) {
      clientWs.close(4001, "Unauthorized");
      return;
    }
    instance = found;
  } catch {
    clientWs.close(4500, "Internal error");
    return;
  }

  // 6. Build Manager WS URL
  //    managerUrl is "http://..." — replace protocol with "ws://"
  const managerWsBase = deps.managerUrl.replace(/^http/, "ws");
  const managerWsUrl =
    `${managerWsBase}/api/instances/${instance.instanceId}/chat` +
    `?token=${encodeURIComponent(deps.managerApiKey)}`;

  // 7. Connect to Manager and start bidirectional proxy
  const managerWs = new WebSocket(managerWsUrl);

  const PING_INTERVAL_MS = 20_000;
  let clientPing: ReturnType<typeof setInterval> | undefined;
  let managerPing: ReturnType<typeof setInterval> | undefined;

  function cleanup() {
    clearInterval(clientPing);
    clearInterval(managerPing);
    if (managerWs.readyState === WebSocket.OPEN) {
      managerWs.close();
    }
    if (clientWs.readyState === WebSocket.OPEN) {
      clientWs.close();
    }
  }

  managerWs.on("open", () => {
    // Notify client that authentication + proxy is ready
    if (clientWs.readyState === WebSocket.OPEN) {
      clientWs.send(JSON.stringify({ type: "auth_ok" }));
    }

    // Proxy: client -> manager
    clientWs.on("message", (data, isBinary) => {
      if (managerWs.readyState === WebSocket.OPEN) {
        managerWs.send(data, { binary: isBinary });
      }
    });

    // Proxy: manager -> client
    managerWs.on("message", (data, isBinary) => {
      if (clientWs.readyState === WebSocket.OPEN) {
        clientWs.send(data, { binary: isBinary });
      }
    });

    // Ping both sides to keep connections alive (LB idle timeout is 30s)
    clientPing = setInterval(() => {
      if (clientWs.readyState === WebSocket.OPEN) {
        clientWs.ping();
      }
    }, PING_INTERVAL_MS);

    managerPing = setInterval(() => {
      if (managerWs.readyState === WebSocket.OPEN) {
        managerWs.ping();
      }
    }, PING_INTERVAL_MS);
  });

  clientWs.on("close", cleanup);
  clientWs.on("error", cleanup);
  managerWs.on("close", cleanup);
  managerWs.on("error", cleanup);
}

function waitForAuth(ws: WebSocket): Promise<{ token: string } | null> {
  return new Promise((resolve) => {
    const timer = setTimeout(() => {
      cleanup();
      if (ws.readyState === WebSocket.OPEN) {
        ws.close(4001, "Auth timeout");
      }
      resolve(null);
    }, AUTH_TIMEOUT_MS);

    const onMessage = (data: Buffer | ArrayBuffer | Buffer[]) => {
      let parsed: unknown;
      try {
        parsed = JSON.parse(data.toString());
      } catch {
        // Not valid JSON — ignore (wait for a valid auth message)
        return;
      }

      if (
        typeof parsed === "object" &&
        parsed !== null &&
        "type" in parsed &&
        (parsed as { type: unknown }).type === "auth" &&
        "token" in parsed &&
        typeof (parsed as { token: unknown }).token === "string"
      ) {
        cleanup();
        resolve({ token: (parsed as { token: string }).token });
      }
      // Ignore any other message types before auth
    };

    const onClose = () => {
      cleanup();
      resolve(null);
    };

    const cleanup = () => {
      clearTimeout(timer);
      ws.off("message", onMessage);
      ws.off("close", onClose);
    };

    ws.on("message", onMessage);
    ws.on("close", onClose);
  });
}
