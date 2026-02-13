import { Router } from "express";
import * as k8s from "../services/k8s-client.js";
import { gatewayRpc } from "../services/gateway-rpc.js";
import { resourceName } from "../services/k8s-resource-builder.js";

export const whatsappRouter = Router({ mergeParams: true });

/** Read the gateway token from the user's Secret. */
async function readGatewayToken(userId: string): Promise<string | null> {
  try {
    const secret = await k8s.coreApi.readNamespacedSecret({
      name: resourceName(userId),
      namespace: (await import("../config.js")).config.namespace,
    });
    const raw = secret.data?.["OPENCLAW_GATEWAY_TOKEN"];
    if (!raw) return null;
    return Buffer.from(raw, "base64").toString("utf-8");
  } catch {
    return null;
  }
}

/** Verify the user instance exists and is ready. */
async function ensureInstanceReady(
  userId: string,
): Promise<{ ok: true; token: string } | { ok: false; error: string; status: number }> {
  const deployment = await k8s.getDeployment(resourceName(userId));
  if (!deployment) {
    return { ok: false, error: `Instance ${userId} not found`, status: 404 };
  }
  if ((deployment.status?.readyReplicas ?? 0) === 0) {
    return {
      ok: false,
      error: `Instance ${userId} is not ready yet`,
      status: 503,
    };
  }
  const token = await readGatewayToken(userId);
  if (!token) {
    return {
      ok: false,
      error: `Gateway token not found for ${userId}`,
      status: 500,
    };
  }
  return { ok: true, token };
}

// ── POST /api/instances/:userId/whatsapp/qr ──
whatsappRouter.post("/qr", async (req, res) => {
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
    res
      .status(500)
      .json({ error: "Failed to get QR code", details: String(err) });
  }
});

// ── POST /api/instances/:userId/whatsapp/wait ──
whatsappRouter.post("/wait", async (req, res) => {
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
    res
      .status(500)
      .json({ error: "Failed to wait for connection", details: String(err) });
  }
});

// ── GET /api/instances/:userId/whatsapp/status ──
whatsappRouter.get("/status", async (req, res) => {
  try {
    const { userId } = req.params;
    const check = await ensureInstanceReady(userId);
    if (!check.ok) {
      res.status(check.status).json({ error: check.error });
      return;
    }

    // Use channel.status RPC to check WhatsApp connection state
    const result = await gatewayRpc(
      userId,
      check.token,
      "channel.status",
      { channelId: "whatsapp" },
      15_000,
    );

    if (!result.ok) {
      // If channel.status is not available, return basic info
      res.json({ userId, whatsapp: { connected: false, available: false } });
      return;
    }

    res.json({ userId, whatsapp: result.payload });
  } catch (err) {
    console.error("WhatsApp status error:", err);
    res
      .status(500)
      .json({ error: "Failed to get status", details: String(err) });
  }
});
