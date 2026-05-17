import { config } from "../config.js";
import { logger } from "./logger.js";
import { getCacheRedis } from "./redis.js";

function versionedKey(key: string) {
  return `${config.cacheVersion}:${key}`;
}

function tagKey(tag: string) {
  return `cache:tag:${config.cacheVersion}:${tag}`;
}

export async function getOrSetCachedJson<T>(input: {
  key: string;
  ttlSeconds: number;
  tags: string[];
  load: () => Promise<T>;
}): Promise<{ value: T; cacheStatus: "HIT" | "MISS" | "BYPASS" }> {
  if (!config.cacheEnabled || !config.redisUrl) {
    return { value: await input.load(), cacheStatus: "BYPASS" };
  }
  const redis = await getCacheRedis();
  if (!redis) return { value: await input.load(), cacheStatus: "BYPASS" };

  try {
    const resolvedKey = versionedKey(input.key);
    const cached = await redis.get(resolvedKey);
    if (cached) {
      return { value: JSON.parse(cached) as T, cacheStatus: "HIT" };
    }

    const value = await input.load();
    const serialized = JSON.stringify(value);
    await redis.set(resolvedKey, serialized, "EX", input.ttlSeconds);
    for (const tag of input.tags) {
      await redis.sadd(tagKey(tag), resolvedKey);
      await redis.expire(tagKey(tag), Math.max(input.ttlSeconds, 120));
    }
    return { value, cacheStatus: "MISS" };
  } catch (err) {
    logger.warn("[CACHE] getOrSet failed", { key: input.key, err: String(err) });
    return { value: await input.load(), cacheStatus: "BYPASS" };
  }
}

export async function getCachedJson<T>(key: string): Promise<T | null> {
  if (!config.cacheEnabled || !config.redisUrl) return null;
  const redis = await getCacheRedis();
  if (!redis) return null;
  try {
    const cached = await redis.get(versionedKey(key));
    if (!cached) return null;
    return JSON.parse(cached) as T;
  } catch (err) {
    logger.warn("[CACHE] get failed", { key, err: String(err) });
    return null;
  }
}

export async function setCachedJsonWithTags<T>(input: {
  key: string;
  value: T;
  ttlSeconds: number;
  tags: string[];
}) {
  if (!config.cacheEnabled || !config.redisUrl) return;
  const redis = await getCacheRedis();
  if (!redis) return;
  try {
    const resolvedKey = versionedKey(input.key);
    await redis.set(resolvedKey, JSON.stringify(input.value), "EX", input.ttlSeconds);
    for (const tag of input.tags) {
      await redis.sadd(tagKey(tag), resolvedKey);
      await redis.expire(tagKey(tag), Math.max(input.ttlSeconds, 120));
    }
  } catch (err) {
    logger.warn("[CACHE] set failed", { key: input.key, err: String(err) });
  }
}

export async function invalidateCacheTags(tags: string[]) {
  if (!config.cacheEnabled || !config.redisUrl || tags.length === 0) return;
  const redis = await getCacheRedis();
  if (!redis) return;

  try {
    for (const tag of tags) {
      const keys = await redis.smembers(tagKey(tag));
      if (keys.length > 0) {
        await redis.del(...keys);
      }
      await redis.del(tagKey(tag));
    }
  } catch (err) {
    logger.warn("[CACHE] invalidate failed", { tags, err: String(err) });
  }
}
