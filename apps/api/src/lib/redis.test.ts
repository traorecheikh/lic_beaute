import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const mocked = vi.hoisted(() => ({
  connect: vi.fn(),
  quit: vi.fn()
}));

vi.mock("ioredis", () => ({
  Redis: class {
    status = "wait";

    connect = mocked.connect;

    quit = mocked.quit;
  }
}));

vi.mock("../config.js", () => ({
  config: { redisUrl: "redis://127.0.0.1:6379" }
}));

import { logger } from "./logger.js";
import { closeRedisConnections, getCacheRedis, getQueueRedis } from "./redis.js";

describe("redis helpers", () => {
  beforeEach(() => {
    mocked.connect.mockReset();
    mocked.quit.mockReset();
    mocked.connect.mockResolvedValue(undefined);
    mocked.quit.mockResolvedValue("OK");
  });

  afterEach(async () => {
    await closeRedisConnections();
  });

  it("connects queue and cache clients", async () => {
    mocked.connect.mockResolvedValue(undefined);
    const queue = await getQueueRedis();
    const cache = await getCacheRedis();
    expect(queue).toBeTruthy();
    expect(cache).toBeTruthy();
    expect(mocked.connect).toHaveBeenCalledTimes(2);
  });

  it("returns null and logs when queue connect fails", async () => {
    mocked.connect.mockRejectedValueOnce(new Error("down"));
    const warnSpy = vi.spyOn(logger, "warn").mockImplementation(() => undefined);
    const queue = await getQueueRedis();
    expect(queue).toBeNull();
    expect(warnSpy).toHaveBeenCalledWith("[REDIS] queue connect failed", { err: "Error: down" });
    warnSpy.mockRestore();
  });

  it("returns null and logs when cache connect fails", async () => {
    mocked.connect.mockResolvedValueOnce(undefined).mockRejectedValueOnce(new Error("cache-down"));
    const warnSpy = vi.spyOn(logger, "warn").mockImplementation(() => undefined);
    await getQueueRedis();
    const cache = await getCacheRedis();
    expect(cache).toBeNull();
    expect(warnSpy).toHaveBeenCalledWith("[REDIS] cache connect failed", { err: "Error: cache-down" });
    warnSpy.mockRestore();
  });

  it("closes redis connections", async () => {
    mocked.connect.mockResolvedValue(undefined);
    await getQueueRedis();
    await getCacheRedis();
    mocked.quit.mockResolvedValue("OK");
    await closeRedisConnections();
    expect(mocked.quit).toHaveBeenCalledTimes(2);
  });

  it("returns null when redis url is disabled", async () => {
    await closeRedisConnections();
    vi.resetModules();
    vi.doMock("ioredis", () => ({
      Redis: class {
        status = "wait";
        connect = mocked.connect;
        quit = mocked.quit;
      }
    }));
    vi.doMock("../config.js", () => ({ config: { redisUrl: "" } }));
    const mod = await import("./redis.js");
    await expect(mod.getQueueRedis()).resolves.toBeNull();
    await expect(mod.getCacheRedis()).resolves.toBeNull();
  });

  it("reuses ready clients without reconnecting", async () => {
    await closeRedisConnections();
    vi.resetModules();
    const connect = vi.fn();
    vi.doMock("ioredis", () => ({
      Redis: class {
        status = "ready";
        connect = connect;
        quit = mocked.quit;
      }
    }));
    vi.doMock("../config.js", () => ({ config: { redisUrl: "redis://127.0.0.1:6379" } }));
    const mod = await import("./redis.js");
    await expect(mod.getQueueRedis()).resolves.toBeTruthy();
    await expect(mod.getQueueRedis()).resolves.toBeTruthy();
    await expect(mod.getCacheRedis()).resolves.toBeTruthy();
    await expect(mod.getCacheRedis()).resolves.toBeTruthy();
    expect(connect).not.toHaveBeenCalled();
  });
});
