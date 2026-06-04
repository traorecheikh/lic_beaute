import { expect, test } from "@playwright/test";

const API = "http://127.0.0.1:3000";
const PRO_EMAIL = process.env.PW_PRO_EMAIL ?? "kadija@studiokadija.sn";
const PRO_PASSWORD = process.env.PW_PRO_PASSWORD ?? "salon1234";
const SUBSCRIPTION_PHONE = process.env.PW_SUBSCRIPTION_PHONE ?? "781706184";
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

    await page.getByLabel("Numéro de téléphone mobile money").fill(SUBSCRIPTION_PHONE);
    await page.getByLabel("Nom complet").fill(SUBSCRIPTION_FULL_NAME);
    await page.getByLabel("Email").fill(SUBSCRIPTION_EMAIL);

    const checkoutResponsePromise = page.waitForResponse((response) =>
      response.url().includes("/api/v1/pro/subscription/checkout") &&
      response.request().method() === "POST"
    );
    const executeResponsePromise = page.waitForResponse((response) =>
      response.url().includes("/api/v1/pro/subscription/charge/") &&
      response.url().includes("/execute") &&
      response.request().method() === "POST"
    );

    await page.getByRole("button", { name: "Confirmer et Payer" }).click();

    const checkoutResponse = await checkoutResponsePromise;
    const executeResponse = await executeResponsePromise;

    const checkoutJson = await checkoutResponse.json() as Record<string, unknown>;
    const executeJson = await executeResponse.json() as Record<string, unknown>;

    await testInfo.attach("subscription-checkout-init.json", {
      body: JSON.stringify(checkoutJson, null, 2),
      contentType: "application/json"
    });
    await testInfo.attach("subscription-checkout-execute.json", {
      body: JSON.stringify(executeJson, null, 2),
      contentType: "application/json"
    });

    expect(checkoutResponse.ok(), JSON.stringify(checkoutJson)).toBeTruthy();
    expect(executeResponse.ok(), JSON.stringify(executeJson)).toBeTruthy();

    const executeText = JSON.stringify(executeJson);
    const maybeUrl = typeof executeJson.url === "string" ? executeJson.url : "";
    const errorToast = page.locator("body");

    if (maybeUrl) {
      testInfo.annotations.push({ type: "payment-url", description: maybeUrl });
      console.log(`PayDunya returned payment URL: ${maybeUrl}`);
    }

    if ((executeJson.success as boolean | undefined) === true) {
      await expect(
        page
          .getByText("Confirmation du paiement en cours")
          .or(page.getByText("Validation OTP Wizall"))
          .or(page.getByText("En attente de confirmation"))
      ).toBeVisible({ timeout: 15_000 });
    } else {
      await expect(errorToast).toContainText(String(executeJson.message ?? "Échec du paiement."), { timeout: 15_000 });
    }
  });
});
