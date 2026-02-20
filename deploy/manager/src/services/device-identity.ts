import crypto from "node:crypto";

export type ManagerDeviceIdentity = {
  deviceId: string;
  publicKeyPem: string;
  privateKeyPem: string;
  publicKeyBase64Url: string;
};

const ED25519_SPKI_PREFIX = Buffer.from("302a300506032b6570032100", "hex");

function base64UrlEncode(buf: Buffer): string {
  return buf.toString("base64").replaceAll("+", "-").replaceAll("/", "_").replace(/=+$/g, "");
}

function derivePublicKeyRaw(publicKeyPem: string): Buffer {
  const key = crypto.createPublicKey(publicKeyPem);
  const spki = key.export({ type: "spki", format: "der" }) as Buffer;
  if (
    spki.length === ED25519_SPKI_PREFIX.length + 32 &&
    spki.subarray(0, ED25519_SPKI_PREFIX.length).equals(ED25519_SPKI_PREFIX)
  ) {
    return spki.subarray(ED25519_SPKI_PREFIX.length);
  }
  return spki;
}

function generateIdentity(): ManagerDeviceIdentity {
  const { publicKey, privateKey } = crypto.generateKeyPairSync("ed25519");
  const publicKeyPem = publicKey.export({ type: "spki", format: "pem" }).toString();
  const privateKeyPem = privateKey.export({ type: "pkcs8", format: "pem" }).toString();
  const raw = derivePublicKeyRaw(publicKeyPem);
  const deviceId = crypto.createHash("sha256").update(raw).digest("hex");
  const publicKeyBase64Url = base64UrlEncode(raw);
  return { deviceId, publicKeyPem, privateKeyPem, publicKeyBase64Url };
}

let cached: ManagerDeviceIdentity | null = null;

/** Singleton identity (in-memory, regenerated on restart). */
export function getManagerIdentity(): ManagerDeviceIdentity {
  if (!cached) {
    cached = generateIdentity();
  }
  return cached;
}

type DeviceField = {
  id: string;
  publicKey: string;
  signature: string;
  signedAt: number;
  nonce: string;
};

/**
 * Build the `device` field for gateway connect params.
 *
 * Auth payload format (v2):
 *   "v2|deviceId|clientId|clientMode|role|scopes|signedAt|token|nonce"
 */
export function buildDeviceField(
  nonce: string,
  gatewayToken: string,
  scopes: string[],
): DeviceField {
  const identity = getManagerIdentity();
  const signedAtMs = Date.now();
  const payload = [
    "v2",
    identity.deviceId,
    "gateway-client", // clientId
    "backend", // clientMode
    "operator", // role
    scopes.join(","),
    String(signedAtMs),
    gatewayToken,
    nonce,
  ].join("|");

  const key = crypto.createPrivateKey(identity.privateKeyPem);
  const sig = crypto.sign(null, Buffer.from(payload, "utf8"), key);
  const signature = base64UrlEncode(sig);

  return {
    id: identity.deviceId,
    publicKey: identity.publicKeyBase64Url,
    signature,
    signedAt: signedAtMs,
    nonce,
  };
}
