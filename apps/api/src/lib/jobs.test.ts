import { beforeEach, describe, expect, it, vi } from "vitest";

import { config } from "../config.js";
import { getQueueRedis } from "./redis.js";

const addMock = vi.fn();
const queueCtorMock = vi.fn();

vi.mock("bullmq", () => ({
  Queue: class {
    constructor(...args: unknown[]) {
      queueCtorMock(...args);
    }
    add = addMock;
    close = vi.fn();
  }
}));

vi.mock("./redis.js", () => ({
  getQueueRedis: vi.fn(async () => ({}))
}));

describe("enqueueJob", () => {
  beforeEach(() => {
    addMock.mockReset();
    queueCtorMock.mockReset();
    config.workerDriver = "hybrid";
    config.redisUrl = "";
  });

  it("always writes DB mirror job", async () => {
    const dbCreate = vi.fn(async () => ({}));
    const dbFindFirst = vi.fn(async () => null);
    const { enqueueJob } = await import("./jobs.js");

    await enqueueJob({
      type: "booking_reminder",
      payload: { bookingId: "b1", window: "1h" },
      dbClient: { job: { create: dbCreate, findFirst: dbFindFirst, updateMany: vi.fn(async () => ({ count: 0 })) } }
    });

    expect(dbCreate).toHaveBeenCalledTimes(1);
    expect(addMock).not.toHaveBeenCalled();
  });

  it("dispatches to BullMQ when enabled", async () => {
    const dbCreate = vi.fn(async () => ({}));
    const dbFindFirst = vi.fn(async () => null);
    config.redisUrl = "redis://unit-test";
    config.workerDriver = "hybrid";
    const { enqueueJob } = await import("./jobs.js");

    await enqueueJob({
      type: "notification_retry",
      payload: { notificationId: "n1" },
      dbClient: { job: { create: dbCreate, findFirst: dbFindFirst, updateMany: vi.fn(async () => ({ count: 0 })) } }
    });

    expect(dbCreate).toHaveBeenCalledTimes(1);
    expect(queueCtorMock).toHaveBeenCalled();
    expect(addMock).toHaveBeenCalledTimes(1);
  });

  it("skips DB insert when pending duplicate already exists", async () => {
    const dbCreate = vi.fn(async () => ({}));
    const dbFindFirst = vi.fn(async () => ({ id: "existing-job" }));
    config.redisUrl = "";
    const { enqueueJob } = await import("./jobs.js");
    await enqueueJob({
      type: "booking_reminder",
      payload: { bookingId: "dup" },
      dbClient: { job: { create: dbCreate, findFirst: dbFindFirst, updateMany: vi.fn(async () => ({ count: 0 })) } }
    });
    expect(dbCreate).not.toHaveBeenCalled();
  });

  it("returns early when bull worker is disabled", async () => {
    const dbCreate = vi.fn(async () => ({}));
    const dbFindFirst = vi.fn(async () => null);
    config.redisUrl = "redis://unit-test";
    config.workerDriver = "db";
    const { enqueueJob } = await import("./jobs.js");
    await enqueueJob({
      type: "notification_retry",
      payload: { notificationId: "n-null-redis" },
      dbClient: { job: { create: dbCreate, findFirst: dbFindFirst, updateMany: vi.fn(async () => ({ count: 0 })) } }
    });
    expect(dbCreate).toHaveBeenCalledTimes(1);
    expect(addMock).not.toHaveBeenCalled();
  });

  it("uses explicit job options for delayed jobs", async () => {
    vi.mocked(getQueueRedis).mockResolvedValue({} as never);
    const dbCreate = vi.fn(async () => ({}));
    const dbFindFirst = vi.fn(async () => null);
    config.redisUrl = "redis://unit-test";
    config.workerDriver = "hybrid";
    const { enqueueJob } = await import("./jobs.js");
    await enqueueJob({
      type: "deposit_settlement",
      payload: { bookingId: "b-delay" },
      runAfter: new Date(Date.now() + 15_000),
      attempts: 7,
      jobId: "explicit-job-id",
      dbClient: { job: { create: dbCreate, findFirst: dbFindFirst, updateMany: vi.fn(async () => ({ count: 0 })) } }
    });
    expect(addMock).toHaveBeenCalledWith(
      "deposit_settlement",
      { bookingId: "b-delay" },
      expect.objectContaining({ attempts: 7, jobId: "explicit-job-id" })
    );
  });

  it("reuses cached queue instance and supports array payload in generated job id", async () => {
    vi.mocked(getQueueRedis).mockResolvedValue({} as never);
    const dbCreate = vi.fn(async () => ({}));
    const dbFindFirst = vi.fn(async () => null);
    config.redisUrl = "redis://unit-test";
    config.workerDriver = "hybrid";
    const { enqueueJob } = await import("./jobs.js");
    await enqueueJob({
      type: "prestige_score_refresh",
      payload: { ids: ["a", "b"], nested: { ok: true } },
      dbClient: { job: { create: dbCreate, findFirst: dbFindFirst, updateMany: vi.fn(async () => ({ count: 0 })) } }
    });
    await enqueueJob({
      type: "prestige_score_refresh",
      payload: { ids: ["c"], nested: { ok: false } },
      dbClient: { job: { create: dbCreate, findFirst: vi.fn(async () => null), updateMany: vi.fn(async () => ({ count: 0 })) } }
    });
    expect(queueCtorMock).toHaveBeenCalledTimes(1);
    expect(addMock).toHaveBeenCalledTimes(2);
  });
});
