import { describe, expect, it } from "vitest";

import {
  bookingStatusSchema,
  paymentChannelSchema,
  paymentIntechCallbackSchema,
  paymentProviderSchema
} from "./index.js";

describe("contracts", () => {
  it("keeps core enums centralized", () => {
    expect(bookingStatusSchema.parse("confirmed")).toBe("confirmed");
    expect(paymentProviderSchema.parse("intech")).toBe("intech");
  });

  it("accepts supported payment channels for routing", () => {
    expect(paymentChannelSchema.parse("wave")).toBe("wave");
    expect(paymentChannelSchema.parse("orange_money")).toBe("orange_money");
    expect(paymentChannelSchema.parse("free_money")).toBe("free_money");
    expect(() => paymentChannelSchema.parse("wizall")).toThrow();
    expect(() => paymentChannelSchema.parse("card")).toThrow();
    expect(() => paymentChannelSchema.parse("mvola")).toThrow();
  });

  it("accepts flexible intech callback payloads with integrity fields", () => {
    const payload = paymentIntechCallbackSchema.parse({
      idFromGu: "GU-123",
      idFromClient: "PAY-123",
      serviceCode: "WAVE_SN",
      infoHash: "abc",
      secureHash: "def",
      extra: "preserved"
    });
    expect(payload.idFromClient).toBe("PAY-123");
    expect(payload.extra).toBe("preserved");
  });
});
