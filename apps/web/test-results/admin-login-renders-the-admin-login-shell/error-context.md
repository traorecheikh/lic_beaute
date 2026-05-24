# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: admin-login.spec.ts >> renders the admin login shell
- Location: tests/e2e/admin-login.spec.ts:3:1

# Error details

```
Error: expect(locator).toBeVisible() failed

Locator: getByRole('heading', { name: 'Connexion admin' })
Expected: visible
Timeout: 5000ms
Error: element(s) not found

Call log:
  - Expect "toBeVisible" with timeout 5000ms
  - waiting for getByRole('heading', { name: 'Connexion admin' })

```

# Page snapshot

```yaml
- generic [ref=e2]:
  - region "Notifications alt+T":
    - list
  - generic [ref=e5]:
    - article [ref=e6]:
      - generic [ref=e8]:
        - img "Beauté Avenue" [ref=e10]
        - generic [ref=e11]:
          - heading "Beauté Avenue" [level=2] [ref=e12]
          - paragraph [ref=e13]: Console Administration
      - generic [ref=e14]:
        - heading "Identification requise" [level=1] [ref=e15]
        - paragraph [ref=e16]: Utilisez vos identifiants pour accéder au pilotage.
      - generic [ref=e17]:
        - generic [ref=e18]:
          - generic [ref=e19]:
            - generic [ref=e20]: Email professionnel
            - generic [ref=e21]:
              - img
              - textbox "nom@beauteavenue.com" [ref=e22]
          - generic [ref=e23]:
            - generic [ref=e24]: Mot de passe
            - generic [ref=e25]:
              - img
              - textbox "••••••••" [ref=e26]
        - button "Ouvrir la session" [ref=e27]:
          - generic [ref=e28]:
            - img [ref=e29]
            - text: Ouvrir la session
    - paragraph [ref=e32]: Système d'Exploitation Centralisé • v1.0
```

# Test source

```ts
  1  | import { expect, test } from "@playwright/test";
  2  | 
  3  | test("renders the admin login shell", async ({ page }) => {
  4  |   await page.goto("/admin/login");
  5  | 
> 6  |   await expect(page.getByRole("heading", { name: "Connexion admin" })).toBeVisible();
     |                                                                        ^ Error: expect(locator).toBeVisible() failed
  7  |   await expect(page.getByLabel("Email")).toBeVisible();
  8  |   await expect(page.getByLabel("Mot de passe")).toBeVisible();
  9  |   await expect(page.getByRole("button", { name: "Se connecter" })).toBeVisible();
  10 | });
  11 | 
```