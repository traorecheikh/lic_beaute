import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const connect = vi.fn();
  const query = vi.fn();
  const end = vi.fn();
  const access = vi.fn();
  const mkdir = vi.fn();
  const writeFile = vi.fn();
  const Client = vi.fn(function ClientMock() {
    return { connect, query, end };
  });
  return { connect, query, end, access, mkdir, writeFile, Client };
});

vi.mock("pg", () => ({ Client: mocks.Client }));
vi.mock("node:fs/promises", () => ({
  access: mocks.access,
  mkdir: mocks.mkdir,
  writeFile: mocks.writeFile
}));

import { bootstrapSqlite, probePostgres } from "./runtime.js";

describe("runtime internals", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mocks.connect.mockResolvedValue(undefined);
    mocks.query.mockResolvedValue(undefined);
    mocks.end.mockResolvedValue(undefined);
    mocks.mkdir.mockResolvedValue(undefined);
    mocks.access.mockResolvedValue(undefined);
    mocks.writeFile.mockResolvedValue(undefined);
  });

  it("probePostgres strips query string and probes select 1", async () => {
    await probePostgres("postgresql://u:p@h:5432/db?schema=public");
    expect(mocks.Client).toHaveBeenCalledWith(expect.objectContaining({
      connectionString: "postgresql://u:p@h:5432/db"
    }));
    expect(mocks.connect).toHaveBeenCalled();
    expect(mocks.query).toHaveBeenCalledWith("select 1");
    expect(mocks.end).toHaveBeenCalled();
  });

  it("probePostgres still ends client when query fails", async () => {
    mocks.query.mockRejectedValueOnce(new Error("boom"));
    await expect(probePostgres("postgresql://x")).rejects.toThrow("boom");
    expect(mocks.end).toHaveBeenCalled();
  });

  it("bootstrapSqlite creates folder and file when missing", async () => {
    mocks.access.mockRejectedValueOnce(new Error("ENOENT"));
    await bootstrapSqlite("/tmp/runtime/a.sqlite");
    expect(mocks.mkdir).toHaveBeenCalled();
    expect(mocks.writeFile).toHaveBeenCalledWith("/tmp/runtime/a.sqlite", "");
  });

  it("bootstrapSqlite does not rewrite existing file", async () => {
    await bootstrapSqlite("/tmp/runtime/b.sqlite");
    expect(mocks.mkdir).toHaveBeenCalled();
    expect(mocks.writeFile).not.toHaveBeenCalled();
  });
});
