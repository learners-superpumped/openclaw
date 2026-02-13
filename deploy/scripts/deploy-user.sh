#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHART_DIR="${SCRIPT_DIR}/../helm/openclaw"
NAMESPACE="openclaw"

usage() {
  cat <<EOF
Usage: $(basename "$0") <command> <userId> [values-file]

Commands:
  install   Install a new user instance
  upgrade   Upgrade an existing user instance
  delete    Delete a user instance (PVC preserved)
  purge     Delete a user instance including PVC
  status    Show pod status for a user

Examples:
  $(basename "$0") install alice users/alice.yaml
  $(basename "$0") status alice
  $(basename "$0") delete alice
EOF
  exit 1
}

[[ $# -lt 2 ]] && usage

COMMAND="$1"
USER_ID="$2"
VALUES_FILE="${3:-}"
RELEASE_NAME="${USER_ID}-openclaw"

case "$COMMAND" in
  install)
    [[ -z "$VALUES_FILE" ]] && { echo "Error: values file required for install"; exit 1; }
    echo "Installing OpenClaw instance for user: ${USER_ID}"
    helm install "$RELEASE_NAME" "$CHART_DIR" \
      -f "$VALUES_FILE" \
      -n "$NAMESPACE" \
      --create-namespace
    ;;
  upgrade)
    [[ -z "$VALUES_FILE" ]] && { echo "Error: values file required for upgrade"; exit 1; }
    echo "Upgrading OpenClaw instance for user: ${USER_ID}"
    helm upgrade "$RELEASE_NAME" "$CHART_DIR" \
      -f "$VALUES_FILE" \
      -n "$NAMESPACE"
    ;;
  delete)
    echo "Deleting OpenClaw instance for user: ${USER_ID} (PVC preserved)"
    helm uninstall "$RELEASE_NAME" -n "$NAMESPACE"
    echo "PVC ${USER_ID}-openclaw-data is preserved. Delete manually if needed:"
    echo "  kubectl delete pvc ${USER_ID}-openclaw-data -n ${NAMESPACE}"
    ;;
  purge)
    echo "Purging OpenClaw instance for user: ${USER_ID} (including PVC)"
    helm uninstall "$RELEASE_NAME" -n "$NAMESPACE" || true
    kubectl delete pvc "${USER_ID}-openclaw-data" -n "$NAMESPACE" --ignore-not-found
    ;;
  status)
    echo "Status for user: ${USER_ID}"
    kubectl get pods,svc,ingress,managedcertificate -n "$NAMESPACE" -l "openclaw.ai/user=${USER_ID}"
    ;;
  *)
    usage
    ;;
esac
