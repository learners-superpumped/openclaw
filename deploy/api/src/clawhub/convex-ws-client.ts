import { WebSocket } from "ws";

const DEFAULT_SYNC_URL = "wss://wry-manatee-359.convex.cloud/api/1.31.7/sync";
const TIMEOUT_MS = 10_000;

interface CallConvexActionOptions {
  syncUrl?: string;
  udfPath: string;
  args: Record<string, unknown>;
}

export async function callConvexAction<T>(options: CallConvexActionOptions): Promise<T> {
  const { syncUrl = DEFAULT_SYNC_URL, udfPath, args } = options;

  return new Promise<T>((resolve, reject) => {
    const ws = new WebSocket(syncUrl);
    const requestId = 0;

    const timer = setTimeout(() => {
      ws.close();
      reject(new Error(`Convex action timed out after ${TIMEOUT_MS}ms`));
    }, TIMEOUT_MS);

    ws.on("open", () => {
      ws.send(
        JSON.stringify({
          type: "Action",
          requestId,
          udfPath,
          args: [args],
        }),
      );
    });

    ws.on("message", (raw: Buffer) => {
      try {
        const msg = JSON.parse(raw.toString());
        if (msg.type === "ActionResponse" && msg.requestId === requestId) {
          clearTimeout(timer);
          ws.close();
          if (msg.success) {
            resolve(msg.result as T);
          } else {
            reject(new Error(msg.errorMessage ?? "Convex action failed"));
          }
        }
      } catch {
        // ignore non-JSON frames
      }
    });

    ws.on("error", (err) => {
      clearTimeout(timer);
      reject(err);
    });
  });
}
