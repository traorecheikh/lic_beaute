import { describe, expect, it } from "vitest";

import { bookingStatusSchema, paymentProviderSchema } from "./index.js";

describe("contracts", () => {
  it("keeps core enums centralized", () => {
    expect(bookingStatusSchema.parse("confirmed")).toBe("confirmed");
    expect(paymentProviderSchema.parse("paytech")).toBe("paytech");
  });
});
