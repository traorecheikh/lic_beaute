import { beforeEach, describe, expect, it, vi } from "vitest";

type HookMap = Record<string, Array<(...args: any[]) => any>>;

function makeAppStub() {
  const hooks: HookMap = {};
  const getRoutes: string[] = [];
  const app = {
    log: { warn: vi.fn(), error: vi.fn() },
    setValidatorCompiler: vi.fn(),
    setSerializerCompiler: vi.fn(),
    register: vi.fn(async () => app),
    addHook: vi.fn((name: string, fn: (...args: any[]) => any) => {
      hooks[name] ??= [];
      hooks[name].push(fn);
      return app;
    }),
    decorate: vi.fn(),
    get: vi.fn((path: string, _h: (...args: any[]) => any) => {
      getRoutes.push(path);
      return app;
    })
  };
  return { app, hooks, getRoutes };
}

describe("createApp unit", () => {
  beforeEach(() => {
    vi.resetModules();
    vi.clearAllMocks();
  });

  it("uses in-memory rate limiter when REDIS_URL is empty", async () => {
    const { app, hooks } = makeAppStub();
    const fastifyCtor = vi.fn(() => app as any);

    vi.doMock("fastify", () => ({ default: fastifyCtor }));
    vi.doMock("./config.js", () => ({
      config: {
        nodeEnv: "development",
        webOrigin: "http://localhost:5174",
        redisUrl: "",
        maxUploadBytes: 1024
      }
    }));
    vi.doMock("./modules/routes.js", () => ({ registerRoutes: vi.fn(async () => undefined) }));
    vi.doMock("./lib/db/prisma.js", () => ({ setPrisma: vi.fn() }));

    const mod = await import("./app.js");
    await mod.createApp({
      databaseRuntime: { driver: "sqlite", mode: "fallback", attempts: 1, url: null, filePath: null, reason: "test" }
    });

    expect(fastifyCtor).toHaveBeenCalledTimes(1);
    expect(app.register).toHaveBeenCalled();
    const registerCalls = app.register.mock.calls;
    const rateLimitCall = registerCalls.find((c: any[]) => c[1]?.timeWindow === "1 minute" && c[1]?.global === true) as any[] | undefined;
    expect(rateLimitCall?.[1]?.max).toBe(100);

    expect(hooks.onSend).toBeDefined();
    const header = vi.fn();
    await hooks.onSend[0]({ id: "req-1" }, { header } as any);
    expect(header).toHaveBeenCalledWith("x-request-id", "req-1");
  });

  it("connects redis and registers distributed rate limit", async () => {
    const { app, hooks } = makeAppStub();
    const fastifyCtor = vi.fn(() => app as any);
    const connect = vi.fn(async () => undefined);
    const ping = vi.fn(async () => "PONG");
    const quit = vi.fn(async () => undefined);
    const disconnect = vi.fn();

    vi.doMock("fastify", () => ({ default: fastifyCtor }));
    function RedisMock() {
      return { connect, ping, quit, disconnect };
    }
    vi.doMock("ioredis", () => ({ Redis: RedisMock }));
    vi.doMock("./config.js", () => ({
      config: {
        nodeEnv: "production",
        webOrigin: "http://localhost:5174",
        redisUrl: "redis://127.0.0.1:6379",
        maxUploadBytes: 1024
      }
    }));
    vi.doMock("./modules/routes.js", () => ({ registerRoutes: vi.fn(async () => undefined) }));
    vi.doMock("./lib/db/prisma.js", () => ({ setPrisma: vi.fn() }));

    const mod = await import("./app.js");
    const created = await mod.createApp({
      databaseRuntime: { driver: "sqlite", mode: "fallback", attempts: 1, url: null, filePath: null, reason: "test" }
    });

    expect(created).toBe(app);
    expect(connect).toHaveBeenCalled();
    expect(ping).toHaveBeenCalled();
    const rateLimitCall = app.register.mock.calls.find((c: any[]) => c[1]?.redis) as any[] | undefined;
    expect(rateLimitCall?.[1]?.max).toBe(100);
    expect(app.decorate).toHaveBeenCalledWith("redisEnabled", true);

    expect(hooks.onClose).toBeDefined();
    await hooks.onClose[0]();
    expect(quit).toHaveBeenCalled();
    expect(disconnect).not.toHaveBeenCalled();
  });

  it("falls back when redis is unavailable and logs warning/error by env", async () => {
    const { app } = makeAppStub();
    const fastifyCtor = vi.fn(() => app as any);
    const connect = vi.fn(async () => {
      throw new Error("boom");
    });
    const ping = vi.fn(async () => "PONG");
    const disconnect = vi.fn();

    vi.doMock("fastify", () => ({ default: fastifyCtor }));
    function RedisMock() {
      return { connect, ping, disconnect, quit: vi.fn() };
    }
    vi.doMock("ioredis", () => ({ Redis: RedisMock }));
    vi.doMock("./config.js", () => ({
      config: {
        nodeEnv: "development",
        webOrigin: "http://localhost:5174",
        redisUrl: "redis://127.0.0.1:6379",
        maxUploadBytes: 1024
      }
    }));
    vi.doMock("./modules/routes.js", () => ({ registerRoutes: vi.fn(async () => undefined) }));
    vi.doMock("./lib/db/prisma.js", () => ({ setPrisma: vi.fn() }));

    const mod = await import("./app.js");
    await mod.createApp({
      databaseRuntime: { driver: "sqlite", mode: "fallback", attempts: 1, url: null, filePath: null, reason: "test" }
    });

    expect(app.log.warn).toHaveBeenCalled();
    expect(disconnect).toHaveBeenCalled();
    const fallbackCall = app.register.mock.calls.find((c: any[]) => c[1]?.timeWindow === "1 minute" && c[1]?.max === 50);
    expect(fallbackCall).toBeTruthy();
    expect(app.decorate).toHaveBeenCalledWith("redisEnabled", false);
  });

  it("logs error level in production when redis is unavailable", async () => {
    const { app } = makeAppStub();
    const fastifyCtor = vi.fn(() => app as any);
    const connect = vi.fn(async () => {
      throw "boom-string";
    });
    const disconnect = vi.fn();

    vi.doMock("fastify", () => ({ default: fastifyCtor }));
    function RedisMock() {
      return { connect, ping: vi.fn(), disconnect, quit: vi.fn() };
    }
    vi.doMock("ioredis", () => ({ Redis: RedisMock }));
    vi.doMock("./config.js", () => ({
      config: {
        nodeEnv: "production",
        webOrigin: "http://localhost:5174",
        redisUrl: "redis://127.0.0.1:6379",
        maxUploadBytes: 1024
      }
    }));
    vi.doMock("./modules/routes.js", () => ({ registerRoutes: vi.fn(async () => undefined) }));
    vi.doMock("./lib/db/prisma.js", () => ({ setPrisma: vi.fn() }));

    const mod = await import("./app.js");
    await mod.createApp({
      databaseRuntime: { driver: "sqlite", mode: "fallback", attempts: 1, url: null, filePath: null, reason: "test" }
    });

    expect(app.log.error).toHaveBeenCalled();
    expect(disconnect).toHaveBeenCalled();
  });

  it("uses stricter in-memory rate-limit in production when redis is not configured", async () => {
    const { app } = makeAppStub();
    vi.doMock("fastify", () => ({ default: vi.fn(() => app as any) }));
    vi.doMock("./config.js", () => ({
      config: {
        nodeEnv: "production",
        webOrigin: "http://localhost:5174",
        redisUrl: "",
        maxUploadBytes: 1024
      }
    }));
    vi.doMock("./modules/routes.js", () => ({ registerRoutes: vi.fn(async () => undefined) }));
    vi.doMock("./lib/db/prisma.js", () => ({ setPrisma: vi.fn() }));

    const mod = await import("./app.js");
    await mod.createApp({
      databaseRuntime: { driver: "sqlite", mode: "fallback", attempts: 1, url: null, filePath: null, reason: "test" }
    });
    const rateLimitCall = app.register.mock.calls.find((c: any[]) => c[1]?.timeWindow === "1 minute" && c[1]?.global === true) as any[] | undefined;
    expect(rateLimitCall?.[1]?.max).toBe(50);
  });

  it("serves static files when public dist exists", async () => {
    const { app, getRoutes } = makeAppStub();

    vi.doMock("fastify", () => ({ default: vi.fn(() => app as any) }));
    vi.doMock("node:fs", () => ({ existsSync: vi.fn(() => true) }));
    vi.doMock("./config.js", () => ({
      config: {
        nodeEnv: "development",
        webOrigin: "http://localhost:5174",
        redisUrl: "",
        maxUploadBytes: 1024
      }
    }));
    vi.doMock("./modules/routes.js", () => ({ registerRoutes: vi.fn(async () => undefined) }));
    vi.doMock("./lib/db/prisma.js", () => ({ setPrisma: vi.fn() }));

    const mod = await import("./app.js");
    const created = await mod.createApp({
      databaseRuntime: { driver: "sqlite", mode: "fallback", attempts: 1, url: null, filePath: null, reason: "test" }
    });

    expect(getRoutes).toContain("/*");
    const catchAll = app.get.mock.calls.find((c: any[]) => c[0] === "/*")?.[1];
    const sendFile = vi.fn();
    expect(catchAll).toBeTypeOf("function");
    await catchAll?.({}, { sendFile });
    expect(sendFile).toHaveBeenCalled();
    expect(created).toBe(app);
  });

  it("sets prisma override when provided", async () => {
    const { app } = makeAppStub();
    const setPrisma = vi.fn();
    vi.doMock("fastify", () => ({ default: vi.fn(() => app as any) }));
    vi.doMock("./config.js", () => ({
      config: {
        nodeEnv: "development",
        webOrigin: "http://localhost:5174",
        redisUrl: "",
        maxUploadBytes: 1024
      }
    }));
    vi.doMock("./modules/routes.js", () => ({ registerRoutes: vi.fn(async () => undefined) }));
    vi.doMock("./lib/db/prisma.js", () => ({ setPrisma }));

    const mod = await import("./app.js");
    const prisma = { user: {} } as any;
    await mod.createApp({
      databaseRuntime: { driver: "sqlite", mode: "fallback", attempts: 1, url: null, filePath: null, reason: "test" },
      prisma
    });
    expect(setPrisma).toHaveBeenCalledWith(prisma);
  });
});
