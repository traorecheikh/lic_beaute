import { describe, expect, it } from "vitest";

import { ApiError } from "./api";
import { shouldRetryAdminQuery } from "./query";

describe("shouldRetryAdminQuery", () => {
  it("does not retry 4xx api errors", () => {
    expect(shouldRetryAdminQuery(1, new ApiError(404, "subscription_not_found", "Missing"))).toBe(false);
    expect(shouldRetryAdminQuery(1, new ApiError(401, "missing_auth", "Unauthorized"))).toBe(false);
  });

  it("retries a server error only once", () => {
    expect(shouldRetryAdminQuery(1, new ApiError(500, "server_error", "Boom"))).toBe(true);
    expect(shouldRetryAdminQuery(2, new ApiError(500, "server_error", "Boom"))).toBe(false);
  });

  it("retries one unknown failure once", () => {
    expect(shouldRetryAdminQuery(1, new Error("network"))).toBe(true);
    expect(shouldRetryAdminQuery(2, new Error("network"))).toBe(false);
  });
});
