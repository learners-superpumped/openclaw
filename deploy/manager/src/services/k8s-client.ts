import * as k8s from "@kubernetes/client-node";
import { config } from "../config.js";

const kc = new k8s.KubeConfig();
kc.loadFromCluster();

export const coreApi = kc.makeApiClient(k8s.CoreV1Api);
export const appsApi = kc.makeApiClient(k8s.AppsV1Api);
export const networkingApi = kc.makeApiClient(k8s.NetworkingV1Api);
export const customApi = kc.makeApiClient(k8s.CustomObjectsApi);

const ns = config.namespace;

// ── Deployments ──

export async function createDeployment(body: k8s.V1Deployment): Promise<k8s.V1Deployment> {
  const res = await appsApi.createNamespacedDeployment({ namespace: ns, body });
  return res;
}

export async function getDeployment(name: string): Promise<k8s.V1Deployment | null> {
  try {
    return await appsApi.readNamespacedDeployment({ name, namespace: ns });
  } catch (e: unknown) {
    if (isNotFound(e)) {
      return null;
    }
    throw e;
  }
}

export async function deleteDeployment(name: string): Promise<void> {
  await appsApi.deleteNamespacedDeployment({ name, namespace: ns });
}

// ── Services ──

export async function createService(body: k8s.V1Service): Promise<k8s.V1Service> {
  return await coreApi.createNamespacedService({ namespace: ns, body });
}

export async function deleteService(name: string): Promise<void> {
  await coreApi.deleteNamespacedService({ name, namespace: ns });
}

// ── PVC ──

export async function createPVC(
  body: k8s.V1PersistentVolumeClaim,
): Promise<k8s.V1PersistentVolumeClaim> {
  return await coreApi.createNamespacedPersistentVolumeClaim({
    namespace: ns,
    body,
  });
}

export async function deletePVC(name: string): Promise<void> {
  await coreApi.deleteNamespacedPersistentVolumeClaim({ name, namespace: ns });
}

// ── Secrets ──

export async function createSecret(body: k8s.V1Secret): Promise<k8s.V1Secret> {
  return await coreApi.createNamespacedSecret({ namespace: ns, body });
}

export async function replaceSecret(name: string, body: k8s.V1Secret): Promise<k8s.V1Secret> {
  return await coreApi.replaceNamespacedSecret({ name, namespace: ns, body });
}

export async function createOrReplaceSecret(body: k8s.V1Secret): Promise<k8s.V1Secret> {
  const name = body.metadata?.name;
  if (!name) {
    throw new Error("Secret must have a name");
  }
  try {
    return await createSecret(body);
  } catch (e: unknown) {
    if (isConflict(e)) {
      return await replaceSecret(name, body);
    }
    throw e;
  }
}

export async function deleteSecret(name: string): Promise<void> {
  await coreApi.deleteNamespacedSecret({ name, namespace: ns });
}

// ── ConfigMaps ──

export async function createConfigMap(body: k8s.V1ConfigMap): Promise<k8s.V1ConfigMap> {
  return await coreApi.createNamespacedConfigMap({ namespace: ns, body });
}

export async function replaceConfigMap(
  name: string,
  body: k8s.V1ConfigMap,
): Promise<k8s.V1ConfigMap> {
  return await coreApi.replaceNamespacedConfigMap({ name, namespace: ns, body });
}

export async function createOrReplaceConfigMap(body: k8s.V1ConfigMap): Promise<k8s.V1ConfigMap> {
  const name = body.metadata?.name;
  if (!name) {
    throw new Error("ConfigMap must have a name");
  }
  try {
    return await createConfigMap(body);
  } catch (e: unknown) {
    if (isConflict(e)) {
      return await replaceConfigMap(name, body);
    }
    throw e;
  }
}

export async function deleteConfigMap(name: string): Promise<void> {
  await coreApi.deleteNamespacedConfigMap({ name, namespace: ns });
}

// ── Ingress ──

export async function createIngress(body: k8s.V1Ingress): Promise<k8s.V1Ingress> {
  return await networkingApi.createNamespacedIngress({ namespace: ns, body });
}

export async function getIngress(name: string): Promise<k8s.V1Ingress | null> {
  try {
    return await networkingApi.readNamespacedIngress({ name, namespace: ns });
  } catch (e: unknown) {
    if (isNotFound(e)) {
      return null;
    }
    throw e;
  }
}

export async function deleteIngress(name: string): Promise<void> {
  await networkingApi.deleteNamespacedIngress({ name, namespace: ns });
}

// ── ManagedCertificate (GKE CRD) ──

const CERT_GROUP = "networking.gke.io";
const CERT_VERSION = "v1";
const CERT_PLURAL = "managedcertificates";

export async function createManagedCertificate(body: object): Promise<object> {
  return await customApi.createNamespacedCustomObject({
    group: CERT_GROUP,
    version: CERT_VERSION,
    namespace: ns,
    plural: CERT_PLURAL,
    body,
  });
}

export async function deleteManagedCertificate(name: string): Promise<void> {
  await customApi.deleteNamespacedCustomObject({
    group: CERT_GROUP,
    version: CERT_VERSION,
    namespace: ns,
    plural: CERT_PLURAL,
    name,
  });
}

// ── Pods (read-only) ──

export async function listPods(labelSelector: string): Promise<k8s.V1Pod[]> {
  const res = await coreApi.listNamespacedPod({
    namespace: ns,
    labelSelector,
  });
  return res.items;
}

// ── List all openclaw instances ──

export async function listDeployments(): Promise<k8s.V1Deployment[]> {
  const res = await appsApi.listNamespacedDeployment({
    namespace: ns,
    labelSelector: "app.kubernetes.io/name=openclaw",
  });
  return res.items;
}

// ── Helper ──

function isNotFound(e: unknown): boolean {
  if (e && typeof e === "object" && "code" in e) {
    return (e as { code: number }).code === 404;
  }
  return false;
}

function isConflict(e: unknown): boolean {
  if (e && typeof e === "object" && "code" in e) {
    return (e as { code: number }).code === 409;
  }
  return false;
}

export function ignoreNotFound(e: unknown): void {
  if (!isNotFound(e)) {
    throw e;
  }
}
