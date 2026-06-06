import { expect, test } from "@playwright/test";

const API = (process.env.PW_API_BASE_URL ?? process.env.PW_BASE_URL ?? "http://127.0.0.1:3000").replace(/\/$/, "");
const PRO_EMAIL = process.env.PW_PRO_EMAIL ?? "kadija@studiokadija.sn";
const PRO_PASSWORD = process.env.PW_PRO_PASSWORD ?? "salon1234";
const SUBSCRIPTION_PHONE = process.env.PW_SUBSCRIPTION_PHONE ?? "78 170 61 84";
const SUBSCRIPTION_FULL_NAME = process.env.PW_SUBSCRIPTION_FULL_NAME ?? "Kadija Fall";
const SUBSCRIPTION_EMAIL = process.env.PW_SUBSCRIPTION_EMAIL ?? PRO_EMAIL;

async function waitForApi(page: Parameters<typeof test>[0]["page"], maxSeconds = 45) {
  for (let i = 0; i < maxSeconds; i += 1) {
    try {
      const response = await page.request.get(`${API}/health`);
      if (response.ok()) return;
    } catch {
      // API still booting.
    }
    await page.waitForTimeout(1_000);
  }
  throw new Error("API never became healthy");
}

async function apiLogin(page: Parameters<typeof test>[0]["page"], email: string, password: string) {
  const loginResponse = await page.request.post(`${API}/api/v1/auth/login`, {
    data: { email, password }
  });
  expect(loginResponse.ok(), `login failed for ${email}: ${loginResponse.status()}`).toBeTruthy();
  const session = await loginResponse.json() as { accessToken: string; refreshToken: string };

  await page.goto("/pro/login", { waitUntil: "domcontentloaded" });
  await page.evaluate((payload) => {
    localStorage.setItem("beauteavenue.pro.session", JSON.stringify(payload));
  }, session);
}

test.describe("pro subscription checkout", () => {
  test("logs in with an existing pro account and drives checkout up to the payment result", async ({ page }, testInfo) => {
    await waitForApi(page);
    await apiLogin(page, PRO_EMAIL, PRO_PASSWORD);

    await page.goto("/pro/subscription", { waitUntil: "domcontentloaded" });
    await expect(page.getByRole("heading", { name: "Abonnement & Facturation" })).toBeVisible();

    await expect(page.locator("body")).toContainText("200 XOF");
    await expect(page.locator("body")).toContainText("300 XOF");

    await page.getByRole("button", { name: "Passer en Premium" }).click();
    await expect(page.getByText("Abonnement Beauté Avenue")).toBeVisible();

    await page.getByRole("button", { name: /Wave Sénégal/i }).click();
    await page.getByRole("button", { name: "Continuer" }).click();

    const paymentModal = page.getByText("Détails de paiement - Wave Sénégal").locator("..");
    await paymentModal.locator('input[type="tel"]').first().fill(SUBSCRIPTION_PHONE);
    await paymentModal.locator('input[type="text"]').first().fill(SUBSCRIPTION_FULL_NAME);
    await paymentModal.locator('input[type="email"]').first().fill(SUBSCRIPTION_EMAIL);

    const checkoutResponsePromise = page.waitForResponse((response) =>
      response.url().includes("/api/v1/pro/subscription/checkout") &&
      response.request().method() === "POST"
    );

    await page.getByRole("button", { name: "Confirmer et Payer" }).click();

    const checkoutResponse = await checkoutResponsePromise;
    const checkoutJson = await checkoutResponse.json() as Record<string, unknown>;

    await testInfo.attach("subscription-checkout-init.json", {
      body: JSON.stringify(checkoutJson, null, 2),
      contentType: "application/json"
    });

    if (checkoutResponse.status() === 409 && checkoutJson.code === "upgrade_pending") {
      await expect(page.locator("body")).toContainText(String(checkoutJson.message), { timeout: 15_000 });
      return;
    }

    expect(checkoutResponse.ok(), JSON.stringify(checkoutJson)).toBeTruthy();

    const executeResponse = await page.waitForResponse((response) =>
      response.url().includes("/api/v1/pro/subscription/charge/") &&
      response.url().includes("/execute") &&
      response.request().method() === "POST"
    );
    const executeJson = await executeResponse.json() as Record<string, unknown>;

    await testInfo.attach("subscription-checkout-execute.json", {
      body: JSON.stringify(executeJson, null, 2),
      contentType: "application/json"
    });

    expect(executeResponse.ok(), JSON.stringify(executeJson)).toBeTruthy();

    if ((executeJson.success as boolean | undefined) === true) {
      await expect(page.locator("body")).toContainText(/Confirmation du paiement en cours|Validation OTP Wizall|En attente de confirmation|mise à niveau est déjà en attente de paiement/i, {
        timeout: 15_000
      });
      return;
    }

    await expect(page.locator("body")).toContainText(String(executeJson.message ?? "Échec du paiement."), { timeout: 15_000 });
  });
});
