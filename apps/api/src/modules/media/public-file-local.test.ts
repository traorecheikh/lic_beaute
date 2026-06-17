import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const fail = vi.fn();
  const ok = vi.fn();
  const logger = { error: vi.fn(), warn: vi.fn(), info: vi.fn() };
  const prisma = {
    mediaAsset: { findUnique: vi.fn() },
    user: { findUnique: vi.fn() }
  };
  const storage = { retrieve: vi.fn() };
  return { fail, ok, logger, prisma, storage };
});

vi.mock("../../config.js", () => ({
  config: {
    storageDriver: "local",
    storagePath: ".data",
    mediaPublicBaseUrl: "https://media.example.com",
    maxUploadBytes: 10_000
  }
}));
vi.mock("../../lib/http.js", () => ({ fail: mocks.fail, ok: mocks.ok }));
vi.mock("../../lib/logger.js", () => ({ logger: mocks.logger }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../adapters/index.js", () => ({
  getStorageAdapter: vi.fn(() => mocks.storage)
}));
vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: vi.fn(() => ({ sub: "u1", role: "client" })) };
});
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: vi.fn() }));
vi.mock("../../lib/cache.js", () => ({ invalidateCacheTags: vi.fn() }));

import { MediaController } from "./index.js";

describe("MediaController getPublicFile local storage branches", () => {
  const c = new MediaController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({
      id: "m1",
      deletedAt: null,
      reviewStatus: "approved",
      visibility: "public",
      finalObjectKey: "public/s1/x.jpg",
      objectKey: "public/s1/x.jpg",
      mimeType: "image/jpeg"
    });
  });

  it("returns 404 when storage object is missing", async () => {
    const reply: any = { type: vi.fn(() => reply), header: vi.fn(() => reply), send: vi.fn(), redirect: vi.fn() };
    mocks.storage.retrieve.mockResolvedValueOnce(null);
    await c.getPublicFile({ params: { mediaId: "m1" } } as never, reply);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "media_not_found", expect.any(String));
  });

  it("streams file when storage returns bytes", async () => {
    const reply: any = { type: vi.fn(() => reply), header: vi.fn(() => reply), send: vi.fn(), redirect: vi.fn() };
    const data = Buffer.from("img");
    mocks.storage.retrieve.mockResolvedValueOnce(data);
    await c.getPublicFile({ params: { mediaId: "m1" } } as never, reply);
    expect(reply.type).toHaveBeenCalledWith("image/jpeg");
    expect(reply.send).toHaveBeenCalledWith(data);
  });

  it("uses objectKey when finalObjectKey is null", async () => {
    const reply: any = { type: vi.fn(() => reply), header: vi.fn(() => reply), send: vi.fn(), redirect: vi.fn() };
    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce({
      id: "m2",
      deletedAt: null,
      reviewStatus: "approved",
      visibility: "public",
      finalObjectKey: null,
      objectKey: "public/s1/fallback.jpg",
      mimeType: "image/jpeg"
    });
    mocks.storage.retrieve.mockResolvedValueOnce(Buffer.from("img2"));
    await c.getPublicFile({ params: { mediaId: "m2" } } as never, reply);
    expect(reply.send).toHaveBeenCalled();
  });

  it("maps unexpected retrieve errors to internal_error", async () => {
    const reply: any = { type: vi.fn(() => reply), header: vi.fn(() => reply), send: vi.fn(), redirect: vi.fn() };
    mocks.storage.retrieve.mockRejectedValueOnce(new Error("disk down"));
    await c.getPublicFile({ params: { mediaId: "m1" } } as never, reply);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });
});
