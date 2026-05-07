import { describe, expect, it } from "vitest";
import { pushTokenRegisterSchema } from "./notification.js";

describe("pushTokenRegisterSchema", () => {
  it("accepts a valid ios token payload", () => {
    const result = pushTokenRegisterSchema.safeParse({
      token: "abc123",
      platform: "ios",
      deviceId: "device-1"
    });
    expect(result.success).toBe(true);
  });

  it("accepts a valid android token payload", () => {
    const result = pushTokenRegisterSchema.safeParse({
      token: "def456",
      platform: "android",
      deviceId: "device-2"
    });
    expect(result.success).toBe(true);
  });

  it("rejects a missing token", () => {
    const result = pushTokenRegisterSchema.safeParse({
      platform: "ios",
      deviceId: "device-1"
    });
    expect(result.success).toBe(false);
  });

  it("rejects an empty token", () => {
    const result = pushTokenRegisterSchema.safeParse({
      token: "",
      platform: "ios",
      deviceId: "device-1"
    });
    expect(result.success).toBe(false);
  });

  it("rejects an invalid platform", () => {
    const result = pushTokenRegisterSchema.safeParse({
      token: "abc123",
      platform: "web",
      deviceId: "device-1"
    });
    expect(result.success).toBe(false);
  });

  it("rejects a missing deviceId", () => {
    const result = pushTokenRegisterSchema.safeParse({
      token: "abc123",
      platform: "android"
    });
    expect(result.success).toBe(false);
  });

  it("rejects an oversized token (>512 chars)", () => {
    const result = pushTokenRegisterSchema.safeParse({
      token: "x".repeat(513),
      platform: "ios",
      deviceId: "device-1"
    });
    expect(result.success).toBe(false);
  });
});
