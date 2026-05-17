import { beforeEach, describe, expect, it, vi } from "vitest";

import { config } from "../config.js";

const { fakeRedis } = vi.hoisted(() => ({
  fakeRedis: {
    store: new Map<string, string>(),
    sets: new Map<string, Set<string>>(),
    async get(key: string) {
      return this.store.get(key) ?? null;
    },
    async set(key: string, value: string) {
      this.store.set(key, value);
    },
    async sadd(key: string, value: string) {
      const set = this.sets.get(key) ?? new Set<string>();
      set.add(value);
      this.sets.set(key, set);
    },
    async expire() {},
    async smembers(key: string) {
      return [...(this.sets.get(key) ?? new Set<string>())];
    },
    async del(...keys: string[]) {
      for (const key of keys) {
        this.store.delete(key);
        this.sets.delete(key);
      }
    }
  }
}));

vi.mock("./redis.js", () => ({
  getCacheRedis: vi.fn(async () => fakeRedis)
}));

import { getCacheRedis } from "./redis.js";
import { logger } from "./logger.js";
import { getCachedJson, getOrSetCachedJson, invalidateCacheTags, setCachedJsonWithTags } from "./cache.js";

describe("cache helpers", () => {
  beforeEach(() => {
    fakeRedis.store.clear();
    fakeRedis.sets.clear();
    config.cacheEnabled = true;
    config.redisUrl = "redis://unit-test";
  });

  it("sets and gets tagged JSON cache", async () => {
    await setCachedJsonWithTags({
      key: "catalog:list:test",
      value: { ok: true },
      ttlSeconds: 45,
      tags: ["catalog:list"]
    });

    const value = await getCachedJson<{ ok: boolean }>("catalog:list:test");
    expect(value).toEqual({ ok: true });
  });

  it("invalidates by tags", async () => {
    await setCachedJsonWithTags({
      key: "catalog:salon:1",
      value: { id: "1" },
      ttlSeconds: 45,
      tags: ["catalog:salon:1"]
    });

    await invalidateCacheTags(["catalog:salon:1"]);
    const value = await getCachedJson<{ id: string }>("catalog:salon:1");
    expect(value).toBeNull();
  });

  it("supports MISS then HIT through getOrSetCachedJson", async () => {
    const load = vi.fn(async () => ({ a: 1 }));
    const miss = await getOrSetCachedJson({
      key: "k1",
      ttlSeconds: 60,
      tags: ["t1"],
      load
    });
    expect(miss.cacheStatus).toBe("MISS");
    expect(load).toHaveBeenCalledTimes(1);

    const hit = await getOrSetCachedJson({
      key: "k1",
      ttlSeconds: 60,
      tags: ["t1"],
      load
    });
    expect(hit.cacheStatus).toBe("HIT");
    expect(load).toHaveBeenCalledTimes(1);
  });

  it("bypasses cache when disabled or redis unavailable", async () => {
    config.cacheEnabled = false;
    const load = vi.fn(async () => ({ ok: true }));
    const disabled = await getOrSetCachedJson({
      key: "bypass1",
      ttlSeconds: 30,
      tags: ["x"],
      load
    });
    expect(disabled.cacheStatus).toBe("BYPASS");
    expect(load).toHaveBeenCalledTimes(1);

    config.cacheEnabled = true;
    config.redisUrl = "redis://unit-test";
    vi.mocked(getCacheRedis).mockResolvedValueOnce(null as never);
    const unavailable = await getOrSetCachedJson({
      key: "bypass2",
      ttlSeconds: 30,
      tags: ["x"],
      load
    });
    expect(unavailable.cacheStatus).toBe("BYPASS");
  });

  it("falls back to BYPASS when cache get/set path throws", async () => {
    const warnSpy = vi.spyOn(logger, "warn").mockImplementation(() => undefined);
    const originalGet = fakeRedis.get;
    fakeRedis.get = vi.fn(async () => {
      throw new Error("redis-get-fail");
    }) as any;

    const load = vi.fn(async () => ({ ok: true }));
    const result = await getOrSetCachedJson({
      key: "k-fail",
      ttlSeconds: 30,
      tags: ["x"],
      load
    });
    expect(result.cacheStatus).toBe("BYPASS");
    expect(warnSpy).toHaveBeenCalledWith("[CACHE] getOrSet failed", expect.anything());
    fakeRedis.get = originalGet;
    warnSpy.mockRestore();
  });

  it("returns null and logs warning when getCachedJson throws", async () => {
    const warnSpy = vi.spyOn(logger, "warn").mockImplementation(() => undefined);
    const originalGet = fakeRedis.get;
    fakeRedis.get = vi.fn(async () => {
      throw new Error("redis-get-fail");
    }) as any;

    const value = await getCachedJson("bad-key");
    expect(value).toBeNull();
    expect(warnSpy).toHaveBeenCalledWith("[CACHE] get failed", expect.anything());
    fakeRedis.get = originalGet;
    warnSpy.mockRestore();
  });

  it("logs warning when invalidate fails", async () => {
    const warnSpy = vi.spyOn(logger, "warn").mockImplementation(() => undefined);
    const originalSmembers = fakeRedis.smembers;
    fakeRedis.smembers = vi.fn(async () => {
      throw new Error("redis-smembers-fail");
    }) as any;

    await invalidateCacheTags(["catalog:err"]);
    expect(warnSpy).toHaveBeenCalledWith("[CACHE] invalidate failed", expect.anything());
    fakeRedis.smembers = originalSmembers;
    warnSpy.mockRestore();
  });

  it("guard branches return early for missing redis/empty tags and no members", async () => {
    config.cacheEnabled = false;
    await setCachedJsonWithTags({ key: "k", value: { ok: true }, ttlSeconds: 10, tags: ["t"] });
    await invalidateCacheTags([]);

    config.cacheEnabled = true;
    config.redisUrl = "redis://unit-test";
    vi.mocked(getCacheRedis).mockResolvedValueOnce(null as never);
    await invalidateCacheTags(["tag-null-redis"]);

    const delSpy = vi.spyOn(fakeRedis, "del");
    await invalidateCacheTags(["tag-without-members"]);
    expect(delSpy).toHaveBeenCalledTimes(1);
  });

  it("returns null/void when redis resolver returns null for get/set helpers", async () => {
    vi.mocked(getCacheRedis).mockResolvedValueOnce(null as never);
    expect(await getCachedJson("no-redis")).toBeNull();

    vi.mocked(getCacheRedis).mockResolvedValueOnce(null as never);
    await setCachedJsonWithTags({ key: "no-redis-set", value: { ok: true }, ttlSeconds: 10, tags: ["t"] });
  });

  it("logs warning when setCachedJsonWithTags fails", async () => {
    const warnSpy = vi.spyOn(logger, "warn").mockImplementation(() => undefined);
    const originalSet = fakeRedis.set;
    fakeRedis.set = vi.fn(async () => {
      throw new Error("redis-set-fail");
    }) as any;

    await setCachedJsonWithTags({
      key: "set-fail",
      value: { ok: true },
      ttlSeconds: 30,
      tags: ["x"]
    });
    expect(warnSpy).toHaveBeenCalledWith("[CACHE] set failed", expect.anything());
    fakeRedis.set = originalSet;
    warnSpy.mockRestore();
  });
});
