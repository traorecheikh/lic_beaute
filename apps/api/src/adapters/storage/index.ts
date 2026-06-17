import { createWriteStream } from "node:fs";
import { mkdir } from "node:fs/promises";
import { join } from "node:path";
import { pipeline } from "node:stream/promises";
import type { Readable } from "node:stream";

export interface StorageAdapter {
  /** Store the file data at the given key. Returns the number of bytes written. */
  store(objectKey: string, data: Buffer | Readable, mimeType?: string): Promise<number>;
  /** Retrieve the file data. Returns null if not found. */
  retrieve(objectKey: string): Promise<Buffer | null>;
  /** Delete the file data. */
  delete(objectKey: string): Promise<void>;
  /** Return the public-facing URL for the given object key. */
  publicUrl(objectKey: string): string;

  /** Get a signed URL for uploading. Throws if not supported by the adapter. */
  presignPut(objectKey: string, mimeType: string, expiresIn?: number): Promise<string>;
  /** Get a signed URL for reading. Throws if not supported by the adapter. */
  presignGet(objectKey: string, expiresIn?: number): Promise<string>;
  /** Get metadata for an object. Returns null if not found. */
  headObject(objectKey: string): Promise<{ sizeBytes: number; etag?: string } | null>;
  /** Copy an object from sourceKey to destKey. */
  copyObject(sourceKey: string, destKey: string): Promise<void>;
  /** Delete an object by key. */
  deleteObject(objectKey: string): Promise<void>;
}

export class NoopStorageAdapter implements StorageAdapter {
  async store(_objectKey: string, data: Buffer | Readable): Promise<number> {
    if (data instanceof Buffer) return data.length;
    let size = 0;
    for await (const chunk of data as unknown as AsyncIterable<Buffer>) {
      size += chunk.length;
    }
    return size;
  }
  async retrieve(_objectKey: string): Promise<Buffer | null> {
    return null;
  }
  async delete(_objectKey: string): Promise<void> {}
  publicUrl(_objectKey: string): string {
    return `/static/${_objectKey}`;
  }
  async presignPut(_objectKey: string, _mimeType: string, _expiresIn?: number): Promise<string> {
    throw new Error("presignPut is not supported by NoopStorageAdapter");
  }
  async presignGet(_objectKey: string, _expiresIn?: number): Promise<string> {
    throw new Error("presignGet is not supported by NoopStorageAdapter");
  }
  async headObject(_objectKey: string): Promise<{ sizeBytes: number; etag?: string } | null> {
    return null;
  }
  async copyObject(_sourceKey: string, _destKey: string): Promise<void> {
    // no-op
  }
  async deleteObject(_objectKey: string): Promise<void> {
    // no-op
  }
}

export class LocalStorageAdapter implements StorageAdapter {
  private baseDir: string;
  private baseUrl: string;

  constructor(baseDir: string, baseUrl: string = "/static") {
    this.baseDir = baseDir;
    this.baseUrl = baseUrl;
  }

  async store(objectKey: string, data: Buffer | Readable): Promise<number> {
    const filePath = join(this.baseDir, objectKey);
    await mkdir(join(this.baseDir, objectKey.split("/").slice(0, -1).join("/")), { recursive: true });

    if (data instanceof Buffer) {
      const { writeFile } = await import("node:fs/promises");
      await writeFile(filePath, data);
      return data.length;
    }

    const writeStream = createWriteStream(filePath);
    await pipeline(data as Readable, writeStream);
    return writeStream.bytesWritten;
  }

  async retrieve(objectKey: string): Promise<Buffer | null> {
    const { readFile } = await import("node:fs/promises");
    try {
      return await readFile(join(this.baseDir, objectKey));
    } catch {
      return null;
    }
  }

  async delete(objectKey: string): Promise<void> {
    const { unlink } = await import("node:fs/promises");
    try {
      await unlink(join(this.baseDir, objectKey));
    } catch {}
  }

  publicUrl(objectKey: string): string {
    return `${this.baseUrl}/${objectKey}`;
  }

  async presignPut(_objectKey: string, _mimeType: string, _expiresIn?: number): Promise<string> {
    throw new Error("presignPut is not supported by LocalStorageAdapter — use upload() for local storage");
  }

  async presignGet(_objectKey: string, _expiresIn?: number): Promise<string> {
    throw new Error("presignGet is not supported by LocalStorageAdapter");
  }

  async headObject(objectKey: string): Promise<{ sizeBytes: number; etag?: string } | null> {
    const { stat } = await import("node:fs/promises");
    try {
      const stats = await stat(join(this.baseDir, objectKey));
      return { sizeBytes: stats.size };
    } catch {
      return null;
    }
  }

  async copyObject(sourceKey: string, destKey: string): Promise<void> {
    const { copyFile } = await import("node:fs/promises");
    const destPath = join(this.baseDir, destKey);
    await mkdir(join(this.baseDir, destKey.split("/").slice(0, -1).join("/")), { recursive: true });
    await copyFile(join(this.baseDir, sourceKey), destPath);
  }

  async deleteObject(objectKey: string): Promise<void> {
    return this.delete(objectKey);
  }
}
