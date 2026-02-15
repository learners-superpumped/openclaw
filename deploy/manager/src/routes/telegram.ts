import { Router, type Request, type Response } from "express";
import { gatewayRpc } from "../services/gateway-rpc.js";
import { ensureInstanceReady } from "../services/instance-auth.js";

export const telegramRouter = Router({ mergeParams: true });

// ── POST /api/instances/:userId/telegram/setup ──
telegramRouter.post("/setup", async (req: Request<{ userId: string }>, res: Response) => {
  try {
    const { userId } = req.params;
    const check = await ensureInstanceReady(userId);
    if (!check.ok) {
      res.status(check.status).json({ error: check.error });
      return;
    }

    const { botToken, accountId } = req.body as {
      botToken: string;
      accountId?: string;
    };

    if (!botToken) {
      res.status(400).json({ error: "botToken is required" });
      return;
    }

    // Step 1: get current config hash
    const configResult = await gatewayRpc(userId, check.token, "config.get", {}, 15_000);
    if (!configResult.ok) {
      res.status(502).json({ error: "Failed to get config", details: configResult.error });
      return;
    }

    const baseHash = (configResult.payload as { hash?: string })?.hash;

    // Step 2: build merge-patch
    let patch: object;
    if (!accountId || accountId === "default") {
      patch = { channels: { telegram: { enabled: true, botToken } } };
    } else {
      patch = {
        channels: {
          telegram: {
            enabled: true,
            accounts: { [accountId]: { enabled: true, botToken } },
          },
        },
      };
    }

    // Step 3: apply config patch
    const patchResult = await gatewayRpc(
      userId,
      check.token,
      "config.patch",
      { raw: JSON.stringify(patch), baseHash, note: "telegram-setup" },
      30_000,
    );

    if (!patchResult.ok) {
      res.status(502).json({ error: "Failed to apply config", details: patchResult.error });
      return;
    }

    res.json({ ok: true, config: patchResult.payload });
  } catch (err) {
    console.error("Telegram setup error:", err);
    res.status(500).json({ error: "Failed to setup Telegram", details: String(err) });
  }
});

// ── GET /api/instances/:userId/telegram/status ──
telegramRouter.get("/status", async (req: Request<{ userId: string }>, res: Response) => {
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
      res.json({ userId, telegram: { connected: false, available: false } });
      return;
    }

    const payload = result.payload as {
      channels?: { telegram?: { configured?: boolean; running?: boolean; [key: string]: unknown } };
      channelAccounts?: { telegram?: unknown };
    };

    const telegram = payload?.channels?.telegram;

    res.json({
      userId,
      connected: !!(telegram?.configured && telegram?.running),
      telegram: telegram ?? null,
      accounts: payload?.channelAccounts?.telegram ?? null,
    });
  } catch (err) {
    console.error("Telegram status error:", err);
    res.status(500).json({ error: "Failed to get status", details: String(err) });
  }
});

// ── POST /api/instances/:userId/telegram/logout ──
telegramRouter.post("/logout", async (req: Request<{ userId: string }>, res: Response) => {
  try {
    const { userId } = req.params;
    const check = await ensureInstanceReady(userId);
    if (!check.ok) {
      res.status(check.status).json({ error: check.error });
      return;
    }

    const { accountId } = req.body as { accountId?: string };

    const result = await gatewayRpc(
      userId,
      check.token,
      "channels.logout",
      { channel: "telegram", ...(accountId ? { accountId } : {}) },
      15_000,
    );

    if (!result.ok) {
      res.status(502).json({ error: "Gateway RPC failed", details: result.error });
      return;
    }

    res.json(result.payload);
  } catch (err) {
    console.error("Telegram logout error:", err);
    res.status(500).json({ error: "Failed to logout", details: String(err) });
  }
});
