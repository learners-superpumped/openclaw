import express from "express";
import { config } from "./config.js";
import { authMiddleware } from "./middleware/auth.js";
import { handleChatUpgrade } from "./routes/chat-proxy.js";
import { gatewayProxyRouter } from "./routes/gateway-proxy.js";
import { instancesRouter } from "./routes/instances.js";
import { pairingRouter } from "./routes/pairing.js";
import { telegramRouter } from "./routes/telegram.js";
import { handleVncUpgrade } from "./routes/vnc-proxy.js";
import { whatsappRouter } from "./routes/whatsapp.js";

const app = express();

app.use(express.json());

// Health check (no auth)
app.get("/health", (_req, res) => {
  res.json({ ok: true });
});

// Apply auth middleware to all /api routes
app.use("/api", authMiddleware);

// Routes
app.use("/api/instances", instancesRouter);
app.use("/api/instances/:userId/whatsapp", whatsappRouter);
app.use("/api/instances/:userId/telegram", telegramRouter);
app.use("/api/instances/:userId/pairing", pairingRouter);
app.use("/api/instances/:userId/rpc", gatewayProxyRouter);

const server = app.listen(config.port, () => {
  console.log(`openclaw-manager listening on port ${config.port} (namespace: ${config.namespace})`);
});

// WebSocket upgrade handler for VNC proxy
server.on("upgrade", (req, socket, head) => {
  const url = new URL(req.url || "", `http://${req.headers.host}`);
  if (url.pathname.match(/^\/api\/instances\/[^/]+\/vnc$/)) {
    handleVncUpgrade(req, socket, head);
  } else if (url.pathname.match(/^\/api\/instances\/[^/]+\/chat$/)) {
    handleChatUpgrade(req, socket, head);
  } else {
    socket.destroy();
  }
});
