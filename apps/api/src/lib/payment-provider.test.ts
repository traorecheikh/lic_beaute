import { describe, expect, it } from "vitest";

import { toDbProvider, toPublicBillingProvider, toPublicGatewayProvider } from "./payment-provider.js";

describe("payment provider mappers", () => {
  it("maps db providers", () => {
    expect(toDbProvider("manual")).toBe("manual");
    expect(toDbProvider("paydunya")).toBe("paydunya");
    expect(toDbProvider(undefined)).toBeNull();
    expect(toDbProvider(null)).toBeNull();
  });

  it("maps public gateway provider — always paydunya", () => {
    expect(toPublicGatewayProvider(undefined)).toBe("paydunya");
    expect(toPublicGatewayProvider(null)).toBe("paydunya");
    expect(toPublicGatewayProvider("paydunya")).toBe("paydunya");
    expect(toPublicGatewayProvider("unknown")).toBe("paydunya");
  });

  it("maps public billing provider", () => {
    expect(toPublicBillingProvider(undefined)).toBeNull();
    expect(toPublicBillingProvider(null)).toBeNull();
    expect(toPublicBillingProvider("manual")).toBe("manual");
    expect(toPublicBillingProvider("paydunya")).toBe("paydunya");
    expect(toPublicBillingProvider("unknown")).toBeNull();
  });
});
