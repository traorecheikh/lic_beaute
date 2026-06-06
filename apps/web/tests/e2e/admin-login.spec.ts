import { expect, test } from "@playwright/test";

test("renders the admin login shell", async ({ page }) => {
  await page.goto("/admin/login");

  await expect(page.getByRole("heading", { name: "Identification requise" })).toBeVisible();
  await expect(page.getByPlaceholder("nom@beauteavenue.com")).toBeVisible();
  await expect(page.getByPlaceholder("••••••••")).toBeVisible();
  await expect(page.getByRole("button", { name: "Ouvrir la session" })).toBeVisible();
});
