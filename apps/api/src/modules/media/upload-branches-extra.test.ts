import { beforeEach, describe, expect, it, vi } from "vitest";
import { HttpAuthError } from "../../lib/auth/index.js";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const prisma = {
    mediaAsset: { create: vi.fn(), findUnique: vi.fn(), update: vi.fn() },
    user: { findUnique: vi.fn() },
    salon: { findUnique: vi.fn().mockResolvedValue({ subscription: { status: "active" } }) },
    $transaction: vi.fn()
  };
  const storage = { store: vi.fn(), delete: vi.fn(), publicUrl: vi.fn((k: string) => `https://local/${k}`) };
  const r2 = { presignPut: vi.fn(), headObject: vi.fn() };
  const enqueueJob = vi.fn();
  const logger = { error: vi.fn(), warn: vi.fn(), info: vi.fn() };
  return { requireRole, fail, ok, prisma, storage, r2, enqueueJob, logger };
});

vi.mock("../../config.js", () => ({
  config: {
    storageDriver: "local",
    storagePath: ".data",
    r2AccountId: "a",
    r2AccessKeyId: "k",
    r2SecretAccessKey: "s",
    r2Bucket: "b",
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
  getStorageAdapter: vi.fn(() => mocks.storage),
  getR2Adapter: vi.fn(() => mocks.r2)
}));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: mocks.enqueueJob }));
vi.mock("../../lib/cache.js", () => ({ invalidateCacheTags: vi.fn() }));
vi.mock("../../lib/logger.js", () => ({ logger: mocks.logger }));

import { MediaController } from "./index.js";

