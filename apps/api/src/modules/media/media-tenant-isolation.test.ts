import { Readable } from "node:stream";
import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const storage = {
    store: vi.fn(),
    delete: vi.fn(),
    publicUrl: vi.fn()
  };
  const r2 = {
    presignPut: vi.fn(),
    headObject: vi.fn()
  };
  const prisma = {
    user: { findUnique: vi.fn() },
    mediaAsset: { create: vi.fn(), findUnique: vi.fn(), update: vi.fn(), findMany: vi.fn(), count: vi.fn().mockResolvedValue(0) },
    salon: { findUnique: vi.fn().mockResolvedValue({ subscriptionTier: "premium" }) },
    salonGalleryImage: { count: vi.fn().mockResolvedValue(0) }
  };
  const enqueueJob = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  const requireRole = vi.fn();

  return { storage, r2, prisma, enqueueJob, ok, fail, requireRole };
});

vi.mock("../../adapters/index.js", () => ({
  getStorageAdapter: () => mocks.storage,
  getR2Adapter: () => mocks.r2
}));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: mocks.enqueueJob }));
vi.mock("../../lib/http.js", () => ({ ok: mocks.ok, fail: mocks.fail }));
vi.mock("../../lib/cache.js", () => ({ invalidateCacheTags: vi.fn() }));
vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});

import { MediaController } from "./index.js";

describe("Media tenant isolation", () => {
  const controller = new MediaController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.storage.store.mockResolvedValue(1234);
    mocks.storage.publicUrl.mockReturnValue("http://local/file");
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "salon_owner_1" });
    mocks.prisma.mediaAsset.create.mockResolvedValue({ id: "m1", salonId: "salon_owner_1" });
    mocks.r2.presignPut.mockResolvedValue("https://signed-url");
  });

  it("forces non-admin uploadIntent salonId to caller salon", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });

    await controller.uploadIntent({
      body: {
        salonId: "foreign_salon",
        purpose: "salon_gallery",
        mimeType: "image/png",
        sizeBytes: 1000,
        originalFilename: "a.png"
      }
    } as never, {} as never);

    expect(mocks.prisma.mediaAsset.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ salonId: "salon_owner_1" })
    }));
  });

  it("allows admin uploadIntent to keep explicit salonId", async () => {
    mocks.requireRole.mockReturnValue({ sub: "admin1", role: "platform_admin" });

    await controller.uploadIntent({
      body: {
        salonId: "foreign_salon",
        purpose: "salon_gallery",
        mimeType: "image/png",
        sizeBytes: 1000,
        originalFilename: "a.png"
      }
    } as never, {} as never);

    expect(mocks.prisma.mediaAsset.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ salonId: "foreign_salon" })
    }));
  });

  it("forces non-admin multipart upload salonId to caller salon", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    const file = {
      filename: "doc.pdf",
      mimetype: "application/pdf",
      file: Readable.from(Buffer.from("file")),
      fields: {
        purpose: { value: "kyc_document" },
        salonId: { value: "foreign_salon" }
      }
    };

    await controller.upload({
      file: vi.fn().mockResolvedValue(file)
    } as never, {} as never);

    expect(mocks.prisma.mediaAsset.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ salonId: "salon_owner_1" })
    }));
  });
});
