import { expect, test } from "@playwright/test";

const API_BASE_URL = (process.env.PW_API_BASE_URL ?? process.env.PW_BASE_URL ?? "http://127.0.0.1:3000").replace(/\/$/, "");
const ADMIN_EMAIL = process.env.PW_ADMIN_EMAIL ?? "admin@beauteavenue.local";
const ADMIN_PASSWORD = process.env.PW_ADMIN_PASSWORD ?? "supersecure";
const PRO_EMAIL = process.env.PW_PRO_EMAIL ?? "aida@dionesignature.sn";
const PRO_PASSWORD = process.env.PW_PRO_PASSWORD ?? "salon1234";

async function waitForApi(page: import("@playwright/test").Page, maxSeconds = 30) {
  for (let i = 0; i < maxSeconds; i += 1) {
    try {
      const response = await page.request.get(`${API_BASE_URL}/health`);
      if (response.ok()) return;
    } catch {
      // API might still be booting.
    }
    await page.waitForTimeout(1000);
  }
}

test.describe("Admin/Pro panel route smoke", () => {
  test("admin and pro key routes render under authenticated sessions", async ({ page, context }) => {
    await waitForApi(page);

    await test.step("Admin login", async () => {
      await page.goto("/admin/login");
      await page.getByPlaceholder("nom@beauteavenue.com").fill(ADMIN_EMAIL);
      await page.getByPlaceholder("••••••••").fill(ADMIN_PASSWORD);
      await Promise.all([
        page.waitForURL(/\/admin\/dashboard/),
        page.getByRole("button", { name: "Ouvrir la session" }).click()
      ]);
      await expect(page.getByRole("heading", { name: "Pilotage" })).toBeVisible();
    });

    await test.step("Admin key pages", async () => {
      const adminRoutes = [
        { path: "/admin/salons", title: "Salons" },
        { path: "/admin/subscriptions", title: "Abonnements" },
        { path: "/admin/audit", title: "Audit" },
        { path: "/admin/config", title: "Configuration" },
        { path: "/admin/account", title: "Mon compte" }
      ];

      for (const route of adminRoutes) {
        await page.goto(route.path);
        await expect(page).toHaveURL(new RegExp(route.path.replace("/", "\\/")));
        await expect(page.getByRole("heading", { name: route.title })).toBeVisible();
      }
    });

    const proPage = await context.newPage();

    await test.step("Pro login", async () => {
      await proPage.goto("/pro/login");
      await proPage.locator("#email").fill(PRO_EMAIL);
      await proPage.locator("#password").fill(PRO_PASSWORD);
      await Promise.all([
        proPage.waitForURL(/\/pro\/(calendar|dashboard)/),
        proPage.getByRole("button", { name: "Se connecter" }).click()
      ]);
      await expect(proPage).toHaveURL(/\/pro\/(calendar|dashboard)/);
    });

    await test.step("Pro key pages", async () => {
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

      for (const path of proRoutes) {
        const response = await proPage.goto(path, { waitUntil: "domcontentloaded" });
        expect(response?.ok()).toBeTruthy();
        await expect(proPage).toHaveURL(new RegExp(path.replace("/", "\\/")));
        expect(proPage.url().includes("/pro/login")).toBeFalsy();
        await expect(proPage.locator("body")).toBeVisible();
      }
    });

    await proPage.close();
  });
});
