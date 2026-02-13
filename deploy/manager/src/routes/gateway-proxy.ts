import { Router, type Request, type Response } from "express";
import { ensureInstanceReady } from "../services/instance-auth.js";
import { gatewayRpc } from "../services/gateway-rpc.js";

export const gatewayProxyRouter = Router({ mergeParams: true });

// ── POST /api/instances/:userId/rpc ──
gatewayProxyRouter.post("/", async (req: Request<{ userId: string }>, res: Response) => {
  try {
    const { userId } = req.params;
    const check = await ensureInstanceReady(userId);
    if (!check.ok) {
      res.status(check.status).json({ error: check.error });
      return;
    }

    const { method, params, timeoutMs } = req.body as {
      method?: string;
      params?: Record<string, unknown>;
      timeoutMs?: number;
    };

    if (!method || typeof method !== "string") {
      res.status(400).json({ error: "method is required and must be a string" });
      return;
    }

    const result = await gatewayRpc(
      userId,
      check.token,
      method,
      params ?? {},
      timeoutMs ?? 60_000,
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
    console.error("Gateway RPC proxy error:", err);
    res
      .status(500)
      .json({ error: "Gateway RPC proxy failed", details: String(err) });
  }
});
