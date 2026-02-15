import type * as k8s from "@kubernetes/client-node";
import { config } from "../config.js";

function resourceName(userId: string): string {
  return `${userId}-openclaw`;
}

function pvcName(userId: string): string {
  return `${userId}-openclaw-data`;
}

function host(userId: string): string {
  return `${userId}.${config.domain.base}`;
}

function labels(userId: string): Record<string, string> {
  return {
    "app.kubernetes.io/name": "openclaw",
    "app.kubernetes.io/instance": userId,
    "app.kubernetes.io/managed-by": "openclaw-manager",
    "openclaw.ai/user": userId,
  };
}

function selectorLabels(userId: string): Record<string, string> {
  return {
    "app.kubernetes.io/name": "openclaw",
    "app.kubernetes.io/instance": userId,
  };
}

export interface CreateInstanceParams {
  userId: string;
  secrets: Record<string, string>;
  persistence?: { size?: string };
  imageTag?: string;
}

export function buildSecret(params: CreateInstanceParams): k8s.V1Secret {
  const name = resourceName(params.userId);
  return {
    apiVersion: "v1",
    kind: "Secret",
    metadata: {
      name,
      namespace: config.namespace,
      labels: labels(params.userId),
    },
    stringData: params.secrets,
  };
}

export function buildConfigMap(params: CreateInstanceParams): k8s.V1ConfigMap {
  const name = resourceName(params.userId);
  return {
    apiVersion: "v1",
    kind: "ConfigMap",
    metadata: {
      name,
      namespace: config.namespace,
      labels: labels(params.userId),
    },
    data: {
      NODE_ENV: "production",
      OPENCLAW_STATE_DIR: "/data",
      OPENCLAW_HOME: "/data",
      OPENCLAW_PREFER_PNPM: "1",
      "openclaw.json": JSON.stringify({
        gateway: { mode: "local" },
        browser: { enabled: true, noSandbox: true },
        cron: { enabled: true },
        commands: { native: "auto", nativeSkills: "auto" },
        plugins: {
          entries: {
            whatsapp: { enabled: true },
            telegram: { enabled: true },
          },
        },
        agents: {
          defaults: {
            model: { primary: "openrouter/openai/gpt-5-nano" },
          },
        },
      }),
    },
  };
}

export function buildPVC(params: CreateInstanceParams): k8s.V1PersistentVolumeClaim {
  const name = pvcName(params.userId);
  return {
    apiVersion: "v1",
    kind: "PersistentVolumeClaim",
    metadata: {
      name,
      namespace: config.namespace,
      labels: labels(params.userId),
    },
    spec: {
      accessModes: ["ReadWriteOnce"],
      storageClassName: config.persistence.storageClass,
      resources: {
        requests: {
          storage: params.persistence?.size || config.persistence.defaultSize,
        },
      },
    },
  };
}

