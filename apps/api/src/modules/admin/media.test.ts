import { beforeEach, describe, expect, it, vi } from "vitest";
import { HttpAuthError } from "../../lib/auth/index.js";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  const logger = { info: vi.fn(), error: vi.fn(), warn: vi.fn() };
  const invalidateCacheTags = vi.fn();
  const sendPushBatch = vi.fn();
  const getStorageAdapter = vi.fn();
  const storage = {
    presignGet: vi.fn(),
    retrieve: vi.fn().mockResolvedValue(Buffer.from("x")),
    store: vi.fn().mockResolvedValue(undefined),
    delete: vi.fn().mockResolvedValue(undefined),
    copyObject: vi.fn(),
    deleteObject: vi.fn()
  };
  const prisma = {
    mediaAsset: {
      findMany: vi.fn(),
      count: vi.fn(),
      findUnique: vi.fn(),
      update: vi.fn()
    },
    user: {
      findMany: vi.fn()
    }
  };
  const config = {
    storageDriver: "local",
    mediaPublicBaseUrl: "https://cdn.example.com",
    storagePath: "/tmp"
  };
  return { requireRole, ok, fail, logger, invalidateCacheTags, sendPushBatch, getStorageAdapter, storage, prisma, config };
});

vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", () => ({ ok: mocks.ok, fail: mocks.fail }));
vi.mock("../../lib/logger.js", () => ({ logger: mocks.logger }));
vi.mock("../../lib/cache.js", () => ({ invalidateCacheTags: mocks.invalidateCacheTags }));
vi.mock("../../lib/push.js", () => ({ sendPushBatch: mocks.sendPushBatch }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../config.js", () => ({ config: mocks.config }));
vi.mock("../../adapters/index.js", () => ({ getStorageAdapter: mocks.getStorageAdapter }));


import { AdminMediaController } from "./media.js";

describe("AdminMediaController", () => {
  const controller = new AdminMediaController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "admin_1", role: "platform_admin" });
    mocks.prisma.mediaAsset.count.mockResolvedValue(1);
    mocks.prisma.mediaAsset.findMany.mockResolvedValue([]);
    mocks.prisma.user.findMany.mockResolvedValue([]);
    mocks.storage.presignGet.mockResolvedValue("https://signed");
    mocks.storage.retrieve.mockResolvedValue(Buffer.from("x"));
    mocks.storage.store.mockResolvedValue(undefined);
    mocks.storage.delete.mockResolvedValue(undefined);
    mocks.prisma.mediaAsset.update.mockResolvedValue({});
    mocks.config.storageDriver = "local";
    mocks.getStorageAdapter.mockReset();
  });

  it("listPending paginates and returns mapped payload", async () => {
    mocks.prisma.mediaAsset.findMany.mockResolvedValue([
      {
        id: "m1",
        salonId: "s1",
        uploadedBy: "u1",
        objectKey: "tmp/a",
        mimeType: "image/jpeg",
        sizeBytes: 10,
        purpose: "salon_gallery",
        uploadStatus: "review_pending",
        reviewStatus: "pending",
        originalFilename: "a.jpg",
        createdAt: new Date("2026-01-01T00:00:00.000Z")
      }
    ]);

    await controller.listPending({ query: { page: "0", pageSize: "20" } } as never, {} as never);

    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ total: 1, page: 0, pageSize: 20 }));
  });

  it("listPending maps auth/internal errors", async () => {
    mocks.requireRole.mockImplementationOnce(() => {
      throw new HttpAuthError(403, "forbidden", "nope");
    });
    await controller.listPending({ query: {} } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "forbidden", "nope");

    mocks.requireRole.mockReturnValue({ sub: "admin_1", role: "platform_admin" });
    mocks.prisma.mediaAsset.findMany.mockRejectedValueOnce(new Error("db"));
    await controller.listPending({ query: {} } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("signedViewUrl returns 404 when media missing", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue(null);
    await controller.signedViewUrl({ params: { mediaId: "m1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "media_not_found", expect.any(String));
  });

  it("signedViewUrl returns signed URL", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({ id: "m1", objectKey: "tmp/x", deletedAt: null });
    mocks.getStorageAdapter.mockReturnValue(mocks.storage);
    await controller.signedViewUrl({ params: { mediaId: "m1" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ signedUrl: "https://signed" }));
  });

  it("signedViewUrl maps auth/internal errors", async () => {
    mocks.requireRole.mockImplementationOnce(() => {
      throw new HttpAuthError(401, "unauthorized", "bad");
    });
    await controller.signedViewUrl({ params: { mediaId: "m1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "unauthorized", "bad");

    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce({ id: "m1", objectKey: "x", deletedAt: null });
    mocks.getStorageAdapter.mockReturnValue(mocks.storage);
    mocks.storage.presignGet.mockRejectedValueOnce(new Error("storage down"));
    await controller.signedViewUrl({ params: { mediaId: "m1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("approve handles already approved", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({ id: "m1", reviewStatus: "approved", deletedAt: null });
    await controller.approve({ params: { mediaId: "m1" }, body: {} } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "already_approved", expect.any(String));
  });

  it("approve copies file and sends push/cache invalidation", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({
      id: "m1",
      deletedAt: null,
      reviewStatus: "pending",
      purpose: "salon_gallery",
      fileExt: ".jpg",
      salonId: "s1",
      ownerId: "u1",
      objectKey: "tmp/m1",
      mimeType: "image/jpeg",
      displayOrder: 0
    });
    mocks.getStorageAdapter.mockReturnValue(mocks.storage);
    mocks.prisma.user.findMany.mockResolvedValue([
      { pushTokens: [{ token: "t1" }, { token: "t2" }] }
    ]);

    await controller.approve({ params: { mediaId: "m1" }, body: { purpose: "salon_gallery", displayOrder: 2 } } as never, {} as never);

    expect(mocks.storage.store).toHaveBeenCalled();
    expect(mocks.prisma.mediaAsset.update).toHaveBeenCalled();
    expect(mocks.sendPushBatch).toHaveBeenCalled();
    expect(mocks.invalidateCacheTags).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ approved: true }));
  });

  it("approve supports private KYC visibility and no push when no tokens", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({
      id: "m_kyc",
      deletedAt: null,
      reviewStatus: "pending",
      purpose: "kyc_document",
      fileExt: ".pdf",
      salonId: "s1",
      ownerId: "u1",
      objectKey: "tmp/kyc",
      mimeType: "application/pdf",
      displayOrder: 0
    });
    mocks.getStorageAdapter.mockReturnValue(mocks.storage);
    mocks.prisma.user.findMany.mockResolvedValue([{ pushTokens: [] }]);

    await controller.approve({ params: { mediaId: "m_kyc" }, body: {} } as never, {} as never);
    expect(mocks.sendPushBatch).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { approved: true, publicUrl: null });
  });

  it("approve computes default purposeDir/gallery and file extension fallback", async () => {
    mocks.config.storageDriver = "local";
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({
      id: "m-fallbacks",
      deletedAt: null,
      reviewStatus: "pending",
      purpose: undefined,
      fileExt: null,
      salonId: null,
      ownerId: "u9",
      objectKey: "tmp/m-fallbacks",
      mimeType: "image/jpeg",
      displayOrder: 0
    });
    const storage = {
      retrieve: vi.fn().mockResolvedValue(Buffer.from("x")),
      store: vi.fn().mockResolvedValue(undefined),
      delete: vi.fn().mockResolvedValue(undefined)
    };
    mocks.getStorageAdapter.mockReturnValue(storage);
    await controller.approve({ params: { mediaId: "m-fallbacks" }, body: undefined } as never, {} as never);
    expect(storage.store).toHaveBeenCalledWith(
      expect.stringContaining("/gallery/m-fallbacks.jpg"),
      expect.any(Buffer),
      "image/jpeg"
    );
    expect(mocks.prisma.mediaAsset.update).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ purpose: undefined })
    }));
  });

  it("approve non-r2 path tolerates missing source and maps not-found/auth errors", async () => {
    mocks.config.storageDriver = "noop";
    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce({
      id: "m3",
      deletedAt: null,
      reviewStatus: "pending",
      purpose: "salon_gallery",
      fileExt: ".jpg",
      salonId: null,
      ownerId: "u1",
      objectKey: "tmp/m3",
      mimeType: "image/jpeg",
      displayOrder: 0
    });
    mocks.getStorageAdapter.mockReturnValue({
      retrieve: vi.fn().mockResolvedValue(null),
      store: vi.fn(),
      delete: vi.fn()
    });
    await controller.approve({ params: { mediaId: "m3" }, body: {} } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();

    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce(null);
    await controller.approve({ params: { mediaId: "missing" }, body: {} } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "media_not_found", expect.any(String));

    mocks.requireRole.mockImplementationOnce(() => {
      throw new HttpAuthError(403, "forbidden", "nope");
    });
    await controller.approve({ params: { mediaId: "m3" }, body: {} } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "forbidden", "nope");
  });

  it("approve maps unexpected internal errors", async () => {
    mocks.prisma.mediaAsset.findUnique.mockRejectedValueOnce(new Error("db-fail"));
    await controller.approve({ params: { mediaId: "m500" }, body: {} } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("reject handles already rejected", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({ id: "m1", reviewStatus: "rejected", deletedAt: null });
    await controller.reject({ params: { mediaId: "m1" }, body: { reason: "bad" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "already_rejected", expect.any(String));
  });

  it("reject marks media and notifies owners", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({
      id: "m1",
      deletedAt: null,
      reviewStatus: "pending",
      salonId: "s1",
      ownerId: "u1",
      objectKey: "tmp/m1",
      fileExt: ".jpg"
    });
    mocks.getStorageAdapter.mockReturnValue(mocks.storage);
    mocks.prisma.user.findMany.mockResolvedValue([{ pushTokens: [{ token: "t1" }] }]);

    await controller.reject({ params: { mediaId: "m1" }, body: { reason: "inappropriate" } } as never, {} as never);

    expect(mocks.prisma.mediaAsset.update).toHaveBeenCalled();
    expect(mocks.sendPushBatch).toHaveBeenCalled();
    expect(mocks.invalidateCacheTags).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { rejected: true });
  });

  it("reject handles owner-scoped assets without salon notifications", async () => {
    mocks.config.storageDriver = "local";
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({
      id: "m-owner-only",
      deletedAt: null,
      reviewStatus: "pending",
      purpose: "profile_photo",
      fileExt: null,
      salonId: null,
      ownerId: "u42",
      objectKey: "tmp/m-owner-only"
    });
    mocks.getStorageAdapter.mockReturnValue(mocks.storage);
    await controller.reject({ params: { mediaId: "m-owner-only" }, body: { reason: "invalid" } } as never, {} as never);
    expect(mocks.sendPushBatch).not.toHaveBeenCalled();
    expect(mocks.invalidateCacheTags).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { rejected: true });
  });

  it("reject with storage defaults file extension and handles missing tokens", async () => {
    mocks.config.storageDriver = "local";
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({
      id: "m-no-ext",
      deletedAt: null,
      reviewStatus: "pending",
      purpose: "profile_photo",
      fileExt: null,
      salonId: "s1",
      ownerId: "u1",
      objectKey: "tmp/m-no-ext"
    });
    mocks.getStorageAdapter.mockReturnValue(mocks.storage);
    mocks.prisma.user.findMany.mockResolvedValue([{ pushTokens: [] }]);
    await controller.reject({ params: { mediaId: "m-no-ext" }, body: { reason: "invalid" } } as never, {} as never);
    expect(mocks.storage.store).toHaveBeenCalled();
    expect(mocks.sendPushBatch).not.toHaveBeenCalled();
  });

  it("reject handles missing media and maps auth/internal errors", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce(null);
    await controller.reject({ params: { mediaId: "missing" }, body: { reason: "bad" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "media_not_found", expect.any(String));

    mocks.requireRole.mockImplementationOnce(() => {
      throw new HttpAuthError(401, "unauthorized", "bad");
    });
    await controller.reject({ params: { mediaId: "m1" }, body: { reason: "bad" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "unauthorized", "bad");

    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce({
      id: "m1", deletedAt: null, reviewStatus: "pending", salonId: null, ownerId: "u1", objectKey: "tmp/m1", fileExt: ".jpg"
    });
    mocks.prisma.mediaAsset.update.mockRejectedValueOnce(new Error("db down"));
    await controller.reject({ params: { mediaId: "m1" }, body: { reason: "bad" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });
});
