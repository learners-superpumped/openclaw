import { Router, type Request, type Response } from "express";
import { gatewayRpc } from "../services/gateway-rpc.js";
import { ensureInstanceReady } from "../services/instance-auth.js";

export const whatsappRouter = Router({ mergeParams: true });

// ── POST /api/instances/:userId/whatsapp/qr ──
whatsappRouter.post("/qr", async (req: Request<{ userId: string }>, res: Response) => {
  try {
    const { userId } = req.params;
    const check = await ensureInstanceReady(userId);
    if (!check.ok) {
      res.status(check.status).json({ error: check.error });
      return;
    }

    const { force, timeoutMs, accountId } = req.body as {
      force?: boolean;
      timeoutMs?: number;
      accountId?: string;
    };

    const result = await gatewayRpc(
      userId,
      check.token,
      "web.login.start",
      {
        force: force ?? false,
        timeoutMs: timeoutMs ?? 30000,
        verbose: false,
        ...(accountId ? { accountId } : {}),
      },
      90_000,
    );

    if (!result.ok) {
      res.status(502).json({
        error: "Gateway RPC failed",
        details: result.error,
      });
      return;
    }

    res.json(result.payload);
  } catch (err) {
    console.error("WhatsApp QR error:", err);
    res.status(500).json({ error: "Failed to get QR code", details: String(err) });
  }
});

// ── POST /api/instances/:userId/whatsapp/wait ──
whatsappRouter.post("/wait", async (req: Request<{ userId: string }>, res: Response) => {
  try {
    const { userId } = req.params;
    const check = await ensureInstanceReady(userId);
    if (!check.ok) {
      res.status(check.status).json({ error: check.error });
      return;
    }

    const { timeoutMs, accountId } = req.body as {
      timeoutMs?: number;
      accountId?: string;
    };

    const result = await gatewayRpc(
      userId,
      check.token,
      "web.login.wait",
      {
        timeoutMs: timeoutMs ?? 120000,
        ...(accountId ? { accountId } : {}),
      },
      180_000,
    );

    if (!result.ok) {
      res.status(502).json({
        error: "Gateway RPC failed",
        details: result.error,
      });
      return;
    }

    res.json(result.payload);
  } catch (err) {
    console.error("WhatsApp wait error:", err);
    res.status(500).json({ error: "Failed to wait for connection", details: String(err) });
  }
});

// ── GET /api/instances/:userId/whatsapp/status ──
whatsappRouter.get("/status", async (req: Request<{ userId: string }>, res: Response) => {
  try {
    const { userId } = req.params;
    const check = await ensureInstanceReady(userId);
    if (!check.ok) {
      res.status(check.status).json({ error: check.error });
      return;
    }

    const probe = req.query.probe === "true";

    const result = await gatewayRpc(
      userId,
      check.token,
      "channels.status",
      { probe, timeoutMs: 10_000 },
      15_000,
    );

    if (!result.ok) {
      res.json({ userId, connected: false, whatsapp: null });
      return;
    }

    const payload = result.payload as {
      channels?: { whatsapp?: { configured?: boolean; running?: boolean; [key: string]: unknown } };
      channelAccounts?: { whatsapp?: unknown };
    };

    const whatsapp = payload?.channels?.whatsapp;

    res.json({
      userId,
      connected: !!(whatsapp?.configured && whatsapp?.running),
      whatsapp: whatsapp ?? null,
      accounts: payload?.channelAccounts?.whatsapp ?? null,
    });
  } catch (err) {
    // Gateway may be restarting — return offline status instead of 500
    const { userId } = req.params;
    res.json({ userId, connected: false, restarting: true, whatsapp: null });
  }
});
