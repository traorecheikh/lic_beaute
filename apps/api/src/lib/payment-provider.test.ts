import { describe, expect, it } from "vitest";

import { toDbProvider, toPublicBillingProvider, toPublicGatewayProvider } from "./payment-provider.js";

describe("payment provider mappers", () => {
  it("maps db providers", () => {
    expect(toDbProvider("manual")).toBe("manual");
    expect(toDbProvider("intech")).toBe("intech");
    expect(toDbProvider(undefined)).toBeNull();
    expect(toDbProvider(null)).toBeNull();
  });

  it("maps public gateway provider", () => {
    expect(toPublicGatewayProvider(undefined)).toBe("intech");
    expect(toPublicGatewayProvider(null)).toBe("intech");
    expect(toPublicGatewayProvider("intech")).toBe("intech");
    expect(toPublicGatewayProvider("other")).toBe("intech");
  });

  it("maps public billing provider", () => {
    expect(toPublicBillingProvider(undefined)).toBeNull();
    expect(toPublicBillingProvider(null)).toBeNull();
    expect(toPublicBillingProvider("manual")).toBe("manual");
    expect(toPublicBillingProvider("intech")).toBe("intech");
    expect(toPublicBillingProvider("unknown")).toBe("intech");
  });
});
