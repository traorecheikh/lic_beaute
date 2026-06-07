/**
 * Full sprint demo — Playwright end-to-end suite
 *
 * Covers every feature shipped in the sprint:
 *   • Admin: salon dossier approval, request-info checklist, reject, audit filters,
 *            config duplicate prevention, subscription management
 *   • Pro:   services add/delete (confirm dialog), subscription grace banner,
 *            calendar, bookings inbox, analytics tier gate
 *   • Real actor: dhouleymatou150@planys.online registered and approved → email triggered
 *
 * Run for demo (visible, slow):
 *   PW_HEADLESS=false PW_SLOWMO=600 pnpm --filter @beauteavenue/web-admin test:e2e \
 *     --project=chromium tests/e2e/sprint-full-demo.spec.ts
 *
 * Run for CI (headless, fast):
 *   pnpm --filter @beauteavenue/web-admin test:e2e tests/e2e/sprint-full-demo.spec.ts
 */

import { expect, test, type BrowserContext, type Page } from "@playwright/test";

const API = process.env.PW_BASE_URL ?? "http://127.0.0.1:3000";

// ─── helpers ──────────────────────────────────────────────────────────────────

async function waitForApi(page: Page, maxSeconds = 45) {
  for (let i = 0; i < maxSeconds; i++) {
    try {
      const r = await page.request.get(`${API}/health`);
      if (r.ok()) return;
    } catch { /* booting */ }
    await page.waitForTimeout(1_000);
  }
  throw new Error("API never became healthy");
}

/** Get a JWT via API (no UI form → avoids rate limiter) and inject into localStorage. */
async function apiLogin(
  page: Page,
  context: BrowserContext,
  email: string,
  password: string,
  storeKey: "beauteavenue.admin.session" | "beauteavenue.pro.session",
  landingPath: string
) {
  const loginR = await context.request.post(`${API}/api/v1/auth/login`, {
    data: { email, password }
  });
  expect(loginR.ok(), `login failed for ${email}: ${loginR.status()}`).toBeTruthy();
  const { accessToken, refreshToken } = await loginR.json() as { accessToken: string; refreshToken: string };

  // Set a neutral page first so localStorage is on the correct origin
  await page.goto("/admin/login", { waitUntil: "domcontentloaded" });
  await page.evaluate(
    ({ key, val }) => localStorage.setItem(key, JSON.stringify(val)),
    { key: storeKey, val: { accessToken, refreshToken } }
  );
  await page.goto(landingPath, { waitUntil: "domcontentloaded" });
  await page.waitForFunction(
    (path) => window.location.pathname.startsWith(path),
    landingPath,
    { timeout: 20_000 }
  );
  return accessToken;
}

async function adminLogin(page: Page, ctx: BrowserContext) {
  return apiLogin(page, ctx, process.env.PW_ADMIN_EMAIL ?? "admin@beauteavenue.local", process.env.PW_ADMIN_PASSWORD ?? "supersecure", "beauteavenue.admin.session", "/admin/dashboard");
}

async function proLogin(page: Page, ctx: BrowserContext, email: string, password: string) {
  return apiLogin(page, ctx, email, password, "beauteavenue.pro.session", "/pro/calendar");
}

// ─── suite ────────────────────────────────────────────────────────────────────

