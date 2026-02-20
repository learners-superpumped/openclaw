import * as k8s from "@kubernetes/client-node";
import { readFileSync } from "node:fs";
import { Writable, Readable } from "node:stream";
import { config } from "../config.js";
import { listPods } from "./k8s-client.js";

const kc = new k8s.KubeConfig();
kc.loadFromCluster();

// Fix: loadFromCluster() uses a tokenFile authProvider which the Exec
// WebSocket client doesn't resolve. Read the SA token explicitly so that
// the WebSocket upgrade request includes the Bearer token.
try {
  const token = readFileSync("/var/run/secrets/kubernetes.io/serviceaccount/token", "utf8");
  const user = kc.getCurrentUser();
  if (user) {
    (user as { token: string }).token = token;
  }
} catch {
  // Not running in-cluster – ignore.
}

// NOTE: This uses @kubernetes/client-node's Exec class which calls the
// Kubernetes API exec endpoint directly — NOT child_process.exec().
// Commands are passed as an array to the container (like execFile),
// so there is no shell injection risk.
const k8sExec = new k8s.Exec(kc);

/**
 * Find the running pod name for a user instance.
 */
export async function findPodName(userId: string): Promise<string | null> {
  const pods = await listPods(`openclaw.ai/user=${userId}`);
  const running = pods.find((p) => p.status?.phase === "Running" && p.metadata?.name);
  return running?.metadata?.name ?? null;
}

/**
 * Execute a command in the gateway container of a user's pod.
 * Uses Kubernetes Exec API — commands are passed as an array,
 * no shell involved, so no injection risk.
 */
export async function execInPod(
  podName: string,
  command: string[],
  timeoutMs = 30_000,
): Promise<{ stdout: string; stderr: string }> {
  return new Promise((resolve, reject) => {
    let stdout = "";
    let stderr = "";
    let settled = false;

    const timer = setTimeout(() => {
      if (!settled) {
        settled = true;
        reject(new Error(`K8s exec timeout after ${timeoutMs}ms`));
      }
    }, timeoutMs);

    const stdoutStream = new Writable({
      write(chunk, _encoding, callback) {
        stdout += chunk.toString();
        callback();
      },
    });

    const stderrStream = new Writable({
      write(chunk, _encoding, callback) {
        stderr += chunk.toString();
        callback();
      },
    });

    k8sExec
      .exec(
        config.namespace,
        podName,
        "gateway",
        command,
        stdoutStream,
        stderrStream,
        null as unknown as Readable,
        false, // tty
        (status: k8s.V1Status) => {
          clearTimeout(timer);
          if (settled) {
            return;
          }
          settled = true;

          if (status.status === "Success") {
            resolve({ stdout, stderr });
          } else {
            reject(
              new Error(`K8s exec failed: ${status.message || "unknown error"}\nstderr: ${stderr}`),
            );
          }
        },
      )
      .catch((err) => {
        clearTimeout(timer);
        if (!settled) {
          settled = true;
          reject(err);
        }
      });
  });
}
