# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: pro-dhouley-login.spec.ts >> dhouleymatou account can log in to pro web
- Location: tests/e2e/pro-dhouley-login.spec.ts:3:1

# Error details

```
Test timeout of 180000ms exceeded.
```

```
Error: page.waitForResponse: Test timeout of 180000ms exceeded.
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
            - /placeholder: marie@monsalon.com
            - text: dhouleymatou150@gmail.com
        - generic [ref=e16]:
          - generic [ref=e17]: Mot de passe
          - textbox "Mot de passe" [ref=e19]:
            - /placeholder: ••••••••
            - text: Dhouley1234
        - generic [ref=e20]:
          - generic [ref=e21]:
            - checkbox "Rester connecté" [ref=e22]
            - generic [ref=e23]: Rester connecté
          - button "Mot de passe oublié ?" [ref=e25]
        - button "Se connecter" [ref=e27]:
          - generic [ref=e28]: Se connecter
      - paragraph [ref=e30]:
        - text: Pas encore inscrit ?
        - link "Ouvrez votre salon gratuitement" [ref=e31] [cursor=pointer]:
          - /url: /pro/register
```

# Test source

```ts
  1  | import { expect, test } from "@playwright/test";
  2  | 
  3  | test("dhouleymatou account can log in to pro web", async ({ page }) => {
  4  |   await page.goto("/pro/login");
  5  |   await page.locator("#email").fill("dhouleymatou150@gmail.com");
  6  |   await page.getByLabel("Mot de passe").fill("Dhouley1234");
  7  | 
> 8  |   const loginResponsePromise = page.waitForResponse((response) =>
     |                                     ^ Error: page.waitForResponse: Test timeout of 180000ms exceeded.
  9  |     response.url().includes("/api/v1/auth/login") && response.request().method() === "POST"
  10 |   );
  11 |   await page.getByRole("button", { name: "Se connecter" }).click();
  12 |   const loginResponse = await loginResponsePromise;
  13 |   expect(loginResponse.ok()).toBeTruthy();
  14 | 
  15 |   await page.waitForURL(/\/pro\/(calendar|dashboard)/, { timeout: 30_000 });
  16 | 
  17 |   await expect(page).toHaveURL(/\/pro\/(calendar|dashboard)/);
  18 | });
  19 | 
```