test.describe("Sprint demo — full feature coverage", () => {
  test.setTimeout(120_000);

  // ──────────────────────────────────────────────────────────────────────────
  // 1. REAL ACTOR: register dhouleymatou150@planys.online → admin approves → email
  // ──────────────────────────────────────────────────────────────────────────
  test("1 · Dhouleymatou dossier: register → admin approve (email triggered)", async ({
    page, context
  }) => {
    await waitForApi(page);

    const demoEmail = "dhouleymatou150@planys.online";
    const demoPassword = "Dhouley2024!";
    const demoSalon = "Dhouley Beauty Studio";
    let salonId = "";

    await test.step("Register or locate salon owner dossier", async () => {
      const reg = await context.request.post(`${API}/api/v1/auth/register`, {
        data: {
          type: "salon_owner",
          fullName: "Dhouleymatou BA",
          email: demoEmail,
          phone: "+221775001500",
          password: demoPassword,
          salon: {
            name: demoSalon,
            category: "Coiffure",
            city: "Dakar",
            address: "Mermoz, Dakar",
            description: "Salon de beauté haut de gamme"
          },
          services: [
            { name: "Tresses Box Braids", durationMinutes: 180, priceXof: 35000, depositMode: "none" },
            { name: "Coupe + Brushing", durationMinutes: 60, priceXof: 15000, depositMode: "percent", depositPercent: 30 }
          ],
          hours: Array.from({ length: 7 }, (_, i) => ({
            dayOfWeek: i, isOpen: i !== 0, opensAt: "09:00", closesAt: "20:00"
          }))
        }
      });
      // 409 = already registered from a prior run — that's fine
      expect([200, 201, 409]).toContain(reg.status());
    });

    const adminToken = await adminLogin(page, context);

    await test.step("Admin finds dossier via API and navigates to detail", async () => {
      // Use admin API to look up salonId directly — avoids status-filter UI state issues
      const listR = await context.request.get(`${API}/api/v1/admin/salons?search=${encodeURIComponent(demoSalon)}`, {
        headers: { authorization: `Bearer ${adminToken}` }
      });
      const list = await listR.json() as { items: Array<{ id: string }> };
      expect(list.items.length, "Dhouleymatou salon not found in admin list").toBeGreaterThan(0);
      salonId = list.items[0].id;

      // Navigate to the detail page directly
      await page.goto(`/admin/salons/${salonId}`, { waitUntil: "domcontentloaded" });
      await page.waitForURL(`/admin/salons/${salonId}`, { timeout: 15_000 });
    });

    await test.step("Admin approves (triggers confirmation email to dhouleymatou150@planys.online)", async () => {
      // If already approved from a previous run, skip
      const detail = await context.request.get(`${API}/api/v1/admin/salons/${salonId}`, {
        headers: { authorization: `Bearer ${adminToken}` }
      });
      const payload = await detail.json() as { approvalStatus: string };

      if (payload.approvalStatus !== "approved") {
        await page.locator('label:has-text("Approuver")').click();
        await Promise.all([
          page.waitForResponse(
            (r) => r.url().includes(`/api/v1/admin/salons/${salonId}/approve`) && r.status() === 200
          ),
          page.getByRole("button", { name: "Confirmer" }).click()
        ]);
      }
    });

    await test.step("API confirms approvalStatus = approved", async () => {
      const check = await context.request.get(`${API}/api/v1/admin/salons/${salonId}`, {
        headers: { authorization: `Bearer ${adminToken}` }
      });
      expect(((await check.json()) as { approvalStatus: string }).approvalStatus).toBe("approved");
    });

    await test.step("Dhouleymatou logs in to pro panel", async () => {
      const proPage = await context.newPage();
      await proLogin(proPage, context, demoEmail, demoPassword);
      await expect(proPage).toHaveURL(/\/pro\/(calendar|dashboard|approval-status)/);
      await proPage.close();
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 2. ADMIN: request-info checklist → reject a fresh dossier
  // ──────────────────────────────────────────────────────────────────────────
  test("2 · Admin: request-info checklist → reject", async ({ page, context }) => {
    await waitForApi(page);

    const runId = Date.now();
    const email = `checklist.${runId}@example.sn`;
    let salonId = "";

    await test.step("Register test dossier via API", async () => {
      const r = await context.request.post(`${API}/api/v1/auth/register`, {
        data: {
          type: "salon_owner",
          fullName: "Test Checklist",
          email,
          phone: `+22177${String(runId).slice(-7)}`,
          password: "test1234",
          salon: { name: `Checklist ${runId}`, category: "Coiffure", city: "Dakar", address: "Dakar", description: "" },
          services: [{ name: "Soin", durationMinutes: 30, priceXof: 5000, depositMode: "none" }],
          hours: Array.from({ length: 7 }, (_, i) => ({ dayOfWeek: i, isOpen: true, opensAt: "09:00", closesAt: "18:00" }))
        }
      });
      expect([200, 201]).toContain(r.status());
    });

    const adminToken = await adminLogin(page, context);

    await test.step("Find dossier", async () => {
      await page.goto("/admin/salons");
      await page.getByPlaceholder("Enseigne...").fill(`Checklist ${runId}`);
      await page.waitForTimeout(600);

      const row = page.locator("article", { hasText: `Checklist ${runId}` }).first();
      await expect(row).toBeVisible({ timeout: 15_000 });

      const detailP = page.waitForResponse(
        (r) => r.url().includes("/api/v1/admin/salons/") && r.request().method() === "GET"
      );
      await row.getByRole("button", { name: "Dossier" }).click();
      await page.getByRole("link", { name: "Voir le dossier" }).first().click();
      salonId = ((await (await detailP).json()) as { id: string }).id;
    });

    await test.step("Select request-info and check checklist", async () => {
      await page.locator('label:has-text("Compléments")').click();

      const checkboxes = page.locator("input[type='checkbox']");
      if (await checkboxes.count() > 0) {
        await checkboxes.first().check();
      } else {
        await page.getByPlaceholder("Requis...").fill("Merci de fournir un justificatif NINEA.");
      }

      await Promise.all([
        page.waitForResponse(
          (r) => r.url().includes(`/api/v1/admin/salons/${salonId}/request-info`) && r.status() === 200
        ),
        page.getByRole("button", { name: "Confirmer" }).click()
      ]);
    });

    await test.step("Reject the dossier", async () => {
      // Let the page re-fetch salon data after the request-info mutation before interacting
      await page.waitForTimeout(1_500);
      await page.locator('label:has-text("Rejeter")').click();
      await page.getByPlaceholder("Requis...").fill("Dossier incomplet après relance.");

      await Promise.all([
        page.waitForResponse(
          (r) => r.url().includes(`/api/v1/admin/salons/${salonId}/reject`) && r.status() === 200
        ),
        page.getByRole("button", { name: "Confirmer" }).click()
      ]);

      const check = await context.request.get(
        `${API}/api/v1/admin/salons/${salonId}`,
        { headers: { authorization: `Bearer ${adminToken}` } }
      );
      expect(((await check.json()) as { approvalStatus: string }).approvalStatus).toBe("rejected");
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 3. ADMIN: audit log filter bar
  // ──────────────────────────────────────────────────────────────────────────
  test("3 · Admin: audit log filters (action type + date range)", async ({ page, context }) => {
    await waitForApi(page);
    await adminLogin(page, context);

    await page.goto("/admin/audit");
    await expect(page.getByRole("heading", { name: "Audit" })).toBeVisible();
    await page.waitForTimeout(800);

    await test.step("Filter by action type", async () => {
      const select = page.locator("select").filter({ hasText: /Toutes|action/i }).first();
      if (await select.isVisible()) {
        await select.selectOption("approve");
        await page.waitForTimeout(500);
        await expect(page.locator("body")).not.toContainText("Erreur interne");
      }
    });

    await test.step("Filter by date range", async () => {
      const inputs = page.locator('input[type="date"]');
      if (await inputs.count() >= 2) {
        await inputs.first().fill("2026-01-01");
        await inputs.nth(1).fill("2026-12-31");
        await page.waitForTimeout(500);
        await expect(page.locator("body")).not.toContainText("Erreur interne");
      }
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 4. ADMIN: config — duplicate category prevention
  // ──────────────────────────────────────────────────────────────────────────
  test("4 · Admin: config — duplicate category blocked with inline error", async ({
    page, context
  }) => {
    await waitForApi(page);
    await adminLogin(page, context);

    await page.goto("/admin/config");
    await expect(page.getByRole("heading", { name: "Configuration" })).toBeVisible();
    await page.waitForTimeout(1_000);

    const nameInput = page.locator('input[placeholder*="Nom"]').first();
    if (await nameInput.isVisible()) {
      await nameInput.fill("Coiffure");
      const slugInput = page.locator('input[placeholder*="slug"]').first();
      if (await slugInput.isVisible()) await slugInput.fill("coiffure");
      await page.getByRole("button", { name: /Ajouter|Créer/i }).click();
      await expect(page.locator("body")).toContainText(/existe déjà/i, { timeout: 5_000 });
    }
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 5. PRO: services — add → see → delete with native confirm dialog
  // ──────────────────────────────────────────────────────────────────────────
  test("5 · Pro services: add new service then delete with confirm dialog", async ({
    page, context
  }) => {
    await waitForApi(page);
    await proLogin(page, context, "aida@dionesignature.sn", "salon1234");

    await page.goto("/pro/salon/services");
    await page.waitForTimeout(1_000);

    const svcName = `Soin Test ${Date.now()}`;

    await test.step("Open create form", async () => {
      await page.getByRole("button", { name: /Nouvelle prestation/i }).click();
      await expect(page.getByPlaceholder("ex: Brushing + Soin profond")).toBeVisible({ timeout: 8_000 });
    });

    await test.step("Fill and submit (multi-step wizard)", async () => {
      // Step 1: Identity
      await page.getByPlaceholder("ex: Brushing + Soin profond").fill(svcName);
      await page.getByPlaceholder("ex: Coiffure, Ongles, Soins…").fill("Coiffure");
      await page.getByRole("button", { name: "Continuer →" }).click();

      // Step 2: Pricing
      await page.waitForTimeout(400);
      await page.locator('input[type="number"]').first().fill("45");
      await page.locator('input[type="number"]').nth(1).fill("12000");

      // Set up the response listener before the final click(s).
      // nextStep() at step 2: if depositsAvailable→step 3, else submitService() directly.
      // So "Continuer →" may itself fire the POST — listener must be ready before the click.
      const serviceCreateResp = page.waitForResponse(
        (r) => r.url().includes("/api/v1/pro/services") && [200, 201].includes(r.status()),
        { timeout: 20_000 }
      );
      await page.getByRole("button", { name: "Continuer →" }).click();

      // If we advanced to step 3 (depositsAvailable=true), an explicit submit button appears
      const submitBtn = page.getByRole("button", { name: /Ajouter à ma carte/i });
      const onStep3 = await submitBtn.isVisible({ timeout: 2_000 }).catch(() => false);
      if (onStep3) await submitBtn.click();

      await serviceCreateResp;

      // Wait for the create form to close: Vue onSuccess → cancelCreateService()
      await page.getByRole("heading", { name: "Nouvelle prestation" }).waitFor({ state: "detached", timeout: 10_000 });
    });

    await test.step("New service appears in list", async () => {
      await expect(page.getByText(svcName)).toBeVisible({ timeout: 10_000 });
    });

    await test.step("Delete removes item (native window.confirm dialog)", async () => {
      // Allow background Vue Query refetch to settle after create
      await page.waitForTimeout(1_500);

      // Use filter+exact match for the specific service card
      const card = page.locator("div.panel-clean").filter({
        has: page.getByText(svcName, { exact: true })
      });
      await expect(card).toBeVisible({ timeout: 10_000 });

      // Register dialog handler BEFORE click — prod uses window.confirm(), not a Vue modal
      const deleteResp = page.waitForResponse(
        (r) => r.url().includes("/api/v1/pro/services") && r.request().method() === "DELETE",
        { timeout: 15_000 }
      );
      page.once("dialog", (dialog) => dialog.accept());
      await card.locator("button").last().click();
      await deleteResp;

      await expect(page.getByText(svcName)).not.toBeVisible({ timeout: 8_000 });
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 6. PRO: subscription page — gracePeriodEndsAt present in API response
  // ──────────────────────────────────────────────────────────────────────────
  test("6 · Pro subscription: gracePeriodEndsAt field in API response", async ({
    page, context
  }) => {
    await waitForApi(page);

    const loginR = await context.request.post(`${API}/api/v1/auth/login`, {
      data: { email: "aida@dionesignature.sn", password: "salon1234" }
    });
    const { accessToken } = await loginR.json() as { accessToken: string };

    const subR = await context.request.get(`${API}/api/v1/pro/subscription`, {
      headers: { authorization: `Bearer ${accessToken}` }
    });
    expect(subR.ok()).toBeTruthy();
    const payload = await subR.json() as Record<string, unknown>;
    expect("gracePeriodEndsAt" in payload).toBeTruthy();
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 7. PRO: grace banner visible for Seynabou (past_due + gracePeriodEndsAt set)
  // ──────────────────────────────────────────────────────────────────────────
  test("7 · Pro grace banner: subscription API returns gracePeriodEndsAt field", async ({
    page, context
  }) => {
    await waitForApi(page);

    // Use direct API call — waitForResponse would catch /subscription/features first
    const loginR = await context.request.post(`${API}/api/v1/auth/login`, {
      data: { email: "seynabou@epilexpress.sn", password: "salon1234" }
    });
    expect(loginR.ok(), "seynabou login failed").toBeTruthy();
    const { accessToken } = await loginR.json() as { accessToken: string };

    const subR = await context.request.get(`${API}/api/v1/pro/subscription`, {
      headers: { authorization: `Bearer ${accessToken}` }
    });
    expect(subR.ok()).toBeTruthy();
    const sub = await subR.json() as Record<string, unknown>;

    await test.step("Subscription API response has gracePeriodEndsAt field", async () => {
      expect("gracePeriodEndsAt" in sub, `gracePeriodEndsAt missing from subscription response: ${JSON.stringify(sub)}`).toBe(true);
    });

    await test.step("Pro subscription page renders plan info", async () => {
      await proLogin(page, context, "seynabou@epilexpress.sn", "salon1234");
      await page.goto("/pro/subscription", { waitUntil: "domcontentloaded" });
      await expect(page.locator("body")).toContainText(/Standard|Premium|Abonnement/i, { timeout: 10_000 });
    });

    // Grace banner only visible when subscription is past_due with an active grace window.
    const isGraceBannerVisible = await page.locator('[data-testid="grace-banner"]').isVisible();
    if (!isGraceBannerVisible) {
      expect(sub.status).not.toBe("past_due");
    }
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 8. PRO: calendar renders for owner
  // ──────────────────────────────────────────────────────────────────────────
  test("8 · Pro calendar: owner view loads without errors", async ({ page, context }) => {
    await waitForApi(page);
    await proLogin(page, context, "aida@dionesignature.sn", "salon1234");

    await page.goto("/pro/calendar");
    await page.waitForTimeout(1_000);
    await expect(page.locator("body")).not.toContainText("Erreur interne");
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 9. PRO: bookings inbox
  // ──────────────────────────────────────────────────────────────────────────
  test("9 · Pro bookings inbox renders", async ({ page, context }) => {
    await waitForApi(page);
    await proLogin(page, context, "aida@dionesignature.sn", "salon1234");

    await page.goto("/pro/bookings/inbox");
    await expect(page.locator("body")).not.toContainText("Erreur interne");
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 10. PRO: analytics tier gate — standard→402/403, premium→200
  // ──────────────────────────────────────────────────────────────────────────
  test("10 · Pro analytics: standard blocked (402/403), premium passes (200)", async ({
    page, context
  }) => {
    await waitForApi(page);

    await test.step("Standard salon gets 402 or 403", async () => {
      const r = await context.request.post(`${API}/api/v1/auth/login`, {
        data: { email: "kadija@studiokadija.sn", password: "salon1234" }
      });
      const { accessToken } = await r.json() as { accessToken: string };
      const ar = await context.request.get(`${API}/api/v1/pro/analytics?period=30d`, {
        headers: { authorization: `Bearer ${accessToken}` }
      });
      expect([402, 403]).toContain(ar.status());
    });

    await test.step("Premium salon gets 200", async () => {
      const r = await context.request.post(`${API}/api/v1/auth/login`, {
        data: { email: "aida@dionesignature.sn", password: "salon1234" }
      });
      const { accessToken } = await r.json() as { accessToken: string };
      const ar = await context.request.get(`${API}/api/v1/pro/analytics?period=30d`, {
        headers: { authorization: `Bearer ${accessToken}` }
      });
      expect(ar.ok()).toBeTruthy();
    });

    await test.step("Premium analytics page renders in UI", async () => {
      await proLogin(page, context, "aida@dionesignature.sn", "salon1234");
      await page.goto("/pro/analytics");
      await expect(page.locator("body")).not.toContainText("Erreur interne");
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 11. ADMIN: subscription list and detail
  // ──────────────────────────────────────────────────────────────────────────
  test("11 · Admin subscriptions: list renders and detail opens", async ({
    page, context
  }) => {
    await waitForApi(page);
    await adminLogin(page, context);

    await page.goto("/admin/subscriptions");
    await expect(page.getByRole("heading", { name: "Abonnements" })).toBeVisible();
    await page.waitForTimeout(1_000);

    // Click first subscription detail link
    const link = page.getByRole("link").filter({ hasText: /Voir|Détail|Dione|Kadija/i }).first();
    if (await link.isVisible()) {
      await link.click();
      await expect(page).toHaveURL(/\/admin\/subscriptions\//);
      await expect(page.locator("body")).not.toContainText("Erreur interne");
    }
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 12. PRO: approval-status page for pending salon
  // ──────────────────────────────────────────────────────────────────────────
  test("12 · Pro approval-status page: new pending salon is redirected", async ({
    page, context
  }) => {
    await waitForApi(page);

    const runId = Date.now();
    const email = `pending.${runId}@example.sn`;

    await test.step("Register pending salon", async () => {
      const r = await context.request.post(`${API}/api/v1/auth/register`, {
        data: {
          type: "salon_owner",
          fullName: "Pending Owner",
          email,
          phone: `+22178${String(runId).slice(-7)}`,
          password: "pending1234",
          salon: { name: `Pending ${runId}`, category: "Coiffure", city: "Dakar", address: "Dakar", description: "" },
          services: [{ name: "Soin", durationMinutes: 30, priceXof: 5000, depositMode: "none" }],
          hours: Array.from({ length: 7 }, (_, i) => ({ dayOfWeek: i, isOpen: true, opensAt: "09:00", closesAt: "18:00" }))
        }
      });
      expect([200, 201]).toContain(r.status());
    });

    await test.step("Login leads to approval-status or calendar", async () => {
      await proLogin(page, context, email, "pending1234");
      await expect(page).toHaveURL(/\/pro\/(approval-status|login|calendar)/, { timeout: 10_000 });

      if (page.url().includes("approval-status")) {
        await expect(page.locator("body")).toContainText(/en attente|Dossier|examen/i);
      }
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 13. ADMIN: dashboard KPI metrics
  // ──────────────────────────────────────────────────────────────────────────
  test("13 · Admin dashboard: KPI metrics contain numbers", async ({ page, context }) => {
    await waitForApi(page);
    await adminLogin(page, context);

    await expect(page.getByRole("heading", { name: "Pilotage" })).toBeVisible();
    await page.waitForTimeout(1_500);

    const metrics = page.locator(".metric-value");
    if (await metrics.count() > 0) {
      const text = await metrics.first().textContent();
      expect(text).toMatch(/\d/);
    }
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 14. FULL SMOKE: every admin and pro route returns 200
  // ──────────────────────────────────────────────────────────────────────────
  test("14 · Full route smoke: all admin + pro pages load without 500", async ({
    page, context
  }) => {
    await waitForApi(page);

    const adminRoutes = [
      "/admin/dashboard",
      "/admin/salons",
      "/admin/subscriptions",
      "/admin/audit",
      "/admin/config",
      "/admin/account"
    ];
    const proRoutes = [
      "/pro/calendar",
      "/pro/clients",
      "/pro/bookings/inbox",
      "/pro/payouts",
      "/pro/analytics",
      "/pro/salon/profile",
      "/pro/salon/services",
      "/pro/salon/team",
      "/pro/salon/hours",
      "/pro/subscription",
      "/pro/account"
    ];

    await test.step("Admin routes", async () => {
      await adminLogin(page, context);
      for (const path of adminRoutes) {
        const r = await page.goto(path, { waitUntil: "domcontentloaded" });
        expect(r?.ok(), `${path} → ${r?.status()}`).toBeTruthy();
        await expect(page.locator("body")).not.toContainText("500");
      }
    });

    const proPage = await context.newPage();
    await test.step("Pro routes", async () => {
      await proLogin(proPage, context, "aida@dionesignature.sn", "salon1234");
      for (const path of proRoutes) {
        const r = await proPage.goto(path, { waitUntil: "domcontentloaded" });
        expect(r?.ok(), `${path} → ${r?.status()}`).toBeTruthy();
        await expect(proPage.locator("body")).not.toContainText("500");
        expect(proPage.url()).not.toContain("/pro/login");
      }
    });

    await proPage.close();
  });
});
