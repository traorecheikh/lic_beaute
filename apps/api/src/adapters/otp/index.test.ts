import { describe, expect, it, vi } from "vitest";

import { AfricasTalkingOtpAdapter, NoopOtpAdapter } from "./index.js";

describe("otp adapters", () => {
  it("noop adapter sends and verifies", async () => {
    const adapter = new NoopOtpAdapter();
    await expect(adapter.send("+221771234567", "1234")).resolves.toBeUndefined();
    await expect(adapter.verify("+221771234567", "1234")).resolves.toBe(true);
    await expect(adapter.send("123", "9")).resolves.toBeUndefined();
  });

  it("africas talking send success", async () => {
    const fetchMock = vi.fn().mockResolvedValue({ ok: true });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = new AfricasTalkingOtpAdapter("k", "u", "sender");
    await adapter.send("+221771234567", "1234");
    await expect(adapter.verify("+221771234567", "1234")).resolves.toBe(true);

    expect(fetchMock).toHaveBeenCalledTimes(1);
    const args = fetchMock.mock.calls[0];
    expect(args?.[0]).toBe("https://api.africastalking.com/version1/messaging");
  });

  it("africas talking send success without sender id", async () => {
    const fetchMock = vi.fn().mockResolvedValue({ ok: true });
    vi.stubGlobal("fetch", fetchMock);
    const adapter = new AfricasTalkingOtpAdapter("k", "u");
    await adapter.send("+221771234567", "1234");
    await adapter.send("123", "1234");
    expect(fetchMock).toHaveBeenCalledTimes(2);
  });

  it("africas talking send failure throws", async () => {
    const fetchMock = vi.fn().mockResolvedValue({
      ok: false,
      status: 500,
      text: vi.fn().mockResolvedValue("server_error")
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = new AfricasTalkingOtpAdapter("k", "u");
    await expect(adapter.send("+221771234567", "1234")).rejects.toThrowError(/SMS failed/);
  });

  it("africas talking failure tolerates response text read error", async () => {
    const fetchMock = vi.fn().mockResolvedValue({
      ok: false,
      status: 400,
      text: vi.fn().mockRejectedValue(new Error("read-fail"))
    });
    vi.stubGlobal("fetch", fetchMock);
    const adapter = new AfricasTalkingOtpAdapter("k", "u");
    await expect(adapter.send("+221771234567", "1234")).rejects.toThrowError(/400/);
  });
});
