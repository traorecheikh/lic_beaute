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

import { getCachedJson, invalidateCacheTags, setCachedJsonWithTags } from "./cache.js";

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
});
