import { Router } from "express";
import { randomBytes } from "node:crypto";
import { config } from "../config.js";
import * as k8s from "../services/k8s-client.js";
import {
  buildConfigMap,
  buildDeployment,
  buildIngress,
  buildManagedCertificate,
  buildPVC,
  buildSecret,
  buildService,
  host,
  pvcName,
  resourceName,
  type CreateInstanceParams,
} from "../services/k8s-resource-builder.js";

export const instancesRouter = Router();

// ── POST /api/instances ──
instancesRouter.post("/", async (req, res) => {
  try {
    const { userId, secrets = {}, persistence, imageTag } = req.body as {
      userId?: string;
      secrets?: Record<string, string>;
      persistence?: { size?: string };
      imageTag?: string;
    };

    if (!userId || !/^[a-z0-9][a-z0-9-]{0,61}[a-z0-9]?$/.test(userId)) {
      res.status(400).json({
        error:
          "userId is required and must be lowercase alphanumeric (may contain hyphens, 1-63 chars)",
      });
      return;
    }

    // Check if already exists
    const existing = await k8s.getDeployment(resourceName(userId));
    if (existing) {
      res.status(409).json({ error: `Instance for ${userId} already exists` });
      return;
    }

    // Auto-generate gateway token if not provided
    const gatewayToken =
      secrets.OPENCLAW_GATEWAY_TOKEN ||
      randomBytes(32).toString("base64url");
    secrets.OPENCLAW_GATEWAY_TOKEN = gatewayToken;

    const params: CreateInstanceParams = {
      userId,
      secrets,
      persistence,
      imageTag,
    };

    // Create resources in order: Secret, ConfigMap, PVC first, then Deployment, Service
    await k8s.createSecret(buildSecret(params));
    await k8s.createConfigMap(buildConfigMap(params));
    await k8s.createPVC(buildPVC(params));
    await k8s.createDeployment(buildDeployment(params));
    await k8s.createService(buildService(params));

    // Conditionally create Ingress + ManagedCertificate
    if (config.ingress.enabled) {
      await k8s.createIngress(buildIngress(params));
      await k8s.createManagedCertificate(buildManagedCertificate(params));
    }

    const response: Record<string, unknown> = {
      userId,
      status: "creating",
      resources: {
        deployment: resourceName(userId),
        service: resourceName(userId),
        pvc: pvcName(userId),
      },
    };

    if (config.ingress.enabled) {
      response.gatewayUrl = `https://${host(userId)}`;
      (response.resources as Record<string, string>).ingress =
        resourceName(userId);
    }

    res.status(201).json(response);
  } catch (err) {
    console.error("Failed to create instance:", err);
    res
      .status(500)
      .json({ error: "Failed to create instance", details: String(err) });
  }
});

// ── GET /api/instances ──
instancesRouter.get("/", async (_req, res) => {
  try {
    const deployments = await k8s.listDeployments();
    const instances = deployments.map((d) => {
      const userId = d.metadata?.labels?.["openclaw.ai/user"] || "unknown";
      const instance: Record<string, unknown> = {
        userId,
        name: d.metadata?.name,
        ready: (d.status?.readyReplicas ?? 0) > 0,
      };
      if (config.ingress.enabled) {
        instance.gatewayUrl = `https://${host(userId)}`;
      }
      return instance;
    });
    res.json({ instances });
  } catch (err) {
    console.error("Failed to list instances:", err);
    res
      .status(500)
      .json({ error: "Failed to list instances", details: String(err) });
  }
});

// ── GET /api/instances/:userId ──
instancesRouter.get("/:userId", async (req, res) => {
  try {
    const { userId } = req.params;
    const deployment = await k8s.getDeployment(resourceName(userId));
    if (!deployment) {
      res.status(404).json({ error: `Instance ${userId} not found` });
      return;
    }

    const pods = await k8s.listPods(
      `openclaw.ai/user=${userId}`,
    );

    const podStatuses = pods.map((p) => ({
      name: p.metadata?.name,
      phase: p.status?.phase,
      ready: p.status?.containerStatuses?.[0]?.ready ?? false,
    }));

    const response: Record<string, unknown> = {
      userId,
      ready: (deployment.status?.readyReplicas ?? 0) > 0,
      pods: podStatuses,
    };

    if (config.ingress.enabled) {
      response.gatewayUrl = `https://${host(userId)}`;
      const ingress = await k8s.getIngress(resourceName(userId));
      response.ingressIp =
        ingress?.status?.loadBalancer?.ingress?.[0]?.ip || null;
    }

    res.json(response);
  } catch (err) {
    console.error("Failed to get instance:", err);
    res
      .status(500)
      .json({ error: "Failed to get instance", details: String(err) });
  }
});

// ── DELETE /api/instances/:userId ──
instancesRouter.delete("/:userId", async (req, res) => {
  try {
    const { userId } = req.params;
    const preservePvc = req.query.preservePvc !== "false";

    const deployment = await k8s.getDeployment(resourceName(userId));
    if (!deployment) {
      res.status(404).json({ error: `Instance ${userId} not found` });
      return;
    }

    const name = resourceName(userId);

    // Delete in reverse order
    if (config.ingress.enabled) {
      try { await k8s.deleteManagedCertificate(name); } catch (e) { k8s.ignoreNotFound(e); }
      try { await k8s.deleteIngress(name); } catch (e) { k8s.ignoreNotFound(e); }
    }
    try { await k8s.deleteService(name); } catch (e) { k8s.ignoreNotFound(e); }
    try { await k8s.deleteDeployment(name); } catch (e) { k8s.ignoreNotFound(e); }
    try { await k8s.deleteConfigMap(name); } catch (e) { k8s.ignoreNotFound(e); }
    try { await k8s.deleteSecret(name); } catch (e) { k8s.ignoreNotFound(e); }
    if (!preservePvc) {
      try { await k8s.deletePVC(pvcName(userId)); } catch (e) { k8s.ignoreNotFound(e); }
    }

    res.json({
      userId,
      deleted: true,
      pvcPreserved: preservePvc,
    });
  } catch (err) {
    console.error("Failed to delete instance:", err);
    res
      .status(500)
      .json({ error: "Failed to delete instance", details: String(err) });
  }
});
