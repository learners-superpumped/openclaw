import { Router, type Request, type Response } from "express";
import { gatewayRpc } from "../services/gateway-rpc.js";
import { ensureInstanceReady } from "../services/instance-auth.js";

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

    const result = await gatewayRpc(
      userId,
      check.token,
      "channel.pairing.list",
      { channel },
      15_000,
    );

    if (!result.ok) {
      res.status(502).json({ error: "Gateway RPC failed", details: result.error });
      return;
    }

    const payload = result.payload as { channel: string; requests: unknown };
    res.json({ channel: payload.channel, requests: payload.requests });
  } catch (err) {
    console.error("Pairing list error:", err);
    res
      .status(500)
      .json({
        error: "Failed to list pairing requests",
        details: err instanceof Error ? err.message : JSON.stringify(err),
      });
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

    const result = await gatewayRpc(
      userId,
      check.token,
      "channel.pairing.approve",
      { channel, code, notify: notify ?? false },
      15_000,
    );

    if (!result.ok) {
      res.status(502).json({ error: "Gateway RPC failed", details: result.error });
      return;
    }

    res.json(result.payload);
  } catch (err) {
    console.error("Pairing approve error:", err);
    res
      .status(500)
      .json({
        error: "Failed to approve pairing",
        details: err instanceof Error ? err.message : JSON.stringify(err),
      });
  }
});
