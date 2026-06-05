import { describe, expect, it } from "vitest";
import {
  bookingStatusSchema,
  paymentChannelSchema,
  paymentWebhookBodySchema,
  paymentProviderSchema
} from "./index.js";

describe("contracts", () => {
  it("keeps core enums centralized", () => {
    expect(bookingStatusSchema.parse("confirmed")).toBe("confirmed");
    expect(paymentProviderSchema.parse("paydunya")).toBe("paydunya");
  });

  it("accepts supported payment channels for routing", () => {
    expect(paymentChannelSchema.parse("wave_senegal")).toBe("wave_senegal");
    expect(paymentChannelSchema.parse("orange_senegal")).toBe("orange_senegal");
    expect(paymentChannelSchema.parse("carte_bancaire")).toBe("carte_bancaire");
    expect(paymentChannelSchema.parse("om_ci")).toBe("om_ci");
    expect(paymentChannelSchema.parse("wave_ci")).toBe("wave_ci");
    expect(paymentChannelSchema.parse("djamo")).toBe("djamo");
    expect(paymentChannelSchema.parse("paydunya_wallet")).toBe("paydunya_wallet");
    expect(paymentChannelSchema.parse("wave")).toBe("wave");
    expect(paymentChannelSchema.parse("orange_money")).toBe("orange_money");
    expect(paymentChannelSchema.parse("free_money")).toBe("free_money");
    expect(() => paymentChannelSchema.parse("wizall")).toThrow();
    expect(() => paymentChannelSchema.parse("card")).toThrow();
    expect(() => paymentChannelSchema.parse("mvola")).toThrow();
  });

  it("accepts flexible webhook callback payloads with integrity fields", () => {
    const payload = paymentWebhookBodySchema.parse({
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
