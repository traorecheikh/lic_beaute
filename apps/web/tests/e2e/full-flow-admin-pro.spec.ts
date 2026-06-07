import { expect, test } from "@playwright/test";

const API_BASE_URL = (process.env.PW_API_BASE_URL ?? process.env.PW_BASE_URL ?? "http://127.0.0.1:3000").replace(/\/$/, "");

async function waitForApi(page: import("@playwright/test").Page, maxSeconds = 30) {
  for (let i = 0; i < maxSeconds; i += 1) {
    try {
      const health = await page.request.get(`${API_BASE_URL}/health`);
      if (health.ok()) return;
    } catch {
      // API may still be booting during Playwright webServer startup.
    }
    await page.waitForTimeout(1_000);
  }
}

test.describe("Admin + Pro full business flow", () => {
  test("register pro dossier, login pro, review dossier in admin", async ({ page, context }) => {
    await waitForApi(page);

    const runId = Date.now();
    const proEmail = `pro.flow.${runId}@example.sn`;
    const proPhone = `+22178${String(runId).slice(-7)}`;
    const proPassword = "flowpass1234";
    const salonName = `Flow Salon ${runId}`;

    await test.step("Register pro owner dossier through live API contract", async () => {
      const registerResponse = await context.request.post(`${API_BASE_URL}/api/v1/auth/register`, {
        data: {
          type: "salon_owner",
          fullName: "Flow Owner",
          email: proEmail,
          phone: proPhone,
          password: proPassword,
          salon: {
            name: salonName,
            category: "Coiffure",
            city: "Dakar",
            address: "Mermoz, Dakar",
            description: ""
          },
          services: [
            {
              name: "Brushing Flow",
              durationMinutes: 45,
              priceXof: 12000,
              depositMode: "none"
            }
          ],
          hours: [
            { dayOfWeek: 1, isOpen: true, opensAt: "09:00", closesAt: "19:00" },
            { dayOfWeek: 2, isOpen: true, opensAt: "09:00", closesAt: "19:00" },
            { dayOfWeek: 3, isOpen: true, opensAt: "09:00", closesAt: "19:00" },
            { dayOfWeek: 4, isOpen: true, opensAt: "09:00", closesAt: "19:00" },
            { dayOfWeek: 5, isOpen: true, opensAt: "09:00", closesAt: "19:00" },
            { dayOfWeek: 6, isOpen: true, opensAt: "09:00", closesAt: "19:00" },
            { dayOfWeek: 0, isOpen: true, opensAt: "09:00", closesAt: "19:00" }
          ]
        }
      });
      expect(registerResponse.ok()).toBeTruthy();

    });

    await test.step("Pro owner can login", async () => {
      await page.goto("/pro/login");
      await page.locator("#email").fill(proEmail);
      await page.locator("#password").fill(proPassword);
      await Promise.all([
        page.waitForURL(/\/pro\/(calendar|dashboard)/),
        page.getByRole("button", { name: "Se connecter" }).click()
      ]);
      await expect(page).toHaveURL(/\/pro\/(calendar|dashboard)/);
    });

    const adminPage = await context.newPage();
    let adminToken = "";
    let dossierId = "";

    await test.step("Admin login and open the newly submitted dossier", async () => {
      await adminPage.goto("/admin/login");
      await adminPage.getByPlaceholder("nom@beauteavenue.com").fill(process.env.PW_ADMIN_EMAIL ?? "admin@beauteavenue.local");
      await adminPage.getByPlaceholder("••••••••").fill(process.env.PW_ADMIN_PASSWORD ?? "supersecure");

      const loginResponsePromise = adminPage.waitForResponse((response) =>
        response.url().includes("/api/v1/auth/login") && response.request().method() === "POST"
      );

      await Promise.all([
        adminPage.waitForURL(/\/admin\/dashboard/),
        adminPage.getByRole("button", { name: "Ouvrir la session" }).click()
      ]);

      const loginResponse = await loginResponsePromise;
      const loginBody = (await loginResponse.json()) as { accessToken: string };
      adminToken = loginBody.accessToken;

      await adminPage.goto("/admin/salons");
      await adminPage.getByPlaceholder("Enseigne...").fill(salonName);

      const dossierRow = adminPage.locator("article", { hasText: salonName }).first();
      await expect(dossierRow).toBeVisible({ timeout: 20_000 });

      const detailResponsePromise = adminPage.waitForResponse((response) =>
        response.url().includes("/api/v1/admin/salons/") && response.request().method() === "GET"
      );

      await dossierRow.getByRole("button", { name: "Dossier" }).click();
      await adminPage.getByRole("link", { name: "Voir le dossier" }).first().click();
      await expect(adminPage).toHaveURL(/\/admin\/salons\//);

      const detailResponse = await detailResponsePromise;
      const detailBody = (await detailResponse.json()) as { id: string };
      dossierId = detailBody.id;
      expect(dossierId.length).toBeGreaterThan(5);
    });

    await test.step("Admin requests more info then rejects dossier", async () => {
      await adminPage.locator('label:has-text("Compléments")').click();
      await adminPage.getByPlaceholder("Requis...").fill("Merci d'ajouter un justificatif fiscal.");

      await Promise.all([
        adminPage.waitForResponse((response) =>
          response.url().includes(`/api/v1/admin/salons/${dossierId}/request-info`) && response.status() === 200
        ),
        adminPage.getByRole("button", { name: "Confirmer" }).click()
      ]);

      await adminPage.locator('label:has-text("Rejeter")').click();
      await adminPage.getByPlaceholder("Requis...").fill("Dossier incomplet après relance.");

      await Promise.all([
        adminPage.waitForResponse((response) =>
          response.url().includes(`/api/v1/admin/salons/${dossierId}/reject`) && response.status() === 200
        ),
        adminPage.getByRole("button", { name: "Confirmer" }).click()
      ]);
    });

    await test.step("Live API verification with bearer token", async () => {
      const verifyResponse = await context.request.get(`${API_BASE_URL}/api/v1/admin/salons/${dossierId}`, {
        headers: {
          authorization: `Bearer ${adminToken}`
        }
      });
      expect(verifyResponse.ok()).toBeTruthy();
      const payload = (await verifyResponse.json()) as { approvalStatus: string; owner: { email: string } };
      expect(payload.owner.email).toBe(proEmail);
      expect(payload.approvalStatus).toBe("rejected");
    });

    await adminPage.close();
  });
});
