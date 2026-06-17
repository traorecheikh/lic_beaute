# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: pro-dhouley-login.spec.ts >> dhouleymatou account can log in to pro web
- Location: tests/e2e/pro-dhouley-login.spec.ts:3:1

# Error details

```
TimeoutError: page.waitForURL: Timeout 30000ms exceeded.
=========================== logs ===========================
waiting for navigation until "load"
============================================================
```

# Page snapshot

```yaml
- generic [ref=e2]:
  - region "Notifications alt+T":
    - list
  - generic [ref=e3]:
    - generic [ref=e4]:
      - link "Beauté Avenue" [ref=e5] [cursor=pointer]:
        - /url: /pro
        - img "Beauté Avenue" [ref=e6]
      - heading "Accès Professionnel" [level=2] [ref=e7]
      - paragraph [ref=e8]: Gérez votre salon et vos réservations.
    - generic [ref=e9]:
      - generic [ref=e11]:
        - generic [ref=e12]:
          - generic [ref=e13]: Email ou Téléphone
          - textbox "Email ou Téléphone" [ref=e15]:
            - /placeholder: marie@monsalon.com ou 77 123 45 67
            - text: dhouleymatou150@planys.online
        - generic [ref=e16]:
          - generic [ref=e17]: Mot de passe
          - generic [ref=e18]:
            - textbox "Mot de passe" [ref=e19]:
              - /placeholder: ••••••••
              - text: Dhouley2024!
            - button "Afficher le mot de passe" [ref=e20]:
              - img [ref=e21]
        - generic [ref=e24]:
          - generic [ref=e25]:
            - checkbox "Rester connecté" [ref=e26]
            - generic [ref=e27]: Rester connecté
          - button "Mot de passe oublié ?" [ref=e29]
        - button "Se connecter" [ref=e31]:
          - generic [ref=e32]: Se connecter
      - paragraph [ref=e34]:
        - text: Pas encore inscrit ?
        - link "Ouvrez votre salon gratuitement" [ref=e35] [cursor=pointer]:
          - /url: /pro/register
```

# Test source

```ts
  1  | import { expect, test } from "@playwright/test";
  2  | 
  3  | test("dhouleymatou account can log in to pro web", async ({ page }) => {
  4  |   await page.goto("/pro/login");
  5  |   await page.locator("#email").fill("dhouleymatou150@planys.online");
  6  |   await page.locator("#password").fill("Dhouley2024!");
  7  | 
  8  |   const loginResponsePromise = page.waitForResponse((response) =>
  9  |     response.url().includes("/api/v1/auth/login") && response.request().method() === "POST"
  10 |   );
  11 |   await Promise.all([
> 12 |     page.waitForURL(/\/pro\/(calendar|dashboard)/, { timeout: 30_000 }),
     |          ^ TimeoutError: page.waitForURL: Timeout 30000ms exceeded.
  13 |     page.getByRole("button", { name: "Se connecter" }).click()
  14 |   ]);
  15 | 
  16 |   const loginResponse = await loginResponsePromise;
  17 |   expect(loginResponse.ok()).toBeTruthy();
  18 |   await expect(page).toHaveURL(/\/pro\/(calendar|dashboard)/);
  19 | });
  20 | 
```