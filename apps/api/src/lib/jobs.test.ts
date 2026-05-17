import { beforeEach, describe, expect, it, vi } from "vitest";

import { config } from "../config.js";

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
});