export function buildDeployment(params: CreateInstanceParams): k8s.V1Deployment {
  const name = resourceName(params.userId);
  const tag = params.imageTag || config.image.tag;
  return {
    apiVersion: "apps/v1",
    kind: "Deployment",
    metadata: {
      name,
      namespace: config.namespace,
      labels: labels(params.userId),
    },
    spec: {
      replicas: 1,
      strategy: { type: "Recreate" },
      selector: { matchLabels: selectorLabels(params.userId) },
      template: {
        metadata: { labels: labels(params.userId) },
        spec: {
          tolerations: [
            {
              key: "kubernetes.io/arch",
              operator: "Equal",
              value: "amd64",
              effect: "NoSchedule",
            },
          ],
          securityContext: {
            runAsUser: 1000,
            runAsGroup: 1000,
            fsGroup: 1000,
            seccompProfile: { type: "RuntimeDefault" },
          },
          initContainers: [
            {
              name: "init-config",
              image: "busybox:1.36",
              command: [
                "sh",
                "-c",
                "if [ ! -f /data/openclaw.json ]; then cp /config-defaults/openclaw.json /data/openclaw.json; echo 'Copied default config'; else echo 'Config already exists, skipping'; fi",
              ],
              volumeMounts: [
                { name: "data", mountPath: "/data" },
                { name: "config", mountPath: "/config-defaults", readOnly: true },
              ],
              securityContext: {
                allowPrivilegeEscalation: false,
                capabilities: { drop: ["ALL"] },
              },
            },
          ],
          containers: [
            {
              name: "gateway",
              image: `${config.image.repository}:${tag}`,
              imagePullPolicy: "IfNotPresent",
              command: [
                "node",
                "dist/index.js",
                "gateway",
                "--allow-unconfigured",
                "--bind",
                "lan",
                "--port",
                String(config.gateway.port),
              ],
              ports: [
                {
                  name: "http",
                  containerPort: config.gateway.port,
                  protocol: "TCP",
                },
              ],
              envFrom: [{ configMapRef: { name } }, { secretRef: { name } }],
              volumeMounts: [
                { name: "data", mountPath: "/data" },
                { name: "dshm", mountPath: "/dev/shm" },
              ],
              resources: {
                requests: {
                  cpu: config.resources.cpu,
                  memory: config.resources.memory,
                },
                limits: {
                  cpu: config.resources.cpu,
                  memory: config.resources.memory,
                },
              },
              securityContext: {
                allowPrivilegeEscalation: false,
                capabilities: { drop: ["NET_RAW"] },
              },
              readinessProbe: {
                tcpSocket: { port: config.gateway.port },
                initialDelaySeconds: 10,
                periodSeconds: 15,
              },
              livenessProbe: {
                tcpSocket: { port: config.gateway.port },
                initialDelaySeconds: 30,
                periodSeconds: 30,
              },
            },
          ],
          volumes: [
            {
              name: "data",
              persistentVolumeClaim: { claimName: pvcName(params.userId) },
            },
            {
              name: "dshm",
              emptyDir: { medium: "Memory", sizeLimit: "256Mi" },
            },
            {
              name: "config",
              configMap: {
                name: resourceName(params.userId),
                items: [{ key: "openclaw.json", path: "openclaw.json" }],
              },
            },
          ],
        },
      },
    },
  };
}

export function buildService(params: CreateInstanceParams): k8s.V1Service {
  const name = resourceName(params.userId);
  return {
    apiVersion: "v1",
    kind: "Service",
    metadata: {
      name,
      namespace: config.namespace,
      labels: labels(params.userId),
    },
    spec: {
      type: "ClusterIP",
      ports: [
        {
          port: config.gateway.port,
          targetPort: "http",
          protocol: "TCP",
          name: "http",
        },
        {
          port: config.browser.novncPort,
          targetPort: "novnc",
          protocol: "TCP",
          name: "novnc",
        },
      ],
      selector: selectorLabels(params.userId),
    },
  };
}

export function buildIngress(params: CreateInstanceParams): k8s.V1Ingress {
  const name = resourceName(params.userId);
  return {
    apiVersion: "networking.k8s.io/v1",
    kind: "Ingress",
    metadata: {
      name,
      namespace: config.namespace,
      labels: labels(params.userId),
      annotations: {
        "kubernetes.io/ingress.class": "gce",
        "networking.gke.io/managed-certificates": name,
      },
    },
    spec: {
      rules: [
        {
          host: host(params.userId),
          http: {
            paths: [
              {
                path: "/",
                pathType: "Prefix",
                backend: {
                  service: {
                    name,
                    port: { number: config.gateway.port },
                  },
                },
              },
            ],
          },
        },
      ],
    },
  };
}

export function buildManagedCertificate(params: CreateInstanceParams): object {
  const name = resourceName(params.userId);
  return {
    apiVersion: "networking.gke.io/v1",
    kind: "ManagedCertificate",
    metadata: {
      name,
      namespace: config.namespace,
      labels: labels(params.userId),
    },
    spec: {
      domains: [host(params.userId)],
    },
  };
}

export { resourceName, pvcName, host };
