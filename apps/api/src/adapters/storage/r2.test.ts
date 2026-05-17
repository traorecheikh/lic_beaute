import { Readable } from "node:stream";

import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const send = vi.fn();
  const getSignedUrl = vi.fn();
  return { send, getSignedUrl };
});

vi.mock("@aws-sdk/client-s3", () => ({
  S3Client: class { send = mocks.send; },
  PutObjectCommand: class { constructor(public input: unknown) {} },
  GetObjectCommand: class { constructor(public input: unknown) {} },
  HeadObjectCommand: class { constructor(public input: unknown) {} },
  CopyObjectCommand: class { constructor(public input: unknown) {} },
  DeleteObjectCommand: class { constructor(public input: unknown) {} }
}));
vi.mock("@aws-sdk/s3-request-presigner", () => ({ getSignedUrl: mocks.getSignedUrl }));

import { R2StorageAdapter } from "./r2.js";

describe("R2StorageAdapter", () => {
  let adapter: R2StorageAdapter;

  beforeEach(() => {
    vi.clearAllMocks();
    adapter = new R2StorageAdapter("acc", "key", "secret", "bucket", "https://cdn.example.com");
  });

  it("presigns put/get URLs", async () => {
    mocks.getSignedUrl.mockResolvedValueOnce("https://put").mockResolvedValueOnce("https://get");
    await expect(adapter.presignPut("a.jpg", "image/jpeg")).resolves.toBe("https://put");
    await expect(adapter.presignGet("a.jpg")).resolves.toBe("https://get");
  });

  it("stores buffer and stream", async () => {
    mocks.send.mockResolvedValue({});
    await expect(adapter.store("a.jpg", Buffer.from("abc"), "image/jpeg")).resolves.toBe(3);
    await expect(adapter.store("b.jpg", Readable.from("abcd"), "image/jpeg")).resolves.toBe(4);
    await expect(adapter.store("c.jpg", Readable.from([Buffer.from("ab"), Buffer.from("cd")]), "image/jpeg")).resolves.toBe(4);
    await expect(adapter.store("d.jpg", Readable.from(["ab", "cd"]), "image/jpeg")).resolves.toBe(4);
  });

  it("headObject returns parsed result and null on errors", async () => {
    mocks.send.mockResolvedValueOnce({ ContentLength: 10, ETag: '"etag1"' }).mockRejectedValueOnce(new Error("404"));
    await expect(adapter.headObject("a.jpg")).resolves.toEqual({ sizeBytes: 10, etag: "etag1" });
    await expect(adapter.headObject("b.jpg")).resolves.toBeNull();
  });

  it("headObject falls back when ContentLength/ETag are absent", async () => {
    mocks.send.mockResolvedValueOnce({});
    await expect(adapter.headObject("empty-meta.jpg")).resolves.toEqual({ sizeBytes: 0, etag: undefined });
  });

  it("copy/delete/publicUrl", async () => {
    mocks.send.mockResolvedValue({});
    await expect(adapter.delete("x")).resolves.toBeUndefined();
    await expect(adapter.copyObject("src", "dst")).resolves.toBeUndefined();
    await expect(adapter.deleteObject("dst")).resolves.toBeUndefined();
    expect(adapter.publicUrl("x")).toBe("https://cdn.example.com/x");
  });

  it("retrieve throws unsupported error", async () => {
    await expect(adapter.retrieve("nope")).rejects.toThrow(/not supported/);
  });
});
