import type { GatewayRequestHandlers } from "./types.js";
import { normalizeChannelId } from "../../channels/plugins/index.js";
import { listPairingChannels, notifyPairingApproved } from "../../channels/plugins/pairing.js";
import { loadConfig } from "../../config/config.js";
import {
  approveChannelPairingCode,
  listChannelPairingRequests,
  type PairingChannel,
} from "../../pairing/pairing-store.js";
import { ErrorCodes, errorShape } from "../protocol/index.js";

const CHANNEL_RE = /^[a-z][a-z0-9_-]{0,63}$/;

function resolveChannel(raw: unknown): PairingChannel | null {
  if (typeof raw !== "string") {
    return null;
  }
  const value = raw.trim().toLowerCase();
  if (!value) {
    return null;
  }

  const normalized = normalizeChannelId(value);
  if (normalized) {
    const channels = listPairingChannels();
    return channels.includes(normalized) ? normalized : null;
  }

  // Allow extension channels
  return CHANNEL_RE.test(value) ? (value as PairingChannel) : null;
}

export const channelPairingHandlers: GatewayRequestHandlers = {
  "channel.pairing.list": async ({ params, respond }) => {
    const channel = resolveChannel(params.channel);
    if (!channel) {
      respond(
        false,
        undefined,
        errorShape(
          ErrorCodes.INVALID_REQUEST,
          "channel is required and must be a valid channel ID",
        ),
      );
      return;
    }

    const requests = await listChannelPairingRequests(channel);
    respond(true, { channel, requests }, undefined);
  },

  "channel.pairing.approve": async ({ params, respond, context }) => {
    const channel = resolveChannel(params.channel);
    if (!channel) {
      respond(
        false,
        undefined,
        errorShape(
          ErrorCodes.INVALID_REQUEST,
          "channel is required and must be a valid channel ID",
        ),
      );
      return;
    }

    const code = typeof params.code === "string" ? params.code.trim() : "";
    if (!code) {
      respond(false, undefined, errorShape(ErrorCodes.INVALID_REQUEST, "code is required"));
      return;
    }

    const approved = await approveChannelPairingCode({ channel, code });
    if (!approved) {
      respond(
        false,
        undefined,
        errorShape(
          ErrorCodes.INVALID_REQUEST,
          `No pending pairing request found for code: ${code}`,
        ),
      );
      return;
    }

    context.logGateway.info(`channel pairing approved channel=${channel} id=${approved.id}`);

    if (params.notify) {
      const cfg = loadConfig();
      notifyPairingApproved({ channelId: channel, id: approved.id, cfg }).catch((err) => {
        context.logGateway.error(`Failed to notify pairing approval: ${String(err)}`);
      });
    }

    respond(true, { approved: true, id: approved.id, entry: approved.entry }, undefined);
  },
};
