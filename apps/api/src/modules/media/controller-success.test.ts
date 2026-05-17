import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const prisma = {
    mediaAsset: { findMany: vi.fn(), findUnique: vi.fn(), update: vi.fn(), create: vi.fn() },
    user: { findUnique: vi.fn() },
    $transaction: vi.fn()
  };
  const storage = { retrieve: vi.fn() };
  const r2 = { headObject: vi.fn() };
  const enqueueJob = vi.fn();
  const invalidateCacheTags = vi.fn();
  const logger = { error: vi.fn(), warn: vi.fn(), info: vi.fn() };
  return { requireRole, fail, ok, prisma, storage, r2, enqueueJob, invalidateCacheTags, logger };
});

vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", () => ({ fail: mocks.fail, ok: mocks.ok }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../adapters/index.js", () => ({
  getStorageAdapter: vi.fn(() => mocks.storage),
  getR2Adapter: vi.fn(() => mocks.r2)
}));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: mocks.enqueueJob }));
vi.mock("../../lib/cache.js", () => ({ invalidateCacheTags: mocks.invalidateCacheTags }));
vi.mock("../../lib/logger.js", () => ({ logger: mocks.logger }));

import { MediaController } from "./index.js";

describe("MediaController success paths", () => {
  const c = new MediaController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
  });

  it("getPublicMedia maps approved assets", async () => {
    mocks.prisma.mediaAsset.findMany.mockResolvedValue([
      { id: "m1", publicUrl: "https://img", purpose: "avatar", mimeType: "image/jpeg", displayOrder: 0, createdAt: new Date() }
    ]);
    await c.getPublicMedia({ params: { salonId: "s1" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("getPublicFile returns 404 when not approved/public", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue(null);
    await c.getPublicFile({ params: { mediaId: "m1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "media_not_found", expect.any(String));
  });

  it("uploadIntent returns 503 when r2 not configured", async () => {
    const adapters = await import("../../adapters/index.js");
    vi.mocked(adapters.getR2Adapter).mockReturnValueOnce(null);
    await c.uploadIntent({
      body: {
        purpose: "avatar",
        mimeType: "image/jpeg",
        originalFilename: "a.jpg",
        sizeBytes: 100
      }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 503, "storage_unavailable", expect.any(String));
  });

  it("uploadIntent success creates pending asset and presigned URL", async () => {
    const adapters = await import("../../adapters/index.js");
    vi.mocked(adapters.getR2Adapter).mockReturnValueOnce({
      headObject: vi.fn(),
      presignPut: vi.fn().mockResolvedValue("https://upload")
    } as never);
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
    mocks.prisma.mediaAsset.create.mockResolvedValue({ id: "m-new" });
    await c.uploadIntent({
      body: {
        purpose: "avatar",
        mimeType: "image/jpeg",
        originalFilename: "a.jpg",
        sizeBytes: 100,
        salonId: "s2"
      }
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ assetId: "m-new" }), 201);
  });

  it("completeUpload returns 404 on missing media", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue(null);
    await c.completeUpload({ params: { mediaId: "m1" }, body: {} } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "media_not_found", expect.any(String));
  });

  it("completeUpload returns 409 when already completed", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({
      id: "m1",
      deletedAt: null,
      uploadedBy: "u1",
      uploadStatus: "review_pending"
    });
    await c.completeUpload({ params: { mediaId: "m1" }, body: {} } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "already_completed", expect.any(String));
  });

  it("completeUpload returns forbidden and upload_not_found branches", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce({
      id: "m1",
      deletedAt: null,
      uploadedBy: "u2",
      uploadStatus: "pending_upload",
      objectKey: "incoming/x.jpg"
    });
    await c.completeUpload({ params: { mediaId: "m1" }, body: {} } as never, {} as never);

    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce({
      id: "m2",
      deletedAt: null,
      uploadedBy: "u1",
      uploadStatus: "pending_upload",
      objectKey: "incoming/y.jpg"
    });
    mocks.r2.headObject.mockResolvedValueOnce(null);
    await c.completeUpload({ params: { mediaId: "m2" }, body: {} } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "forbidden", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "upload_not_found", expect.any(String));
  });

  it("completeUpload succeeds and enqueues review job", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({
      id: "m1",
      deletedAt: null,
      uploadedBy: "u1",
      uploadStatus: "pending_upload",
      objectKey: "incoming/x.jpg",
      salonId: "s1"
    });
    mocks.r2.headObject.mockResolvedValue({ sizeBytes: 222 });
    mocks.prisma.mediaAsset.update.mockResolvedValue({});
    await c.completeUpload({ params: { mediaId: "m1" }, body: {} } as never, {} as never);
    expect(mocks.enqueueJob).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("completeUpload updates pending status when head has no sizeBytes", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({
      id: "m4",
      deletedAt: null,
      uploadedBy: "u1",
      uploadStatus: "pending_upload",
      objectKey: "incoming/no-size.jpg",
      salonId: "s1"
    });
    mocks.r2.headObject.mockResolvedValue({});
    mocks.prisma.mediaAsset.update.mockResolvedValue({});
    await c.completeUpload({ params: { mediaId: "m4" }, body: {} } as never, {} as never);
    expect(mocks.prisma.mediaAsset.update).toHaveBeenCalledWith(expect.objectContaining({
      where: { id: "m4" },
      data: { uploadStatus: "review_pending" }
    }));
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("completeUpload maps unexpected errors to internal_error", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({
      id: "m5",
      deletedAt: null,
      uploadedBy: "u1",
      uploadStatus: "pending_upload",
      objectKey: "incoming/fail.jpg",
      salonId: "s1"
    });
    mocks.r2.headObject.mockResolvedValue({ sizeBytes: 123 });
    mocks.prisma.mediaAsset.update.mockRejectedValueOnce(new Error("db-fail"));
    await c.completeUpload({ params: { mediaId: "m5" }, body: {} } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("delete marks media deleted for owner", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({
      id: "m1",
      deletedAt: null,
      ownerType: "user",
      ownerId: "u1",
      objectKey: "incoming/x.jpg",
      salonId: "s1"
    });
    mocks.prisma.user.findUnique.mockResolvedValue({ role: "client", salonId: null });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) => cb({
      mediaAsset: { update: vi.fn() }
    }));
    await c.delete({ params: { mediaId: "m1" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { deleted: true });
    expect(mocks.invalidateCacheTags).toHaveBeenCalled();
  });

  it("get returns 403 for non owner", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({ id: "m1", deletedAt: null, ownerType: "user", ownerId: "u2", publicUrl: null, mimeType: "image/jpeg", createdAt: new Date() });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1", role: "client" });
    await c.get({ params: { mediaId: "m1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "forbidden", expect.any(String));
  });

  it("get and delete return not found; get owner success", async () => {
    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce(null);
    await c.get({ params: { mediaId: "missing" } } as never, {} as never);
    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce(null);
    await c.delete({ params: { mediaId: "missing" } } as never, {} as never);

    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce({
      id: "m3",
      deletedAt: null,
      ownerType: "user",
      ownerId: "u1",
      publicUrl: "https://p",
      mimeType: "image/jpeg",
      createdAt: new Date()
    });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: null, role: "client" });
    await c.get({ params: { mediaId: "m3" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "media_not_found", expect.any(String));
  });

  it("get rethrows unexpected errors and delete maps internal error", async () => {
    mocks.prisma.mediaAsset.findUnique.mockRejectedValueOnce(new Error("boom-get"));
    await expect(c.get({ params: { mediaId: "m9" } } as never, {} as never)).rejects.toThrow("boom-get");

    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce({
      id: "m9",
      deletedAt: null,
      ownerType: "user",
      ownerId: "u1",
      objectKey: "incoming/z.jpg",
      salonId: null
    });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: null, role: "client" });
    mocks.prisma.$transaction.mockRejectedValueOnce(new Error("boom-delete"));
    await c.delete({ params: { mediaId: "m9" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });
});
