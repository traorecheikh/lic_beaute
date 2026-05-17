import { beforeEach, describe, expect, it, vi } from "vitest";

describe("jobs helpers extra coverage", () => {
  beforeEach(() => {
    vi.resetModules();
    vi.clearAllMocks();
  });

  it("queueForJob maps job types to queue names", async () => {
    const mod = await import("./jobs.js");
    expect(mod.queueForJob("deposit_settlement")).toBe("payments");
    expect(mod.queueForJob("booking_reminder")).toBe("notifications");
    expect(mod.queueForJob("media_cleanup")).toBe("maintenance");
  });

  it("closeJobQueues closes instantiated queues", async () => {
    const close = vi.fn().mockResolvedValue(undefined);
    const add = vi.fn().mockResolvedValue(undefined);
    vi.doMock("bullmq", () => ({
      Queue: class {
        add = add;
        close = close;
      }
    }));
    vi.doMock("./redis.js", () => ({ getQueueRedis: vi.fn(async () => ({})) }));
    const { config } = await import("../config.js");
    config.redisUrl = "redis://unit-test";
    config.workerDriver = "hybrid";
    const mod = await import("./jobs.js");
    await mod.enqueueJob({
      type: "notification_retry",
      payload: { notificationId: "n2" },
      dbClient: { job: { create: vi.fn(async () => ({})), findFirst: vi.fn(async () => null), updateMany: vi.fn(async () => ({ count: 0 })) } }
    });
    await mod.closeJobQueues();
    expect(close).toHaveBeenCalled();
  });

  it("logs warning when bull is enabled but redis queue is unavailable", async () => {
    const warn = vi.fn();
    const add = vi.fn();
    vi.doMock("bullmq", () => ({
      Queue: class {
        add = add;
        close = vi.fn();
      }
    }));
    vi.doMock("./redis.js", () => ({ getQueueRedis: vi.fn(async () => null) }));
    vi.doMock("./logger.js", () => ({ logger: { warn, error: vi.fn(), info: vi.fn() } }));
    const { config } = await import("../config.js");
    config.redisUrl = "redis://unit-test";
    config.workerDriver = "hybrid";
    const mod = await import("./jobs.js");
    await mod.enqueueJob({
      type: "deposit_settlement",
      payload: { paymentId: "p1" },
      dbClient: { job: { create: vi.fn(async () => ({})), findFirst: vi.fn(async () => null), updateMany: vi.fn(async () => ({ count: 0 })) } }
    });
    expect(warn).toHaveBeenCalled();
    expect(add).not.toHaveBeenCalled();
  });
});

