import type { Readable } from "node:stream";
import { CopyObjectCommand, DeleteObjectCommand, GetObjectCommand, HeadObjectCommand, PutObjectCommand, S3Client } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

import type { StorageAdapter } from "./index.js";

export class R2StorageAdapter implements StorageAdapter {
  private client: S3Client;

  constructor(
    private accountId: string,
    private accessKeyId: string,
    private secretAccessKey: string,
    private bucket: string,
    private publicBaseUrl: string
  ) {
    this.client = new S3Client({
      region: "auto",
      endpoint: `https://${accountId}.r2.cloudflarestorage.com`,
      credentials: { accessKeyId, secretAccessKey }
    });
  }

  async presignPut(objectKey: string, mimeType: string, expiresIn = 300): Promise<string> {
    return getSignedUrl(
      this.client,
      new PutObjectCommand({ Bucket: this.bucket, Key: objectKey, ContentType: mimeType }),
      { expiresIn }
    );
  }

  async presignGet(objectKey: string, expiresIn = 300): Promise<string> {
    return getSignedUrl(this.client, new GetObjectCommand({ Bucket: this.bucket, Key: objectKey }), { expiresIn });
  }

  async store(objectKey: string, data: Buffer | Readable, mimeType?: string): Promise<number> {
    const buffer = data instanceof Buffer ? data : await streamToBuffer(data as Readable);
    await this.client.send(
      new PutObjectCommand({ Bucket: this.bucket, Key: objectKey, Body: buffer, ContentType: mimeType })
    );
    return buffer.length;
  }

  async retrieve(_objectKey: string): Promise<Buffer | null> {
    throw new Error("retrieve() is not supported on R2StorageAdapter — use presignGet() for signed URLs instead");
  }

  async delete(objectKey: string): Promise<void> {
    await this.deleteObject(objectKey);
  }

  async headObject(objectKey: string): Promise<{ sizeBytes: number; etag?: string } | null> {
    try {
      const result = await this.client.send(new HeadObjectCommand({ Bucket: this.bucket, Key: objectKey }));
      return {
        sizeBytes: result.ContentLength ?? 0,
        etag: result.ETag?.replace(/"/g, "")
      };
    } catch {
      return null;
    }
  }

  async copyObject(sourceKey: string, destKey: string): Promise<void> {
    await this.client.send(
      new CopyObjectCommand({
        Bucket: this.bucket,
        CopySource: `${this.bucket}/${sourceKey}`,
        Key: destKey
      })
    );
  }

  async deleteObject(objectKey: string): Promise<void> {
    await this.client.send(new DeleteObjectCommand({ Bucket: this.bucket, Key: objectKey }));
  }

  publicUrl(objectKey: string): string {
    return `${this.publicBaseUrl}/${objectKey}`;
  }
}

async function streamToBuffer(stream: Readable): Promise<Buffer> {
  const chunks: Buffer[] = [];
  for await (const chunk of stream) {
    chunks.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk as string));
  }
  return Buffer.concat(chunks);
}
