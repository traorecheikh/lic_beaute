import { createHash } from "node:crypto";

import { config } from "../config.js";
import { logger } from "./logger.js";
import { getCacheRedis } from "./redis.js";
import { prisma } from "./db/prisma.js";

export type RateLimitKey =
  | { type: "ip"; ip: string }
  | { type: "email"; email: string }
  | { type: "phone"; phone: string }
  | { type: "user"; userId: string }
  | { type: "challenge"; challengeId: string }
  | { type: "payment"; paymentId: string }
  | { type: "booking"; bookingId: string }
  | { type: "custom"; suffix: string };

export interface RateLimitResult {
  allowed: boolean;
  remaining: number;
  retryAfterSeconds: number;
  total: number;
}

interface RateLimitState {
  count: number;
  resetAt: number;
}

function buildKey(prefix: string, keys: RateLimitKey[]): string {
  const parts = [prefix];
  for (const k of keys) {
    switch (k.type) {
      case "ip": parts.push(`ip:${k.ip}`); break;
      case "email": parts.push(`email:${hashIdentifier(k.email)}`); break;
      case "phone": parts.push(`phone:${hashIdentifier(k.phone)}`); break;
      case "user": parts.push(`user:${k.userId}`); break;
      case "challenge": parts.push(`ch:${k.challengeId}`); break;
      case "payment": parts.push(`pay:${k.paymentId}`); break;
      case "booking": parts.push(`bk:${k.bookingId}`); break;
      case "custom": parts.push(k.suffix); break;
    }
  }
  return parts.join(":");
}

function hashIdentifier(value: string): string {
  return createHash("sha256").update(value.toLowerCase().trim()).digest("hex").slice(0, 16);
}

function getClientIp(request: { ip?: string; headers?: Record<string, string | string[] | undefined> }): string {
  if (request.headers) {
    const forwarded = request.headers["x-forwarded-for"];
    if (typeof forwarded === "string") {
      const firstIp = forwarded.split(",")[0]?.trim();
      if (firstIp) return firstIp;
    }
  }
  return request.ip ?? "unknown";
}

/**
 * Check rate limit with Redis-first approach, DB fallback.
 *
 * @param prefix - Rate limit namespace (e.g. "rl:forgot-password")
 * @param keys - Composite keys (e.g. [{type:"ip",ip}, {type:"email",email}])
 * @param maxRequests - Maximum number of requests allowed in the window
 * @param windowSeconds - Time window in seconds
 * @returns RateLimitResult with whether the request is allowed
 */
export async function checkRateLimit(
  prefix: string,
  keys: RateLimitKey[],
  maxRequests: number,
  windowSeconds: number
): Promise<RateLimitResult> {
  const compositeKey = buildKey(prefix, keys);
  const now = Date.now();
  const windowMs = windowSeconds * 1000;

  // Try Redis first
  if (config.redisUrl) {
    try {
      const redis = await getCacheRedis();
      if (redis) {
        const redisKey = `ratelimit:${compositeKey}`;
        const current = await redis.incr(redisKey);
        if (current === 1) {
          await redis.pexpire(redisKey, windowMs);
        }
        const ttl = await redis.pttl(redisKey);
        const remaining = Math.max(0, maxRequests - current);
        const retryAfterSeconds = Math.ceil(ttl / 1000);

        if (current > maxRequests) {
          return { allowed: false, remaining: 0, retryAfterSeconds, total: current };
        }
        return { allowed: true, remaining, retryAfterSeconds: 0, total: current };
      }
    } catch (err) {
      logger.warn("[RATE-LIMIT] Redis check failed, falling back to DB", { prefix, err: String(err) });
    }
  }

  // DB fallback using PlatformSetting
  try {
    const dbKey = `rl:${compositeKey}`;
    const existing = await prisma.platformSetting.findUnique({
      where: { key: dbKey },
      select: { value: true }
    });

    if (existing) {
      let state: RateLimitState;
      try {
        state = JSON.parse(existing.value) as RateLimitState;
      } catch {
        state = { count: 0, resetAt: now + windowMs };
      }

      if (now < state.resetAt) {
        const newCount = state.count + 1;
        const retryAfterSeconds = Math.ceil((state.resetAt - now) / 1000);
        const remaining = Math.max(0, maxRequests - newCount);

        try {
          await prisma.platformSetting.update({
            where: { key: dbKey },
            data: { value: JSON.stringify({ count: newCount, resetAt: state.resetAt }) }
          });
        } catch {
          // DB update failed, continue with best-effort
        }

        if (newCount > maxRequests) {
          return { allowed: false, remaining: 0, retryAfterSeconds, total: newCount };
        }
        return { allowed: true, remaining, retryAfterSeconds: 0, total: newCount };
      }
    }

    // New window or expired
    try {
      await prisma.platformSetting.upsert({
        where: { key: dbKey },
        create: {
          group: "security",
          key: dbKey,
          value: JSON.stringify({ count: 1, resetAt: now + windowMs }),
          description: `Rate limit: ${prefix}`
        },
        update: {
          value: JSON.stringify({ count: 1, resetAt: now + windowMs })
        }
      });
    } catch {
      // DB upsert failed, continue with best-effort
    }

    return { allowed: true, remaining: maxRequests - 1, retryAfterSeconds: 0, total: 1 };
  } catch (err) {
    logger.warn("[RATE-LIMIT] DB fallback failed, allowing request", { prefix, err: String(err) });
    // Fail open: if rate limiting is unavailable, allow the request
    return { allowed: true, remaining: 1, retryAfterSeconds: 0, total: 0 };
  }
}

/**
 * Convenience wrapper for per-account + per-IP rate limiting.
 */
export async function checkAccountRateLimit(
  action: string,
  accountIdentifier: string,
  request: { ip?: string; headers?: Record<string, string | string[] | undefined> },
  maxPerAccount: number,
  maxPerIp: number,
  windowSeconds: number
): Promise<RateLimitResult> {
  const ip = getClientIp(request);
  const prefix = `rl:${action}`;

  // Check per-account limit first (stricter)
  const accountResult = await checkRateLimit(
    prefix,
    [{ type: "custom", suffix: `account:${hashIdentifier(accountIdentifier)}` }],
    maxPerAccount,
    windowSeconds
  );

  if (!accountResult.allowed) {
    return accountResult;
  }

  // Then check per-IP limit
  return checkRateLimit(
    prefix,
    [{ type: "ip", ip }],
    maxPerIp,
    windowSeconds
  );
}

export { getClientIp, hashIdentifier };
