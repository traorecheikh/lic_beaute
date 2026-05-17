import crypto from "node:crypto";

import { config } from "../config.js";
import { logger } from "./logger.js";
import { prisma } from "./db/prisma.js";

type FcmServiceAccount = {
  project_id: string;
  client_email: string;
  private_key: string;
};

function decodeAndValidateFcm(): FcmServiceAccount | null {
  if (config.pushDriver !== "fcm") return null;
  if (!config.fcmServiceAccountJsonB64) {
    if (config.nodeEnv === "production") {
      throw new Error("FCM_SERVICE_ACCOUNT_JSON_B64 is required in production when PUSH_DRIVER=fcm");
    }
    logger.warn("[PUSH] FCM_SERVICE_ACCOUNT_JSON_B64 not set — push delivery disabled");
    return null;
  }

  try {
    const raw = Buffer.from(config.fcmServiceAccountJsonB64, "base64").toString("utf8");
    const parsed = JSON.parse(raw);
    if (!parsed.project_id || !parsed.client_email || !parsed.private_key) {
      throw new Error("FCM service account JSON missing required fields (project_id, client_email, private_key)");
    }
    return parsed as FcmServiceAccount;
  } catch (err) {
    if (config.nodeEnv === "production") {
      throw new Error(`FCM_SERVICE_ACCOUNT_JSON_B64 decode failed: ${String(err)}`);
    }
    logger.warn("[PUSH] FCM_SERVICE_ACCOUNT_JSON_B64 decode failed — push delivery disabled", { err: String(err) });
    return null;
  }
}

export const fcmServiceAccount = decodeAndValidateFcm();

// Cache the OAuth2 access token to avoid a service-account round-trip per push.
let _cachedToken: { token: string; expiresAt: number } | null = null;

function signJwt(payload: Record<string, unknown>, privateKey: string): string {
  const header = Buffer.from(JSON.stringify({ alg: "RS256", typ: "JWT" })).toString("base64url");
  const body = Buffer.from(JSON.stringify(payload)).toString("base64url");
  const sigInput = `${header}.${body}`;
  const signature = crypto
    .sign("sha256", Buffer.from(sigInput), {
      key: privateKey,
      format: "pem",
      padding: crypto.constants.RSA_PKCS1_PADDING
    })
    .toString("base64url");
  return `${sigInput}.${signature}`;
}

async function getAccessToken(sa: FcmServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  if (_cachedToken && _cachedToken.expiresAt > now + 60) {
    return _cachedToken.token;
  }

  const jwt = signJwt(
    {
      iss: sa.client_email,
      scope: "https://www.googleapis.com/auth/firebase.messaging",
      aud: "https://oauth2.googleapis.com/token",
      iat: now,
      exp: now + 3600
    },
    sa.private_key
  );

  const resp = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt
    })
  });

  if (!resp.ok) {
    const text = await resp.text().catch(() => "");
    throw new Error(`FCM OAuth2 token exchange failed (${resp.status}): ${text}`);
  }

  const data = (await resp.json()) as { access_token: string; expires_in?: number };
  const token = data.access_token;
  const expiresIn = typeof data.expires_in === "number" ? data.expires_in : 3600;
  _cachedToken = { token, expiresAt: now + expiresIn };
  return token;
}

export async function sendPush(
  pushToken: string,
  message: { title: string; body: string },
  data?: Record<string, string>
) {
  if (!fcmServiceAccount) {
    logger.warn("[PUSH] sendPush skipped — no FCM service account available", { pushToken });
    return;
  }

  try {
    const accessToken = await getAccessToken(fcmServiceAccount);
    const url = `https://fcm.googleapis.com/v1/projects/${fcmServiceAccount.project_id}/messages:send`;

    const payload: Record<string, unknown> = {
      token: pushToken,
      notification: { title: message.title, body: message.body }
    };
    if (data) payload.data = data;

    const resp = await fetch(url, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ message: payload })
    });

    if (!resp.ok) {
      const text = await resp.text().catch(() => "");
      logger.error("[PUSH] FCM delivery failed", { pushToken, status: resp.status, body: text });
      // Hard failures (404 = unregistered, 400 = invalid token) mean the token is dead.
      if (resp.status === 404 || resp.status === 400) {
        await prisma.pushToken.updateMany({
          where: { token: pushToken, revokedAt: null },
          data: { revokedAt: new Date() }
        }).catch(() => {});
      }
      return;
    }

    logger.info("[PUSH] FCM message sent", { pushToken, title: message.title });
  } catch (err) {
    logger.error("[PUSH] sendPush error", { pushToken, error: String(err) });
  }
}

export async function sendPushBatch(
  tokens: string[],
  message: { title: string; body: string },
  data?: Record<string, string>
): Promise<void> {
  await Promise.allSettled(tokens.map((token) => sendPush(token, message, data)));
}
