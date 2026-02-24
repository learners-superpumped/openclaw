import { Router, type Request, type Response } from "express";
import { gatewayRpc } from "../services/gateway-rpc.js";
import { ensureInstanceReady } from "../services/instance-auth.js";

export const channelsRouter = Router({ mergeParams: true });

const CHANNEL_NAMES = ["whatsapp", "telegram", "discord"] as const;

// ── GET /api/instances/:userId/channels/status ──
channelsRouter.get("/status", async (req: Request<{ userId: string }>, res: Response) => {
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
      res.json({
        userId,
        restarting: false,
        connected: { whatsapp: false, telegram: false, discord: false },
        channels: { whatsapp: null, telegram: null, discord: null },
        channelAccounts: { whatsapp: null, telegram: null, discord: null },
      });
      return;
    }

    const payload = result.payload as {
      channels?: Record<
        string,
        { configured?: boolean; running?: boolean; [key: string]: unknown } | undefined
      >;
      channelAccounts?: Record<string, unknown>;
    };

    const connected: Record<string, boolean> = {};
    const channels: Record<string, unknown> = {};
    const channelAccounts: Record<string, unknown> = {};

    for (const name of CHANNEL_NAMES) {
      const ch = payload?.channels?.[name];
      connected[name] = !!(ch?.configured && ch?.running);
      channels[name] = ch ?? null;
      channelAccounts[name] = payload?.channelAccounts?.[name] ?? null;
    }

    res.json({ userId, restarting: false, connected, channels, channelAccounts });
  } catch (err) {
    // Gateway may be restarting — return offline status instead of 500
    const { userId } = req.params;
    res.json({
      userId,
      restarting: true,
      connected: { whatsapp: false, telegram: false, discord: false },
      channels: { whatsapp: null, telegram: null, discord: null },
      channelAccounts: { whatsapp: null, telegram: null, discord: null },
    });
  }
});
