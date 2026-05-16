import { Redis } from "ioredis";

import { config } from "../config.js";
import { logger } from "./logger.js";

let _queueRedis: Redis | null = null;
let _cacheRedis: Redis | null = null;

function buildRedisClient() {
  return new Redis(config.redisUrl, {
    lazyConnect: true,
    maxRetriesPerRequest: null,
    enableOfflineQueue: true
  });
}

export async function getQueueRedis(): Promise<Redis | null> {
  if (!config.redisUrl) return null;
  if (!_queueRedis) _queueRedis = buildRedisClient();
  if (_queueRedis.status !== "ready") {
    try {
      await _queueRedis.connect();
    } catch (err) {
      logger.warn("[REDIS] queue connect failed", { err: String(err) });
      return null;
    }
  }
  return _queueRedis;
}

export async function getCacheRedis(): Promise<Redis | null> {
  if (!config.redisUrl) return null;
  if (!_cacheRedis) _cacheRedis = buildRedisClient();
  if (_cacheRedis.status !== "ready") {
    try {
      await _cacheRedis.connect();
    } catch (err) {
      logger.warn("[REDIS] cache connect failed", { err: String(err) });
      return null;
    }
  }
  return _cacheRedis;
}

export async function closeRedisConnections() {
  if (_queueRedis) {
    await _queueRedis.quit().catch(() => {});
    _queueRedis = null;
  }
  if (_cacheRedis) {
    await _cacheRedis.quit().catch(() => {});
    _cacheRedis = null;
  }
}
