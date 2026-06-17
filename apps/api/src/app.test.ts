import { afterAll, describe, expect, it } from "vitest";

import { createApp } from "./app.js";

// ─── Smoke test: runs WITHOUT a database ────────────────────────────────────
// This test verifies the API can be imported, modules load, and config
// validates correctly. It runs as part of the default test suite to catch
// startup-blocking errors (e.g., duplicate route registration) early.

describe("API startup smoke test", () => {
  it("config exports without error", async () => {
    // Re-importing config validates env defaults and runs validateConfig()
    // This catches misconfiguration before deployment.
    const { config } = await import("./config.js");
    expect(config).toBeDefined();
    expect(config.nodeEnv).toBeDefined();
  });

  it("createApp can be imported without errors", async () => {
    const { createApp } = await import("./app.js");
    expect(typeof createApp).toBe("function");
  });

  it("all controller modules can be imported without errors", async () => {
    // Verify all route controllers load without import errors
    const { AuthController } = await import("./modules/auth/index.js");
    const { BookingController } = await import("./modules/bookings/index.js");
    const { CatalogController } = await import("./modules/catalog/index.js");
    const { PaymentController } = await import("./modules/payments/index.js");
    const { ProController } = await import("./modules/pro/index.js");
    const { AdminController } = await import("./modules/admin/index.js");
    const { SearchController } = await import("./modules/search/index.js");
    const { MediaController } = await import("./modules/media/index.js");
    const { NotificationController } = await import("./modules/notifications/index.js");

    expect(typeof AuthController.prototype.register).toBe("function");
    expect(typeof BookingController.prototype.list).toBe("function");
    expect(typeof CatalogController.prototype.list).toBe("function");
    expect(typeof PaymentController.prototype.initiate).toBe("function");
    expect(typeof ProController.prototype.dashboard).toBe("function");
    expect(typeof AdminController.prototype.dashboard).toBe("function");
    expect(typeof SearchController.prototype.search).toBe("function");
    expect(typeof MediaController.prototype.upload).toBe("function");
    expect(typeof NotificationController.prototype.list).toBe("function");
  });

  it("payout-service module loads without errors", async () => {
    const { checkPayoutEligibility, createPayoutForBooking, submitPayout } = await import("./lib/payout-service.js");
    expect(typeof checkPayoutEligibility).toBe("function");
    expect(typeof createPayoutForBooking).toBe("function");
    expect(typeof submitPayout).toBe("function");
  });

  it("worker module loads without errors", async () => {
    const { handleJob } = await import("./worker.js");
    expect(typeof handleJob).toBe("function");
  });
});

// ─── DB-backed integration tests: require RUN_DB_INTEGRATION=1 ──────────────

const RUN_DB_INTEGRATION = process.env.RUN_DB_INTEGRATION === "1";