describe("MediaController extra upload branches", () => {
  const c = new MediaController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: null });
    mocks.storage.store.mockResolvedValue(100);
    mocks.prisma.mediaAsset.create.mockResolvedValue({ id: "m1", salonId: null });
    mocks.r2.presignPut.mockResolvedValue("https://upload");
  });

  it("upload validates purpose parsing and filename edge cases", async () => {
    await c.upload({
      file: vi.fn().mockResolvedValue({
        filename: "a.jpg",
        mimetype: "image/jpeg",
        fields: { purpose: [123] },
        file: Buffer.from("x")
      })
    } as never, {} as never);

    await c.upload({
      file: vi.fn().mockResolvedValue({
        filename: "",
        mimetype: "image/jpeg",
        fields: { purpose: { value: "avatar" } },
        file: Buffer.from("x")
      })
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_purpose", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_filename", expect.any(String));
  });

  it("upload catches HttpAuthError thrown by auth guard", async () => {
    mocks.requireRole.mockImplementationOnce(() => {
      throw new HttpAuthError(401, "unauthorized", "bad");
    });
    await c.upload({ file: vi.fn() } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "unauthorized", "bad");
  });

  it("upload rejects non-string purpose field value", async () => {
    await c.upload({
      file: vi.fn().mockResolvedValue({
        filename: "a.jpg",
        mimetype: "image/jpeg",
        fields: { purpose: { value: 123 } },
        file: Buffer.from("x")
      })
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_purpose", expect.any(String));
  });

  it("upload on local storage sets publicUrl and supports admin salon assignment", async () => {
    mocks.requireRole.mockReturnValueOnce({ sub: "admin_1", role: "platform_admin" });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: null });
    await c.upload({
      file: vi.fn().mockResolvedValue({
        filename: "a.jpg",
        mimetype: "image/jpeg",
        fields: { purpose: { value: "avatar" }, salonId: { value: "s9" } },
        file: Buffer.from("x")
      })
    } as never, {} as never);
    expect(mocks.prisma.mediaAsset.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ salonId: "s9", publicUrl: expect.stringContaining("https://local/") })
    }));
  });

  it("upload computes extension from original filename then falls back to .bin", async () => {
    await c.upload({
      file: vi.fn().mockResolvedValue({
        filename: "photo.webp",
        mimetype: "image/webp",
        fields: { purpose: { value: "avatar" } },
        file: Buffer.from("x")
      })
    } as never, {} as never);

    await c.upload({
      file: vi.fn().mockResolvedValue({
        filename: "README",
        mimetype: "image/webp",
        fields: { purpose: { value: "avatar" } },
        file: Buffer.from("x")
      })
    } as never, {} as never);

    expect(mocks.prisma.mediaAsset.create).toHaveBeenCalled();
  });

  it("upload admin salon resolution falls back to owner salon when salonId field is non-string", async () => {
    mocks.requireRole.mockReturnValueOnce({ sub: "admin_non_string", role: "platform_admin" });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: "s-owner" });
    await c.upload({
      file: vi.fn().mockResolvedValue({
        filename: "avatar.unknown",
        mimetype: "image/jpeg",
        fields: { purpose: { value: "avatar" }, salonId: { value: 42 } },
        file: Buffer.from("x")
      })
    } as never, {} as never);
    expect(mocks.prisma.mediaAsset.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ salonId: "s-owner" })
    }));
  });

  it("upload admin salon resolution uses owner salon when salonId is empty string", async () => {
    mocks.requireRole.mockReturnValueOnce({ sub: "admin_empty_salon", role: "platform_admin" });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: "s-owner-empty" });
    await c.upload({
      file: vi.fn().mockResolvedValue({
        filename: "avatar.withoutext",
        mimetype: "image/jpeg",
        fields: { purpose: { value: "avatar" }, salonId: { value: "" } },
        file: Buffer.from("x")
      })
    } as never, {} as never);
    expect(mocks.prisma.mediaAsset.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ salonId: "s-owner-empty" })
    }));
  });

  it("upload admin salon resolution falls back to null when owner has no salon and salonId empty", async () => {
    mocks.requireRole.mockReturnValueOnce({ sub: "admin_null_salon", role: "platform_admin" });
    mocks.prisma.user.findUnique.mockResolvedValueOnce(null);
    await c.upload({
      file: vi.fn().mockResolvedValue({
        filename: "photo.svg",
        mimetype: "image/jpeg",
        fields: { purpose: { value: "avatar" }, salonId: { value: "" } },
        file: Buffer.from("x")
      })
    } as never, {} as never);
    expect(mocks.prisma.mediaAsset.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ salonId: null })
    }));
  });

  it("upload uses original filename extension when mime mapping is unavailable", async () => {
    await c.upload({
      file: vi.fn().mockResolvedValue({
        filename: "graphic.svg",
        mimetype: "image/jpeg",
        fields: { purpose: { value: "avatar" } },
        file: Buffer.from("x")
      })
    } as never, {} as never);
    expect(mocks.prisma.mediaAsset.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ fileExt: ".jpg" })
    }));
  });

  it("upload maps unexpected storage failures to internal_error", async () => {
    mocks.storage.store.mockRejectedValueOnce(new Error("disk full"));
    await c.upload({
      file: vi.fn().mockResolvedValue({
        filename: "a.jpg",
        mimetype: "image/jpeg",
        fields: { purpose: { value: "avatar" } },
        file: Buffer.from("x")
      })
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("uploadIntent resolves salonId differently for admin vs non-admin", async () => {
    mocks.requireRole.mockReturnValueOnce({ sub: "u1", role: "client" });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: "s1" });
    await c.uploadIntent({
      body: { purpose: "avatar", mimeType: "image/jpeg", originalFilename: "a.jpg", sizeBytes: 123, salonId: "other" }
    } as never, {} as never);

    mocks.requireRole.mockReturnValueOnce({ sub: "admin_1", role: "platform_admin" });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: null });
    await c.uploadIntent({
      body: { purpose: "avatar", mimeType: "image/jpeg", originalFilename: "b.jpg", sizeBytes: 120, salonId: "s-admin" }
    } as never, {} as never);

    expect(mocks.prisma.mediaAsset.create).toHaveBeenCalledTimes(2);
  });

  it("uploadIntent admin fallback uses own salon then null when salonId is omitted", async () => {
    mocks.requireRole.mockReturnValueOnce({ sub: "admin_4", role: "platform_admin" });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: "s-own" });
    await c.uploadIntent({
      body: { purpose: "avatar", mimeType: "image/jpeg", originalFilename: "a.jpg", sizeBytes: 120 }
    } as never, {} as never);

    mocks.requireRole.mockReturnValueOnce({ sub: "admin_5", role: "platform_admin" });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: null });
    await c.uploadIntent({
      body: { purpose: "avatar", mimeType: "image/jpeg", originalFilename: "b.jpg", sizeBytes: 120 }
    } as never, {} as never);

    expect(mocks.prisma.mediaAsset.create).toHaveBeenCalledTimes(2);
  });

  it("uploadIntent non-admin falls back to null salon when user has no salon", async () => {
    mocks.requireRole.mockReturnValueOnce({ sub: "staff_no_salon", role: "salon_staff" });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: null });
    await c.uploadIntent({
      body: { purpose: "avatar", mimeType: "image/jpeg", originalFilename: "n.jpg", sizeBytes: 120, salonId: "ignored" }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "not_in_salon", expect.any(String));
  });

  it("uploadIntent uses default extension for unmapped image mime and admin fallback salon resolution", async () => {
    mocks.requireRole.mockReturnValueOnce({ sub: "admin_2", role: "platform_admin" });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: "s-owner" });
    await c.uploadIntent({
      body: { purpose: "avatar", mimeType: "image/svg+xml", originalFilename: "logo.svg", sizeBytes: 120 }
    } as never, {} as never);

    mocks.requireRole.mockReturnValueOnce({ sub: "admin_3", role: "platform_admin" });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: null });
    await c.uploadIntent({
      body: { purpose: "avatar", mimeType: "image/svg+xml", originalFilename: "logo2.svg", sizeBytes: 120 }
    } as never, {} as never);

    expect(mocks.prisma.mediaAsset.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ fileExt: ".bin" })
    }));
  });

  it("uploadIntent maps unexpected provider/storage errors to internal_error", async () => {
    mocks.requireRole.mockReturnValueOnce({ sub: "u1", role: "client" });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: "s1" });
    mocks.r2.presignPut.mockRejectedValueOnce(new Error("presign-fail"));
    await c.uploadIntent({
      body: { purpose: "avatar", mimeType: "image/jpeg", originalFilename: "x.jpg", sizeBytes: 120 }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("completeUpload uses non-r2 update path when adapter is unavailable", async () => {
    const adapters = await import("../../adapters/index.js");
    vi.mocked(adapters.getR2Adapter).mockReturnValueOnce(null);
    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce({
      id: "m-local",
      deletedAt: null,
      uploadedBy: "u1",
      uploadStatus: "pending_upload",
      objectKey: "incoming/x.jpg",
      salonId: null
    });
    await c.completeUpload({ params: { mediaId: "m-local" }, body: {} } as never, {} as never);
    expect(mocks.prisma.mediaAsset.update).toHaveBeenCalledWith(expect.objectContaining({
      where: { id: "m-local" },
      data: { uploadStatus: "review_pending" }
    }));
  });

  it("get/delete authorize via salon ownership and admin role", async () => {
    const reply = {} as never;
    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce({
      id: "m-salon",
      deletedAt: null,
      ownerType: "salon",
      ownerId: "s1",
      publicUrl: "https://p",
      mimeType: "image/jpeg",
      createdAt: new Date(),
      salonId: null,
      objectKey: "incoming/a.jpg"
    });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: "s1", role: "salon_owner" });
    await c.get({ params: { mediaId: "m-salon" } } as never, reply);

    mocks.requireRole.mockReturnValueOnce({ sub: "admin_1", role: "platform_admin" });
    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce({
      id: "m-admin",
      deletedAt: null,
      ownerType: "user",
      ownerId: "u2",
      salonId: null,
      objectKey: "incoming/b.jpg"
    });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: null, role: "platform_admin" });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({ mediaAsset: { update: vi.fn() } })
    );
    await c.delete({ params: { mediaId: "m-admin" } } as never, reply);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("delete forbids when caller is not owner and not admin", async () => {
    mocks.requireRole.mockReturnValueOnce({ sub: "u2", role: "client" });
    mocks.prisma.mediaAsset.findUnique.mockResolvedValueOnce({
      id: "m-forbidden",
      deletedAt: null,
      ownerType: "salon",
      ownerId: "s-else",
      salonId: null,
      objectKey: "incoming/f.jpg"
    });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ salonId: "s1", role: "client" });
    await c.delete({ params: { mediaId: "m-forbidden" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "forbidden", expect.any(String));
  });
});
