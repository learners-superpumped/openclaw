import crypto from "node:crypto";
import { getManagerIdentity } from "./device-identity.js";
import { findPodName, execInPod } from "./k8s-exec.js";

function base64UrlEncode(buf: Buffer): string {
  return buf.toString("base64").replaceAll("+", "-").replaceAll("/", "_").replace(/=+$/g, "");
}

/** Resolve the OPENCLAW_STATE_DIR inside the gateway pod. */
async function resolveStateDir(podName: string): Promise<string> {
  const result = await execInPod(
    podName,
    [
      "node",
      "-e",
      `console.log(process.env.OPENCLAW_STATE_DIR || require("os").homedir() + "/.openclaw")`,
    ],
    10_000,
  );
  return result.stdout.trim();
}

/**
 * Ensure the Manager's device identity is registered as a paired device
 * in the user's gateway pod (via k8s-exec on paired.json).
 */
export async function ensureManagerPaired(userId: string): Promise<void> {
  const podName = await findPodName(userId);
  if (!podName) {
    throw new Error(`No running pod for user ${userId}`);
  }

  const identity = getManagerIdentity();
  const stateDir = await resolveStateDir(podName);
  const pairedPath = `${stateDir}/devices/paired.json`;

  // Check if already paired
  const checkScript = `
    const fs = require("fs");
    const p = ${JSON.stringify(pairedPath)};
    try {
      const d = JSON.parse(fs.readFileSync(p, "utf8"));
      console.log(d[${JSON.stringify(identity.deviceId)}] ? "paired" : "not_paired");
    } catch { console.log("not_paired"); }
  `;
  const checkResult = await execInPod(podName, ["node", "-e", checkScript], 10_000);
  if (checkResult.stdout.trim() === "paired") {
    return;
  }

  // Register manager device
  const now = Date.now();
  const scopes = ["operator.read", "operator.write", "operator.admin"];
  const tokenValue = base64UrlEncode(crypto.randomBytes(32));

  const entry = {
    deviceId: identity.deviceId,
    publicKey: identity.publicKeyBase64Url,
    displayName: "OpenClaw Manager",
    platform: "server",
    clientId: "gateway-client",
    clientMode: "backend",
    role: "operator",
    roles: ["operator"],
    scopes,
    tokens: {
      operator: {
        token: tokenValue,
        role: "operator",
        scopes,
        createdAtMs: now,
      },
    },
    createdAtMs: now,
    approvedAtMs: now,
  };

  const writeScript = `
    const fs = require("fs");
    const path = require("path");
    const p = ${JSON.stringify(pairedPath)};
    fs.mkdirSync(path.dirname(p), { recursive: true });
    let data = {};
    try { data = JSON.parse(fs.readFileSync(p, "utf8")); } catch {}
    data[${JSON.stringify(identity.deviceId)}] = ${JSON.stringify(entry)};
    fs.writeFileSync(p, JSON.stringify(data, null, 2) + "\\n");
    console.log("ok");
  `;
  const writeResult = await execInPod(podName, ["node", "-e", writeScript], 10_000);
  if (writeResult.stdout.trim() !== "ok") {
    throw new Error(`Failed to write paired.json: ${writeResult.stderr}`);
  }
}
