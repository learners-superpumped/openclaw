export const config = {
  port: parseInt(process.env.PORT || "3000", 10),
  namespace: process.env.OPENCLAW_NAMESPACE || "openclaw",
  image: {
    repository:
      process.env.OPENCLAW_IMAGE_REPO ||
      "us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-gke",
    tag: process.env.OPENCLAW_IMAGE_TAG || "latest",
  },
  domain: {
    base: process.env.OPENCLAW_DOMAIN_BASE || "openclaw.zazz.buzz",
  },
  gateway: {
    port: parseInt(process.env.OPENCLAW_GATEWAY_PORT || "18789", 10),
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
