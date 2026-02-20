import { Router, type Request, type Response } from "express";
import { ensureInstanceReady } from "../services/instance-auth.js";
import { execInPod, findPodName } from "../services/k8s-exec.js";

export const skillsRouter = Router({ mergeParams: true });

// ── POST /api/instances/:userId/skills/hub-install ──
skillsRouter.post("/hub-install", async (req: Request<{ userId: string }>, res: Response) => {
  try {
    const { userId } = req.params;
    const { slug, version } = req.body as { slug?: string; version?: string };

    if (!slug || typeof slug !== "string") {
      res.status(400).json({ error: "slug is required and must be a string" });
      return;
    }

    const check = await ensureInstanceReady(userId);
    if (!check.ok) {
      res.status(check.status).json({ error: check.error });
      return;
    }

    const podName = await findPodName(userId);
    if (!podName) {
      res.status(503).json({ error: `No running pod found for ${userId}` });
      return;
    }

    const command = ["clawhub", "install", slug, "--workdir", "/data", "--no-input"];
    if (version) {
      command.push("--version", version);
    }

    const result = await execInPod(podName, command, 120_000);

    // Verify installation by checking lock.json
    try {
      const lockResult = await execInPod(podName, ["cat", "/data/.clawhub/lock.json"], 10_000);
      const lock = JSON.parse(lockResult.stdout);
      const found = Array.isArray(lock.skills) && lock.skills.some((s: any) => s.slug === slug);
      if (!found) {
        res.status(500).json({
          error: "Install verification failed: skill not found in lock.json",
          stdout: result.stdout,
          stderr: result.stderr,
        });
        return;
      }
    } catch (verifyErr) {
      res.status(500).json({
        error: "Install verification failed: could not read lock.json",
        stdout: result.stdout,
        stderr: result.stderr,
        details: String(verifyErr),
      });
      return;
    }

    res.json({ success: true, stdout: result.stdout, stderr: result.stderr });
  } catch (err) {
    console.error("Hub install error:", err);
    res.status(500).json({ error: "Skill install failed", details: String(err) });
  }
});

// ── POST /api/instances/:userId/skills/hub-uninstall ──
skillsRouter.post("/hub-uninstall", async (req: Request<{ userId: string }>, res: Response) => {
  try {
    const { userId } = req.params;
    const { slug } = req.body as { slug?: string };

    if (!slug || typeof slug !== "string") {
      res.status(400).json({ error: "slug is required and must be a string" });
      return;
    }

    const check = await ensureInstanceReady(userId);
    if (!check.ok) {
      res.status(check.status).json({ error: check.error });
      return;
    }

    const podName = await findPodName(userId);
    if (!podName) {
      res.status(503).json({ error: `No running pod found for ${userId}` });
      return;
    }

    const command = ["clawhub", "uninstall", slug, "--workdir", "/data", "--yes"];
    const result = await execInPod(podName, command, 60_000);

    // Verify uninstallation by checking lock.json
    try {
      const lockResult = await execInPod(podName, ["cat", "/data/.clawhub/lock.json"], 10_000);
      const lock = JSON.parse(lockResult.stdout);
      const stillExists =
        Array.isArray(lock.skills) && lock.skills.some((s: any) => s.slug === slug);
      if (stillExists) {
        res.status(500).json({
          error: "Uninstall verification failed: skill still present in lock.json",
          stdout: result.stdout,
          stderr: result.stderr,
        });
        return;
      }
    } catch {
      // lock.json not found or empty = skill is removed, which is fine
    }

    res.json({ success: true, stdout: result.stdout, stderr: result.stderr });
  } catch (err) {
    console.error("Hub uninstall error:", err);
    res.status(500).json({ error: "Skill uninstall failed", details: String(err) });
  }
});

// ── GET /api/instances/:userId/skills/hub-list ──
skillsRouter.get("/hub-list", async (req: Request<{ userId: string }>, res: Response) => {
  try {
    const { userId } = req.params;

    const check = await ensureInstanceReady(userId);
    if (!check.ok) {
      res.status(check.status).json({ error: check.error });
      return;
    }

    const podName = await findPodName(userId);
    if (!podName) {
      res.status(503).json({ error: `No running pod found for ${userId}` });
      return;
    }

    const result = await execInPod(podName, ["cat", "/data/.clawhub/lock.json"], 10_000);
    try {
      const parsed = JSON.parse(result.stdout);
      res.json(parsed);
    } catch {
      res.json({ skills: [], raw: result.stdout });
    }
  } catch (err) {
    console.error("Hub list error:", err);
    res.status(500).json({ error: "Skill list failed", details: String(err) });
  }
});
