export const config = {
  port: parseInt(process.env.PORT || "3000", 10),
  namespace: process.env.OPENCLAW_NAMESPACE || "openclaw",
  apiKey: process.env.OPENCLAW_MANAGER_API_KEY || "",
  image: {
    repository:
      process.env.OPENCLAW_IMAGE_REPO ||
      "us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-gke",
    tag: process.env.OPENCLAW_IMAGE_TAG || "latest",
  },
  domain: {
    base: process.env.OPENCLAW_DOMAIN_BASE || "openclaw.zazz.buzz",
  },
  ingress: {
    enabled: process.env.OPENCLAW_INGRESS_ENABLED === "true",
  },
  gateway: {
    port: parseInt(process.env.OPENCLAW_GATEWAY_PORT || "18789", 10),
  },
  browser: {
    novncPort: parseInt(process.env.OPENCLAW_NOVNC_PORT || "6080", 10),
  },
  persistence: {
    defaultSize: process.env.OPENCLAW_DEFAULT_PVC_SIZE || "10Gi",
    storageClass: process.env.OPENCLAW_STORAGE_CLASS || "standard-rwo",
  },
  resources: {
    cpu: process.env.OPENCLAW_CPU || "500m",
    memory: process.env.OPENCLAW_MEMORY || "512Mi",
  },
} as const;
