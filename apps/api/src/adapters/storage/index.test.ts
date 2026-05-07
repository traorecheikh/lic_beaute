import { describe, it, expect, beforeAll, afterAll } from "vitest";
import { NoopStorageAdapter, LocalStorageAdapter, type StorageAdapter } from "./index.js";
import { mkdtemp, rm } from "node:fs/promises";
import { join } from "node:path";
import { tmpdir } from "node:os";
import { createReadStream, writeFileSync } from "node:fs";

describe("NoopStorageAdapter", () => {
  const adapter = new NoopStorageAdapter();

  it("store returns buffer length for Buffer input", async () => {
    const buf = Buffer.from("hello world");
    const size = await adapter.store("test/file.txt", buf);
    expect(size).toBe(buf.length);
  });

  it("store returns consumed bytes for stream input", async () => {
    const buf = Buffer.from("stream data");
    const size = await adapter.store("test/stream.txt", buf);
    expect(size).toBe(buf.length);
  });

  it("retrieve returns null", async () => {
    const result = await adapter.retrieve("nonexistent");
    expect(result).toBeNull();
  });

  it("delete does not throw", async () => {
    await expect(adapter.delete("any-key")).resolves.toBeUndefined();
  });

  it("publicUrl returns /static/ prefixed path", () => {
    expect(adapter.publicUrl("uploads/abc.jpg")).toBe("/static/uploads/abc.jpg");
  });
});

describe("LocalStorageAdapter", () => {
  let baseDir: string;
  let adapter: StorageAdapter;

  beforeAll(async () => {
    baseDir = await mkdtemp(join(tmpdir(), "ba-storage-test-"));
    adapter = new LocalStorageAdapter(baseDir, "/media");
  });

  afterAll(async () => {
    await rm(baseDir, { recursive: true, force: true });
  });

  it("store and retrieve a buffer", async () => {
    const buf = Buffer.from("hello local storage");
    const size = await adapter.store("test/hello.txt", buf);
    expect(size).toBe(buf.length);

    const retrieved = await adapter.retrieve("test/hello.txt");
    expect(retrieved?.toString()).toBe("hello local storage");
  });

  it("store and retrieve a stream", async () => {
    const filePath = join(baseDir, "source.txt");
    writeFileSync(filePath, "streamed content here");
    const stream = createReadStream(filePath);

    const size = await adapter.store("test/streamed.txt", stream);
    expect(size).toBeGreaterThan(0);

    const retrieved = await adapter.retrieve("test/streamed.txt");
    expect(retrieved?.toString()).toBe("streamed content here");
  });

  it("retrieve returns null for missing file", async () => {
    const result = await adapter.retrieve("nonexistent/file.bin");
    expect(result).toBeNull();
  });

  it("delete removes the file", async () => {
    const buf = Buffer.from("temp data");
    await adapter.store("test/temp.txt", buf);
    await adapter.delete("test/temp.txt");
    const result = await adapter.retrieve("test/temp.txt");
    expect(result).toBeNull();
  });

  it("publicUrl uses the configured base URL", () => {
    expect(adapter.publicUrl("uploads/photo.jpg")).toBe("/media/uploads/photo.jpg");
  });

  it("store creates nested directories", async () => {
    const buf = Buffer.from("deep");
    const size = await adapter.store("a/b/c/deep.txt", buf);
    expect(size).toBe(4);
    const retrieved = await adapter.retrieve("a/b/c/deep.txt");
    expect(retrieved?.toString()).toBe("deep");
  });
});
