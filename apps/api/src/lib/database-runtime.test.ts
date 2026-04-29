import { describe, expect, it, vi } from "vitest";

import { resolveDatabaseRuntime } from "./database-runtime.js";

describe("resolveDatabaseRuntime", () => {
  it("returns postgresql runtime when the connection succeeds", async () => {
    const probePostgres = vi
      .fn<(databaseUrl: string) => Promise<void>>()
      .mockRejectedValueOnce(new Error("connect ECONNREFUSED"))
      .mockResolvedValueOnce(undefined);

    const runtime = await resolveDatabaseRuntime({
      nodeEnv: "development",
      databaseUrl: "postgresql://postgres:postgres@localhost:5432/beaute_avenue?schema=public",
      sqliteDatabasePath: "/tmp/beauteavenue.dev.sqlite",
      retries: 3,
      retryDelayMs: 0,
      probePostgres,
      bootstrapSqlite: vi.fn()
    });

    expect(runtime).toEqual({
      driver: "postgresql",
      mode: "primary",
      attempts: 2,
      url: "postgresql://postgres:postgres@localhost:5432/beaute_avenue?schema=public",
      filePath: null,
      reason: null
    });
    expect(probePostgres).toHaveBeenCalledTimes(2);
  });

  it("falls back to sqlite in development after retries are exhausted", async () => {
    const probePostgres = vi.fn<(databaseUrl: string) => Promise<void>>().mockRejectedValue(new Error("timeout"));
    const bootstrapSqlite = vi.fn<(filePath: string) => Promise<void>>().mockResolvedValue(undefined);

    const runtime = await resolveDatabaseRuntime({
      nodeEnv: "development",
      databaseUrl: "postgresql://postgres:postgres@localhost:5432/beaute_avenue?schema=public",
      sqliteDatabasePath: "/tmp/beauteavenue.dev.sqlite",
      retries: 3,
      retryDelayMs: 0,
      probePostgres,
      bootstrapSqlite
    });

    expect(runtime).toEqual({
      driver: "sqlite",
      mode: "fallback",
      attempts: 3,
      url: null,
      filePath: "/tmp/beauteavenue.dev.sqlite",
      reason: "postgres_unavailable:timeout"
    });
    expect(probePostgres).toHaveBeenCalledTimes(3);
    expect(bootstrapSqlite).toHaveBeenCalledWith("/tmp/beauteavenue.dev.sqlite");
  });

  it("throws in non-development environments when postgres remains unavailable", async () => {
    const probePostgres = vi
      .fn<(databaseUrl: string) => Promise<void>>()
      .mockRejectedValue(new Error("password authentication failed"));

    await expect(
      resolveDatabaseRuntime({
        nodeEnv: "production",
        databaseUrl: "postgresql://postgres:postgres@localhost:5432/beaute_avenue?schema=public",
        sqliteDatabasePath: "/tmp/beauteavenue.dev.sqlite",
        retries: 3,
        retryDelayMs: 0,
        probePostgres,
        bootstrapSqlite: vi.fn()
      })
    ).rejects.toThrow("PostgreSQL unavailable after 3 attempts: password authentication failed");
  });
});
