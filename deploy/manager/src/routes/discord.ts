import { Router, type Request, type Response } from "express";
import { gatewayRpc } from "../services/gateway-rpc.js";
import { ensureInstanceReady } from "../services/instance-auth.js";

export const discordRouter = Router({ mergeParams: true });

// ── POST /api/instances/:userId/discord/setup ──
discordRouter.post("/setup", async (req: Request<{ userId: string }>, res: Response) => {
  try {
    const { userId } = req.params;
    const check = await ensureInstanceReady(userId);
    if (!check.ok) {
      res.status(check.status).json({ error: check.error });
      return;
    }

    const { token: botToken, accountId } = req.body as {
      token: string;
      accountId?: string;
    };

    if (!botToken) {
      res.status(400).json({ error: "token is required" });
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
      patch = { channels: { discord: { enabled: true, token: botToken } } };
    } else {
      patch = {
        channels: {
          discord: {
            enabled: true,
            accounts: { [accountId]: { enabled: true, token: botToken } },
          },
        },
      };
    }

    // Step 3: apply config patch
    const patchResult = await gatewayRpc(
      userId,
      check.token,
      "config.patch",
      { raw: JSON.stringify(patch), baseHash, note: "discord-setup" },
      30_000,
    );

    if (!patchResult.ok) {
      res.status(502).json({ error: "Failed to apply config", details: patchResult.error });
      return;
    }

    res.json({ ok: true, config: patchResult.payload });
  } catch (err) {
    console.error("Discord setup error:", err);
    res.status(500).json({ error: "Failed to setup Discord", details: String(err) });
  }
});

// ── GET /api/instances/:userId/discord/status ──
discordRouter.get("/status", async (req: Request<{ userId: string }>, res: Response) => {
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
      res.json({ userId, discord: { connected: false, available: false } });
      return;
    }

    const payload = result.payload as {
      channels?: { discord?: { configured?: boolean; running?: boolean; [key: string]: unknown } };
      channelAccounts?: { discord?: unknown };
    };

    const discord = payload?.channels?.discord;

    res.json({
      userId,
      connected: !!(discord?.configured && discord?.running),
      discord: discord ?? null,
      accounts: payload?.channelAccounts?.discord ?? null,
    });
  } catch (err) {
    // Gateway may be restarting — return offline status instead of 500
    const { userId } = req.params;
    res.json({ userId, connected: false, restarting: true, discord: null });
  }
});

// ── POST /api/instances/:userId/discord/logout ──
discordRouter.post("/logout", async (req: Request<{ userId: string }>, res: Response) => {
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
      { channel: "discord", ...(accountId ? { accountId } : {}) },
      15_000,
    );

    if (!result.ok) {
      res.status(502).json({ error: "Gateway RPC failed", details: result.error });
      return;
    }

    res.json(result.payload);
  } catch (err) {
    console.error("Discord logout error:", err);
    res.status(500).json({ error: "Failed to logout", details: String(err) });
  }
});
