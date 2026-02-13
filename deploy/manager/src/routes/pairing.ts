import { Router, type Request, type Response } from "express";
import { ensureInstanceReady } from "../services/instance-auth.js";
import { findPodName, execInPod } from "../services/k8s-exec.js";

export const pairingRouter = Router({ mergeParams: true });

const ALPHANUMERIC = /^[a-zA-Z0-9_-]+$/;

// ── GET /api/instances/:userId/pairing/list ──
pairingRouter.get("/list", async (req: Request<{ userId: string }>, res: Response) => {
  try {
    const { userId } = req.params;
    const channel = req.query.channel as string | undefined;

    if (!channel) {
      res.status(400).json({ error: "channel query parameter is required" });
      return;
    }

    if (!ALPHANUMERIC.test(channel)) {
      res.status(400).json({ error: "Invalid channel name" });
      return;
    }

    const check = await ensureInstanceReady(userId);
    if (!check.ok) {
      res.status(check.status).json({ error: check.error });
      return;
    }

    const podName = await findPodName(userId);
    if (!podName) {
      res.status(503).json({ error: "Pod not found for instance" });
      return;
    }

    const { stdout } = await execInPod(
      podName,
      ["node", "dist/index.js", "pairing", "list", channel, "--json"],
      15_000,
    );

    let parsed: unknown;
    try {
      parsed = JSON.parse(stdout);
    } catch {
      res.status(502).json({ error: "Failed to parse pairing list output", raw: stdout });
      return;
    }

    res.json({ channel, requests: parsed });
  } catch (err) {
    console.error("Pairing list error:", err);
    res.status(500).json({ error: "Failed to list pairing requests", details: String(err) });
  }
});

// ── POST /api/instances/:userId/pairing/approve ──
pairingRouter.post("/approve", async (req: Request<{ userId: string }>, res: Response) => {
  try {
    const { userId } = req.params;
    const { channel, code, notify } = req.body as {
      channel: string;
      code: string;
      notify?: boolean;
    };

    if (!channel || !code) {
      res.status(400).json({ error: "channel and code are required" });
      return;
    }

    if (!ALPHANUMERIC.test(channel) || !ALPHANUMERIC.test(code)) {
      res.status(400).json({ error: "Invalid channel or code format" });
      return;
    }

    const check = await ensureInstanceReady(userId);
    if (!check.ok) {
      res.status(check.status).json({ error: check.error });
      return;
    }

    const podName = await findPodName(userId);
    if (!podName) {
      res.status(503).json({ error: "Pod not found for instance" });
      return;
    }

    const command = [
      "node",
      "dist/index.js",
      "pairing",
      "approve",
      channel,
      code,
      ...(notify ? ["--notify"] : []),
    ];

    const { stdout } = await execInPod(podName, command, 15_000);

    let parsed: unknown;
    try {
      parsed = JSON.parse(stdout);
    } catch {
      res.json({ approved: true, output: stdout.trim() });
      return;
    }

    res.json({ approved: true, ...(parsed as object) });
  } catch (err) {
    console.error("Pairing approve error:", err);
    res.status(500).json({ error: "Failed to approve pairing", details: String(err) });
  }
});
