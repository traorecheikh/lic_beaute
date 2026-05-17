import { describe, expect, it, vi } from "vitest";

import { logger } from "./logger.js";

describe("logger", () => {
  it("writes info payload", () => {
    const spy = vi.spyOn(console, "info").mockImplementation(() => undefined);
    logger.info("hello", { a: 1 });
    expect(spy).toHaveBeenCalledTimes(1);
    expect(spy.mock.calls[0]?.[0]).toContain('"level":"info"');
    expect(spy.mock.calls[0]?.[0]).toContain('"message":"hello"');
    expect(spy.mock.calls[0]?.[0]).toContain('"a":1');
    spy.mockRestore();
  });

  it("writes warn payload", () => {
    const spy = vi.spyOn(console, "warn").mockImplementation(() => undefined);
    logger.warn("careful", { a: 2 });
    expect(spy).toHaveBeenCalledTimes(1);
    expect(spy.mock.calls[0]?.[0]).toContain('"level":"warn"');
    expect(spy.mock.calls[0]?.[0]).toContain('"message":"careful"');
    spy.mockRestore();
  });

  it("serializes Error with custom fields", () => {
    const spy = vi.spyOn(console, "error").mockImplementation(() => undefined);
    const err = Object.assign(new Error("boom"), { code: "x_custom" });
    logger.error("failed", { error: err });
    const payload = spy.mock.calls[0]?.[0] as string;
    expect(payload).toContain('"level":"error"');
    expect(payload).toContain('"message":"failed"');
    expect(payload).toContain('"code":"x_custom"');
    spy.mockRestore();
  });

  it("keeps enumerable error keys that already exist in base serialization stable", () => {
    const spy = vi.spyOn(console, "error").mockImplementation(() => undefined);
    const err = new Error("boom-original");
    Object.defineProperty(err, "message", { value: "boom-overridden", enumerable: true, configurable: true });
    Object.defineProperty(err, "stack", { value: "fake-stack", enumerable: true, configurable: true });
    logger.error("failed", { error: err });
    const payload = spy.mock.calls[0]?.[0] as string;
    expect(payload).toContain('"message":"boom-overridden"');
    expect(payload).toContain('"stack":"fake-stack"');
    spy.mockRestore();
  });

  it("serializes Error with undefined stack to empty string fallback", () => {
    const spy = vi.spyOn(console, "error").mockImplementation(() => undefined);
    const err = new Error("boom-no-stack");
    Object.defineProperty(err, "stack", { value: undefined, enumerable: true, configurable: true });
    logger.error("failed", { error: err });
    expect(spy.mock.calls[0]?.[0]).toContain('"stack":""');
    spy.mockRestore();
  });

  it("serializes string errors", () => {
    const spy = vi.spyOn(console, "error").mockImplementation(() => undefined);
    logger.error("failed", { error: "ouch" });
    expect(spy.mock.calls[0]?.[0]).toContain('"message":"ouch"');
    spy.mockRestore();
  });

  it("serializes non-error non-string values", () => {
    const spy = vi.spyOn(console, "error").mockImplementation(() => undefined);
    logger.error("failed", { error: 42 });
    expect(spy.mock.calls[0]?.[0]).toContain('"message":"42"');
    spy.mockRestore();
  });

  it("logs error without context object", () => {
    const spy = vi.spyOn(console, "error").mockImplementation(() => undefined);
    logger.error("plain");
    expect(spy.mock.calls[0]?.[0]).toContain('"message":"plain"');
    spy.mockRestore();
  });

  it("logs error context when no error field is provided", () => {
    const spy = vi.spyOn(console, "error").mockImplementation(() => undefined);
    logger.error("ctx-only", { key: "value" });
    expect(spy.mock.calls[0]?.[0]).toContain('"key":"value"');
    spy.mockRestore();
  });
});
