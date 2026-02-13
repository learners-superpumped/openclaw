import express from "express";
import { config } from "./config.js";
import { instancesRouter } from "./routes/instances.js";
import { whatsappRouter } from "./routes/whatsapp.js";

const app = express();

app.use(express.json());

// Health check
app.get("/health", (_req, res) => {
  res.json({ ok: true });
});

// Routes
app.use("/api/instances", instancesRouter);
app.use("/api/instances/:userId/whatsapp", whatsappRouter);

app.listen(config.port, () => {
  console.log(
    `openclaw-manager listening on port ${config.port} (namespace: ${config.namespace})`,
  );
});
