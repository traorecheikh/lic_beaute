import { expect, test } from "@playwright/test";

test("dhouleymatou account can log in to pro web", async ({ page }) => {
  await page.goto("/pro/login");
  await page.locator("#email").fill("dhouleymatou150@planys.online");
  await page.locator("#password").fill("Dhouley2024!");

  const loginResponsePromise = page.waitForResponse((response) =>
    response.url().includes("/api/v1/auth/login") && response.request().method() === "POST"
  );
  await Promise.all([
    page.waitForURL(/\/pro\/(calendar|dashboard)/, { timeout: 30_000 }),
    page.getByRole("button", { name: "Se connecter" }).click()
  ]);

  const loginResponse = await loginResponsePromise;
  expect(loginResponse.ok()).toBeTruthy();
  await expect(page).toHaveURL(/\/pro\/(calendar|dashboard)/);
});
