import { describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const dotenvConfig = vi.fn();
  const PrismaPg = vi.fn();
  class PrismaClient {
    user = { findMany: vi.fn() };
  }
  return { dotenvConfig, PrismaPg, PrismaClient };
});

vi.mock("dotenv", () => ({ default: { config: mocks.dotenvConfig } }));
vi.mock("@prisma/adapter-pg", () => ({ PrismaPg: mocks.PrismaPg }));
vi.mock("../../generated/prisma/client.js", () => ({ PrismaClient: mocks.PrismaClient }));
vi.mock("../../config.js", () => ({ config: { databaseUrl: "postgres://default" } }));

describe("db/prisma", () => {
  it("creates singleton and proxy resolves properties", async () => {
    vi.resetModules();
    const mod = await import("./prisma.js");
    const instance1 = mod.getPrisma();
    const instance2 = mod.getPrisma();
    expect(instance1).toBe(instance2);
    expect(mocks.PrismaPg).toHaveBeenCalled();
    expect(mod.prisma.user).toBeDefined();
  });

  it("setPrisma overrides singleton", async () => {
    vi.resetModules();
    const mod = await import("./prisma.js");
    const fake = { hello: "world" } as never;
    mod.setPrisma(fake);
    expect(mod.getPrisma()).toBe(fake);
  });
});
