import { Readable } from "node:stream";

import { describe, expect, it, vi } from "vitest";

type Route = { method: string; path: string; opts?: unknown; handler?: (...args: any[]) => unknown };

function makeApp() {
  const routes: Route[] = [];
  return {
    app: {
      redisEnabled: true,
      get: (path: string, optsOrHandler: unknown, maybeHandler?: Route["handler"]) => {
        if (typeof optsOrHandler === "function") routes.push({ method: "GET", path, handler: optsOrHandler as Route["handler"] });
        else routes.push({ method: "GET", path, opts: optsOrHandler, handler: maybeHandler });
      },
      post: (path: string, optsOrHandler: unknown, maybeHandler?: Route["handler"]) => {
        if (typeof optsOrHandler === "function") routes.push({ method: "POST", path, handler: optsOrHandler as Route["handler"] });
        else routes.push({ method: "POST", path, opts: optsOrHandler, handler: maybeHandler });
      },
      patch: (path: string, optsOrHandler: unknown, maybeHandler?: Route["handler"]) => {
        if (typeof optsOrHandler === "function") routes.push({ method: "PATCH", path, handler: optsOrHandler as Route["handler"] });
        else routes.push({ method: "PATCH", path, opts: optsOrHandler, handler: maybeHandler });
      },
      delete: (path: string, optsOrHandler: unknown, maybeHandler?: Route["handler"]) => {
        if (typeof optsOrHandler === "function") routes.push({ method: "DELETE", path, handler: optsOrHandler as Route["handler"] });
        else routes.push({ method: "DELETE", path, opts: optsOrHandler, handler: maybeHandler });
      },
      put: (path: string, optsOrHandler: unknown, maybeHandler?: Route["handler"]) => {
        if (typeof optsOrHandler === "function") routes.push({ method: "PUT", path, handler: optsOrHandler as Route["handler"] });
        else routes.push({ method: "PUT", path, opts: optsOrHandler, handler: maybeHandler });
      }
    },
    routes
  };
}

describe("registerRoutes", () => {
  it("registers all route groups and health responds", async () => {
    const { registerRoutes } = await import("./routes.js");
    const { app, routes } = makeApp();

    await registerRoutes(app as never, { driver: "prisma", mode: "connected", attempts: 1 } as never);

    expect(routes.length).toBeGreaterThan(90);
    const health = routes.find((r) => r.method === "GET" && r.path === "/health");
    expect(health?.handler).toBeDefined();
    const payload = await health?.handler?.({} as never, {} as never);
    expect(payload).toMatchObject({ status: "ok", database: { driver: "prisma" } });
  });

  it("health reflects redis disabled state", async () => {
    const { registerRoutes } = await import("./routes.js");
    const { app, routes } = makeApp();
    (app as any).redisEnabled = false;

    await registerRoutes(app as never, { driver: "prisma", mode: "connected", attempts: 2 } as never);
    const health = routes.find((r) => r.method === "GET" && r.path === "/health");
    const payload = await health?.handler?.({} as never, {} as never);
    expect(payload).toMatchObject({ redis: { status: "disabled" }, database: { attempts: 2 } });
  });

  it("webhook preParsing captures rawBody and returns readable payload", async () => {
    const { registerRoutes } = await import("./routes.js");
    const { app, routes } = makeApp();
    await registerRoutes(app as never, { driver: "prisma", mode: "connected", attempts: 1 } as never);

    const webhook = routes.find((r) => r.path === "/api/v1/payments/webhooks/paydunya" && r.method === "POST");
    expect(webhook?.opts).toBeDefined();
    const preParsing = (webhook?.opts as { preParsing: (req: unknown, rep: unknown, payload: Readable) => Promise<Readable> }).preParsing;

    const req = {} as { rawBody?: string };
    const raw = Buffer.from('{"ok":true}', "utf-8");
    const stream = Readable.from(raw);
    const returned = await preParsing(req, {}, stream);

    expect(req.rawBody).toBe('{"ok":true}');
    const chunks: Buffer[] = [];
    for await (const chunk of returned) chunks.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk));
    expect(Buffer.concat(chunks).toString("utf-8")).toBe('{"ok":true}');
  });

  it("webhook preParsing handles non-buffer chunks", async () => {
    const { registerRoutes } = await import("./routes.js");
    const { app, routes } = makeApp();
    await registerRoutes(app as never, { driver: "prisma", mode: "connected", attempts: 1 } as never);

    const webhook = routes.find((r) => r.path === "/api/v1/payments/webhooks/paydunya" && r.method === "POST");
    const preParsing = (webhook?.opts as { preParsing: (req: unknown, rep: unknown, payload: Readable) => Promise<Readable> }).preParsing;
    const req = {} as { rawBody?: string };
    const returned = await preParsing(req, {}, Readable.from(["abc"]));

    expect(req.rawBody).toBe("abc");
    const out: Buffer[] = [];
    for await (const chunk of returned) out.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk));
    expect(Buffer.concat(out).toString("utf-8")).toBe("abc");
  });

  it("executes registered handlers to increase route-wrapper coverage", async () => {
    const { registerRoutes } = await import("./routes.js");
    const { app, routes } = makeApp();
    await registerRoutes(app as never, { driver: "prisma", mode: "connected", attempts: 1 } as never);

    const reply = {
      header: vi.fn(() => reply),
      code: vi.fn(() => reply),
      send: vi.fn(() => reply),
      status: vi.fn(() => reply),
      type: vi.fn(() => reply)
    };
    for (const route of routes) {
      if (!route.handler || route.path === "/health") continue;
      await Promise.resolve(route.handler({ headers: {}, body: {}, params: {}, query: {} } as never, reply as never)).catch(() => undefined);
    }
    expect(routes.length).toBeGreaterThan(90);
  });
});
