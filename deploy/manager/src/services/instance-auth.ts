import * as k8s from "./k8s-client.js";
import { resourceName } from "./k8s-resource-builder.js";
import { config } from "../config.js";

/** Read the gateway token from the user's Secret. */
export async function readGatewayToken(userId: string): Promise<string | null> {
  try {
    const secret = await k8s.coreApi.readNamespacedSecret({
      name: resourceName(userId),
      namespace: config.namespace,
    });
    const raw = secret.data?.["OPENCLAW_GATEWAY_TOKEN"];
    if (!raw) return null;
    return Buffer.from(raw, "base64").toString("utf-8");
  } catch {
    return null;
  }
}

/** Verify the user instance exists and is ready. */
export async function ensureInstanceReady(
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
