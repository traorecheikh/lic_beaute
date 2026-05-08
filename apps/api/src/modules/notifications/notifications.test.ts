import { afterAll, describe, expect, it } from "vitest";

import { createApp } from "../../app.js";

const RUN_DB_INTEGRATION = process.env.RUN_DB_INTEGRATION === "1";

describe.runIf(RUN_DB_INTEGRATION)("notifications & reminders", () => {
  const appPromise = createApp({
    databaseRuntime: {
      driver: "sqlite",
      mode: "fallback",
      attempts: 3,
      url: null,
      filePath: "/tmp/beauteavenue.test.notifications.sqlite",
      reason: "test_runtime"
    }
  });

  const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

  afterAll(async () => {
    const app = await appPromise;
    await app.close();
  });

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

  it("push token validation rejects invalid platform", async () => {
    const app = await appPromise;
    const token = await authenticateAdmin();
    const response = await app.inject({
      method: "POST",
      url: "/api/v1/push-tokens",
      headers: { authorization: `Bearer ${token}` },
      payload: { token: "test-token", platform: "web", deviceId: "device-1" }
    });
    expect(response.statusCode).toBe(400);
  });

  it("push token validation rejects missing deviceId", async () => {
    const app = await appPromise;
    const token = await authenticateAdmin();
    const response = await app.inject({
      method: "POST",
      url: "/api/v1/push-tokens",
      headers: { authorization: `Bearer ${token}` },
      payload: { token: "test-token", platform: "ios" }
    });
    expect(response.statusCode).toBe(400);
  });

  it("push token registration accepts valid payload", async () => {
    const app = await appPromise;
    const token = await authenticateAdmin();
    const response = await app.inject({
      method: "POST",
      url: "/api/v1/push-tokens",
      headers: { authorization: `Bearer ${token}` },
      payload: { token: "valid-token-abc", platform: "ios", deviceId: "device-xyz" }
    });
    expect(response.statusCode).toBe(201);
    expect(response.json()).toMatchObject({ registered: true });
  });

  it("push token upsert reuses same token for same user", async () => {
    const app = await appPromise;
    const token = await authenticateAdmin();
    const payload = { token: "reuse-token-123", platform: "ios" as const, deviceId: "device-z" };
    await app.inject({
      method: "POST",
      url: "/api/v1/push-tokens",
      headers: { authorization: `Bearer ${token}` },
      payload
    });
    const response = await app.inject({
      method: "POST",
      url: "/api/v1/push-tokens",
      headers: { authorization: `Bearer ${token}` },
      payload
    });
    expect(response.statusCode).toBe(201);
    expect(response.json()).toMatchObject({ registered: true });
  });

  it("push token rejects reassignment to different user", async () => {
    const app = await appPromise;
    const adminToken = await authenticateAdmin();
    const payload = { token: "hijack-token-789", platform: "ios" as const, deviceId: "device-h" };

    const registerResponse = await app.inject({
      method: "POST",
      url: "/api/v1/push-tokens",
      headers: { authorization: `Bearer ${adminToken}` },
      payload
    });
    expect(registerResponse.statusCode).toBe(201);

    // Register a separate client user
    const clientId = `tokentest-${Date.now()}`;
    const regResponse = await app.inject({
      method: "POST",
      url: "/api/v1/auth/register",
      payload: {
        fullName: "Token Test Client",
        email: `${clientId}@beauteavenue.local`,
        password: "securepass123",
        type: "client"
      }
    });
    expect(regResponse.statusCode).toBe(201);
    const clientAuth = regResponse.json<{ accessToken: string }>();
    const clientToken = clientAuth.accessToken;

    const hijackResponse = await app.inject({
      method: "POST",
      url: "/api/v1/push-tokens",
      headers: { authorization: `Bearer ${clientToken}` },
      payload
    });
    expect(hijackResponse.statusCode).toBe(409);
    expect(hijackResponse.json()).toMatchObject({ code: "token_owned" });
  });
});
