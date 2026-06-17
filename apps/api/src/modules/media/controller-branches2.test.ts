import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const prisma = {
    mediaAsset: { create: vi.fn(), findUnique: vi.fn() },
    user: { findUnique: vi.fn() }
  };
  const storage = { store: vi.fn(), delete: vi.fn(), publicUrl: vi.fn(() => "https://pub"), retrieve: vi.fn() };
  const r2 = { headObject: vi.fn() };
  const enqueueJob = vi.fn();
  const logger = { error: vi.fn(), warn: vi.fn(), info: vi.fn() };
  return { requireRole, fail, ok, prisma, storage, r2, enqueueJob, logger };
});

vi.mock("../../config.js", () => ({
  config: {
    storageDriver: "local",
    storagePath: ".data",
    mediaPublicBaseUrl: "https://media.example.com",
    maxUploadBytes: 10_000
  }
}));
vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", () => ({ fail: mocks.fail, ok: mocks.ok }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../adapters/index.js", () => ({
  getStorageAdapter: vi.fn(() => mocks.storage)
}));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: mocks.enqueueJob }));
vi.mock("../../lib/cache.js", () => ({ invalidateCacheTags: vi.fn() }));
vi.mock("../../lib/logger.js", () => ({ logger: mocks.logger }));

import { MediaController } from "./index.js";

describe("MediaController additional branches", () => {
  const c = new MediaController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: null });
    mocks.storage.delete.mockResolvedValue(undefined);
  });

  it("upload handles missing file and unsupported mime", async () => {
    await c.upload({ file: vi.fn().mockResolvedValue(null) } as never, {} as never);

    await c.upload({
      file: vi.fn().mockResolvedValue({
        filename: "a.exe",
        mimetype: "application/x-msdownload",
        fields: { purpose: { value: "avatar" } },
        file: Buffer.from("x")
      })
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 400, "file_required", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 415, "unsupported_media_type", expect.any(String));
  });

  it("upload rejects invalid size and cleans up", async () => {
    mocks.storage.store.mockResolvedValue(0);
    await c.upload({
      file: vi.fn().mockResolvedValue({
        filename: "a.jpg",
        mimetype: "image/jpeg",
        fields: { purpose: { value: "avatar" } },
        file: Buffer.from("x")
      })
    } as never, {} as never);
    expect(mocks.storage.delete).toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_upload_size", expect.any(String));
  });

  it("upload success creates asset", async () => {
    mocks.storage.store.mockResolvedValue(100);
    mocks.prisma.mediaAsset.create.mockResolvedValue({ id: "m1", salonId: null });
    await c.upload({
      file: vi.fn().mockResolvedValue({
        filename: "a.jpg",
        mimetype: "image/jpeg",
        fields: { purpose: { value: "avatar" } },
        file: Buffer.from("x")
      })
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { assetId: "m1", uploadStatus: "review_pending", reviewStatus: "pending" }, 201);
  });

  it("getPublicFile handles invalid key and storage miss", async () => {
    const reply = { redirect: vi.fn(), type: vi.fn(() => reply), header: vi.fn(() => reply), send: vi.fn() } as never;
    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce({ id: "m1", deletedAt: null, reviewStatus: "approved", visibility: "public", finalObjectKey: "../bad", objectKey: "../bad", mimeType: "image/jpeg" });
    await c.getPublicFile({ params: { mediaId: "m1" } } as never, reply);

    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce({ id: "m1", deletedAt: null, reviewStatus: "approved", visibility: "public", finalObjectKey: "safe/x.jpg", objectKey: "safe/x.jpg", mimeType: "image/jpeg" });
    mocks.storage.retrieve.mockResolvedValue(null);
    await c.getPublicFile({ params: { mediaId: "m1" } } as never, reply);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "media_not_found", expect.any(String));
  });
});