describe.runIf(RUN_DB_INTEGRATION)("createApp", () => {
  const appPromise = createApp({
    databaseRuntime: {
      driver: "sqlite",
      mode: "fallback",
      attempts: 3,
      url: null,
      filePath: "/tmp/beauteavenue.test.sqlite",
      reason: "test_runtime"
    }
  });

  const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

  async function authenticateAdmin() {
    const app = await appPromise;
    let lastStatusCode = 500;

    for (let attempt = 1; attempt <= 5; attempt += 1) {
      const response = await app.inject({
        method: "POST",
        url: "/api/v1/auth/login",
        payload: {
          email: "admin@beauteavenue.local",
          password: "admin1234"
        }
      });
      lastStatusCode = response.statusCode;
      if (response.statusCode === 200) {
        return response.json<{ accessToken: string }>().accessToken;
      }
      await sleep(120);
    }

    throw new Error(`authenticateAdmin failed with status ${lastStatusCode}`);
  }

  afterAll(async () => {
    const app = await appPromise;
    await app.close();
  });

  it("returns health status", async () => {
    const app = await appPromise;
    const response = await app.inject({
      method: "GET",
      url: "/health"
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({
      status: "ok",
      database: {
        driver: "sqlite",
        mode: "fallback",
        attempts: 3
      }
    });
  });

  it("protects admin routes", async () => {
    const app = await appPromise;
    const response = await app.inject({
      method: "GET",
      url: "/api/v1/admin/dashboard"
    });

    expect(response.statusCode).toBe(401);
    expect(response.json()).toMatchObject({ code: "missing_auth" });
  });

  it("returns admin dashboard for authenticated admin", async () => {
    const app = await appPromise;
    const token = await authenticateAdmin();
    const response = await app.inject({
      method: "GET",
      url: "/api/v1/admin/dashboard",
      headers: {
        authorization: `Bearer ${token}`
      }
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({
      kpis: expect.any(Array),
      topGrowthSalons: expect.any(Array),
      inactivityAlerts: expect.any(Array)
    });
  });

  it("approves a salon and records the change", async () => {
    const app = await appPromise;
    const token = await authenticateAdmin();
    const salonsResponse = await app.inject({
      method: "GET",
      url: "/api/v1/admin/salons",
      headers: {
        authorization: `Bearer ${token}`
      }
    });
    const salons = salonsResponse.json<{ items: Array<{ id: string }> }>().items;
    expect(salons.length).toBeGreaterThan(0);

    const response = await app.inject({
      method: "POST",
      url: `/api/v1/admin/salons/${salons[0].id}/approve`,
      headers: {
        authorization: `Bearer ${token}`
      }
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({
      id: salons[0].id,
      approvalStatus: "approved"
    });
  });

  it("supports complimentary premium grant without provider payment", async () => {
    const app = await appPromise;
    const token = await authenticateAdmin();
    const subscriptionsResponse = await app.inject({
      method: "GET",
      url: "/api/v1/admin/subscriptions",
      headers: {
        authorization: `Bearer ${token}`
      }
    });
    const subscriptions = subscriptionsResponse.json<{ items: Array<{ id: string }> }>().items;
    expect(subscriptions.length).toBeGreaterThan(0);

    const response = await app.inject({
      method: "POST",
      url: `/api/v1/admin/subscriptions/${subscriptions[0].id}/override`,
      headers: {
        authorization: `Bearer ${token}`
      },
      payload: {
        action: "grant_complimentary_premium",
        reason: "Partenariat lancement",
        expiresAt: "2026-08-01T00:00:00.000Z"
      }
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({
      id: subscriptions[0].id,
      tier: "premium",
      isComplimentary: true
    });
  });

  it("returns subscription detail and audit detail routes", async () => {
    const app = await appPromise;
    const token = await authenticateAdmin();
    const subscriptionsResponse = await app.inject({
      method: "GET",
      url: "/api/v1/admin/subscriptions",
      headers: {
        authorization: `Bearer ${token}`
      }
    });
    const subscriptions = subscriptionsResponse.json<{ items: Array<{ id: string }> }>().items;
    expect(subscriptions.length).toBeGreaterThan(0);

    const subscriptionResponse = await app.inject({
      method: "GET",
      url: `/api/v1/admin/subscriptions/${subscriptions[0].id}`,
      headers: {
        authorization: `Bearer ${token}`
      }
    });
    const auditListResponse = await app.inject({
      method: "GET",
      url: "/api/v1/admin/audit",
      headers: {
        authorization: `Bearer ${token}`
      }
    });

    expect(subscriptionResponse.statusCode).toBe(200);
    expect(subscriptionResponse.json()).toMatchObject({
      id: subscriptions[0].id,
      events: expect.any(Array),
      invoices: expect.any(Array)
    });

    const auditItems = auditListResponse.json<{ items: Array<{ id: string }> }>().items;
    expect(auditItems.length).toBeGreaterThan(0);

    const auditDetailResponse = await app.inject({
      method: "GET",
      url: `/api/v1/admin/audit/${auditItems[0].id}`,
      headers: {
        authorization: `Bearer ${token}`
      }
    });

    expect(auditDetailResponse.statusCode).toBe(200);
    expect(auditDetailResponse.json()).toMatchObject({
      id: auditItems[0].id,
      payloadJson: expect.any(String)
    });
  });

  it("registers a client and returns a session", async () => {
    const app = await appPromise;
    const response = await app.inject({
      method: "POST",
      url: "/api/v1/auth/register",
      payload: {
        type: "client",
        fullName: "Test Client",
        email: `test-${Date.now()}@example.sn`,
        password: "securepass123"
      }
    });

    expect(response.statusCode).toBe(201);
    expect(response.json()).toMatchObject({
      accessToken: expect.any(String),
      refreshToken: expect.any(String),
      expiresInSeconds: expect.any(Number)
    });
  });

  it("rejects duplicate registration", async () => {
    const app = await appPromise;
    const email = `dup-${Date.now()}@example.sn`;
    await app.inject({
      method: "POST",
      url: "/api/v1/auth/register",
      payload: { type: "client", fullName: "User A", email, password: "securepass123" }
    });
    const response = await app.inject({
      method: "POST",
      url: "/api/v1/auth/register",
      payload: { type: "client", fullName: "User B", email, password: "securepass123" }
    });

    expect(response.statusCode).toBe(409);
    expect(response.json()).toMatchObject({ code: "already_exists" });
  });

  it("rejects login with wrong password", async () => {
    const app = await appPromise;
    const response = await app.inject({
      method: "POST",
      url: "/api/v1/auth/login",
      payload: { email: "admin@beauteavenue.local", password: "wrongpassword" }
    });

    expect(response.statusCode).toBe(401);
    expect(response.json()).toMatchObject({ code: "invalid_credentials" });
  });

  it("pro routes reject non-pro tokens", async () => {
    const app = await appPromise;
    const token = await authenticateAdmin();
    const response = await app.inject({
      method: "GET",
      url: "/api/v1/pro/dashboard",
      headers: { authorization: `Bearer ${token}` }
    });

    expect(response.statusCode).toBe(403);
  });

  it("availability returns empty array for unknown salon", async () => {
    const app = await appPromise;
    const response = await app.inject({
      method: "GET",
      url: "/api/v1/salons/nonexistent-salon/availability?date=2026-05-01&serviceId=x"
    });

    expect(response.statusCode).toBe(404);
    expect(response.json()).toMatchObject({ code: "salon_not_found" });
  });
});
