import { createHash } from "node:crypto";

import { config } from "../config.js";
import { logger } from "./logger.js";
import { getCacheRedis } from "./redis.js";
import { prisma } from "./db/prisma.js";

// ─── Sliding window ─────────────────────────────────────────────────────────
// The window exceeds PayDunya's delivery timeout (~30 s) so retries don't
// register as replays; 5 min is well past any legitimate redelivery interval.
const REPLAY_WINDOW_MS = 5 * 60 * 1_000;

// In-memory fallback: used when both Redis and DB are unavailable.
const inMemoryNonces = new Map<string, number>();

function hashNonce(nonce: string): string {
  return createHash("sha256").update(nonce).digest("hex").slice(0, 16);
}

function evictStaleInMemory() {
  if (inMemoryNonces.size > 500) {
    const cutoff = Date.now() - REPLAY_WINDOW_MS;
    for (const [key, ts] of inMemoryNonces) {
      if (ts < cutoff) inMemoryNonces.delete(key);
    }
  }
}

/**
 * Check whether a webhook nonce has already been processed within the replay
 * window. If not seen, records it for future checks.
 *
 * Strategy (tiered):
 * 1. Redis SET NX with TTL (atomic, auto-expiry) — primary
 * 2. DB PlatformSetting upsert — fallback when Redis is unavailable
 * 3. In-memory Map — last resort when both are down
 *
 * Returns `true` if the nonce is a replay (already seen within window).
 */
export async function checkWebhookReplay(nonce: string): Promise<boolean> {
  const key = `webhook:nonce:${hashNonce(nonce)}`;

  // ── Tier 1: Redis (atomic SET NX + PEXPIRE) ──────────────────────────
  if (config.redisUrl) {
    try {
      const redis = await getCacheRedis();
      if (redis) {
        const set = await redis.set(key, String(Date.now()), "PX", REPLAY_WINDOW_MS, "NX");
        if (set === "OK") return false; // First time seeing this nonce
        // Key already exists — this is a replay
        logger.warn("[WEBHOOK-REPLAY] Replay detected via Redis", { nonce: hashNonce(nonce) });
        return true;
      }
    } catch (err) {
      logger.warn("[WEBHOOK-REPLAY] Redis check failed, falling back to DB", {
        err: String(err)
      });
    }
  }

  // ── Tier 2: DB (PlatformSetting with TTL tracked via timestamp) ──────
  try {
    const dbKey = `replay:${hashNonce(nonce)}`;
    const existing = await prisma.platformSetting.findUnique({
      where: { key: dbKey },
      select: { value: true }
    });

    if (existing) {
      const ts = Number(existing.value);
      if (Number.isFinite(ts) && Date.now() - ts < REPLAY_WINDOW_MS) {
        logger.warn("[WEBHOOK-REPLAY] Replay detected via DB", { nonce: hashNonce(nonce) });
        return true;
      }
      // Expired — update timestamp for new window
      await prisma.platformSetting.update({
        where: { key: dbKey },
        data: { value: String(Date.now()) }
      });
      return false;
    }

    // New nonce — create entry
    await prisma.platformSetting.create({
      data: {
        group: "webhook_anti_replay",
        key: dbKey,
        value: String(Date.now()),
        description: `Webhook anti-replay nonce (TTL: ${REPLAY_WINDOW_MS}ms)`
      }
    });
    return false;
  } catch (err) {
    logger.warn("[WEBHOOK-REPLAY] DB fallback failed, falling back to in-memory", {
      err: String(err)
    });
  }

  // ── Tier 3: In-memory (last resort) ───────────────────────────────────
  const now = Date.now();
  const seenAt = inMemoryNonces.get(nonce);
  if (seenAt && now - seenAt < REPLAY_WINDOW_MS) {
    logger.warn("[WEBHOOK-REPLAY] Replay detected via in-memory Map", { nonce: hashNonce(nonce) });
    return true;
  }
  evictStaleInMemory();
  inMemoryNonces.set(nonce, now);
  return false;
}
