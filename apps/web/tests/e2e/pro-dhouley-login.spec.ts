import { expect, test } from "@playwright/test";

test("dhouleymatou account can log in to pro web", async ({ page }) => {
  await page.goto("/pro/login");
  await page.locator("#email").fill("dhouleymatou150@gmail.com");
  await page.getByLabel("Mot de passe").fill("Dhouley1234");

  const loginResponsePromise = page.waitForResponse((response) =>
    response.url().includes("/api/v1/auth/login") && response.request().method() === "POST"
  );
  await page.getByRole("button", { name: "Se connecter" }).click();
  const loginResponse = await loginResponsePromise;
  expect(loginResponse.ok()).toBeTruthy();

  await page.waitForURL(/\/pro\/(calendar|dashboard)/, { timeout: 30_000 });

  await expect(page).toHaveURL(/\/pro\/(calendar|dashboard)/);
});
