import { describe, expect, it, vi } from "vitest";

import * as runtime from "./runtime.js";

describe("resolveDatabaseRuntime", () => {
  it("uses postgres when probe succeeds", async () => {
    const result = await runtime.resolveDatabaseRuntime({
      nodeEnv: "production",
      databaseUrl: "postgres://x",
      sqliteDatabasePath: "/tmp/x.sqlite",
      retries: 2,
      retryDelayMs: 1,
      probePostgres: vi.fn().mockResolvedValue(undefined)
    });

    expect(result).toEqual({
      driver: "postgresql",
      mode: "primary",
      attempts: 1,
      url: "postgres://x",
      filePath: null,
      reason: null
    });
  });

  it("falls back to sqlite in development", async () => {
    const result = await runtime.resolveDatabaseRuntime({
      nodeEnv: "development",
      databaseUrl: "postgres://x",
      sqliteDatabasePath: "/tmp/x.sqlite",
      retries: 2,
      retryDelayMs: 1,
      probePostgres: vi.fn().mockRejectedValue(new Error("down")),
      bootstrapSqlite: vi.fn().mockResolvedValue(undefined)
    });

    expect(result.driver).toBe("sqlite");
    expect(result.mode).toBe("fallback");
    expect(result.reason).toContain("postgres_unavailable:down");
  });

  it("throws outside development when postgres unavailable", async () => {
    await expect(
      runtime.resolveDatabaseRuntime({
        nodeEnv: "production",
        databaseUrl: "postgres://x",
        sqliteDatabasePath: "/tmp/x.sqlite",
        retries: 2,
        retryDelayMs: 1,
        probePostgres: vi.fn().mockRejectedValue(new Error("down"))
      })
    ).rejects.toThrowError(/PostgreSQL unavailable after 2 attempts: down/);
  });

  it("retries probe and eventually succeeds", async () => {
    const probe = vi
      .fn()
      .mockRejectedValueOnce(new Error("flaky"))
      .mockResolvedValueOnce(undefined);
    const result = await runtime.resolveDatabaseRuntime({
      nodeEnv: "production",
      databaseUrl: "postgres://x",
      sqliteDatabasePath: "/tmp/x.sqlite",
      retries: 2,
      retryDelayMs: 1,
      probePostgres: probe
    });
    expect(result.attempts).toBe(2);
    expect(result.driver).toBe("postgresql");
  });

  it("reports unknown_error when probe throws non-Error value", async () => {
    await expect(
      runtime.resolveDatabaseRuntime({
        nodeEnv: "production",
        databaseUrl: "postgres://x",
        sqliteDatabasePath: "/tmp/x.sqlite",
        retries: 1,
        retryDelayMs: 1,
        probePostgres: vi.fn().mockRejectedValue("down-string")
      })
    ).rejects.toThrowError(/unknown_error/);
  });

  it("uses default sqlite bootstrap in development fallback", async () => {
    const tmp = `/tmp/beaute-runtime-${Date.now()}.sqlite`;
    const result = await runtime.resolveDatabaseRuntime({
      nodeEnv: "development",
      databaseUrl: "postgres://x",
      sqliteDatabasePath: tmp,
      retries: 1,
      retryDelayMs: 1,
      probePostgres: vi.fn().mockRejectedValue(new Error("down"))
    });
    expect(result.driver).toBe("sqlite");
    expect(result.filePath).toBe(tmp);
  });

  it("covers default probe selection branch when retries is zero", async () => {
    const result = await runtime.resolveDatabaseRuntime({
      nodeEnv: "development",
      databaseUrl: "postgres://x",
      sqliteDatabasePath: `/tmp/beaute-runtime-zero-${Date.now()}.sqlite`,
      retries: 0,
      retryDelayMs: 1,
      bootstrapSqlite: vi.fn().mockResolvedValue(undefined)
    });
    expect(result.driver).toBe("sqlite");
    expect(result.attempts).toBe(0);
  });
});
