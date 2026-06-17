# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: full-flow-admin-pro.spec.ts >> Admin + Pro full business flow >> register pro dossier, login pro, review dossier in admin
- Location: tests/e2e/full-flow-admin-pro.spec.ts:18:3

# Error details

```
Test timeout of 180000ms exceeded.
```

```
Error: page.waitForURL: Test timeout of 180000ms exceeded.
=========================== logs ===========================
waiting for navigation until "load"
  navigated to "http://127.0.0.1:4174/pro/login"
  navigated to "http://127.0.0.1:4174/pro/approval-status"
============================================================
```

# Page snapshot

```yaml
- generic [ref=e2]:
  - region "Notifications alt+T":
    - list
  - generic [ref=e3]:
    - banner [ref=e4]:
      - generic [ref=e5]:
        - link "Beauté Avenue Flow Salon 1781731093611" [ref=e7] [cursor=pointer]:
          - /url: /pro/calendar
          - img "Beauté Avenue" [ref=e8]
          - paragraph [ref=e11]: Flow Salon 1781731093611
        - navigation [ref=e14]:
          - link "Agenda" [ref=e15] [cursor=pointer]:
            - /url: /pro/calendar
            - img [ref=e16]
            - generic [ref=e18]: Agenda
          - link "Clients" [ref=e19] [cursor=pointer]:
            - /url: /pro/clients
            - img [ref=e20]
            - generic [ref=e22]: Clients
          - link "Ventes" [ref=e23] [cursor=pointer]:
            - /url: /pro/payouts
            - img [ref=e24]
            - generic [ref=e26]: Ventes
          - link "Inbox" [ref=e27] [cursor=pointer]:
            - /url: /pro/bookings/inbox
            - img [ref=e28]
            - generic [ref=e30]: Inbox
          - link "Rapports" [ref=e31] [cursor=pointer]:
            - /url: /pro/analytics
            - img [ref=e32]
            - generic [ref=e34]: Rapports
          - link "Services" [ref=e35] [cursor=pointer]:
            - /url: /pro/salon/services
            - img [ref=e36]
            - generic [ref=e38]: Services
        - generic [ref=e39]:
          - link "Contacter le support via WhatsApp" [ref=e40] [cursor=pointer]:
            - /url: https://wa.me/221338671010
            - img [ref=e41]
          - button "0 notifications non lues" [ref=e43]:
            - img [ref=e44]
          - generic [ref=e47]:
            - generic [ref=e48]:
              - paragraph [ref=e49]: Flow Owner
              - paragraph [ref=e50]: Propriétaire
            - button "FO" [ref=e52]
    - main [ref=e53]:
      - generic [ref=e55]:
        - generic [ref=e56]:
          - img [ref=e58]
          - generic [ref=e60]:
            - paragraph [ref=e61]: État de votre dossier
            - heading "Vérification en cours" [level=2] [ref=e62]
            - paragraph [ref=e63]: Nous examinons vos documents. Cette étape prend généralement moins de 24h. Vous recevrez une notification par email.
        - generic [ref=e66]:
          - img [ref=e67]
          - heading "Fonctionnalités verrouillées" [level=3] [ref=e69]
          - paragraph [ref=e70]: Une fois votre salon approuvé, vous aurez accès à votre agenda, vos clients et vos outils de vente.
        - generic [ref=e106]:
          - heading "Partenaire de votre réussite" [level=3] [ref=e107]
          - paragraph [ref=e109]: Beauté Avenue Pro
```

# Test source

```ts
  1   | import { expect, test } from "@playwright/test";
  2   | 
  3   | const API_BASE_URL = (process.env.PW_API_BASE_URL ?? process.env.PW_BASE_URL ?? "http://127.0.0.1:3000").replace(/\/$/, "");
  4   | 
  5   | async function waitForApi(page: import("@playwright/test").Page, maxSeconds = 30) {
  6   |   for (let i = 0; i < maxSeconds; i += 1) {
  7   |     try {
  8   |       const health = await page.request.get(`${API_BASE_URL}/health`);
  9   |       if (health.ok()) return;
  10  |     } catch {
  11  |       // API may still be booting during Playwright webServer startup.
  12  |     }
  13  |     await page.waitForTimeout(1_000);
  14  |   }
  15  | }
  16  | 
  17  | test.describe("Admin + Pro full business flow", () => {
  18  |   test("register pro dossier, login pro, review dossier in admin", async ({ page, context }) => {
  19  |     await waitForApi(page);
  20  | 
  21  |     const runId = Date.now();
  22  |     const proEmail = `pro.flow.${runId}@example.sn`;
  23  |     const proPhone = `+22178${String(runId).slice(-7)}`;
  24  |     const proPassword = "flowpass1234";
  25  |     const salonName = `Flow Salon ${runId}`;
  26  | 
  27  |     await test.step("Register pro owner dossier through live API contract", async () => {
  28  |       const registerResponse = await context.request.post(`${API_BASE_URL}/api/v1/auth/register`, {
  29  |         data: {
  30  |           type: "salon_owner",
  31  |           fullName: "Flow Owner",
  32  |           email: proEmail,
  33  |           phone: proPhone,
  34  |           password: proPassword,
  35  |           salon: {
  36  |             name: salonName,
  37  |             category: "Coiffure",
  38  |             city: "Dakar",
  39  |             address: "Mermoz, Dakar",
  40  |             description: ""
  41  |           },
  42  |           services: [
  43  |             {
  44  |               name: "Brushing Flow",
  45  |               durationMinutes: 45,
  46  |               priceXof: 12000,
  47  |               depositMode: "none"
  48  |             }
  49  |           ],
  50  |           hours: [
  51  |             { dayOfWeek: 1, isOpen: true, opensAt: "09:00", closesAt: "19:00" },
  52  |             { dayOfWeek: 2, isOpen: true, opensAt: "09:00", closesAt: "19:00" },
  53  |             { dayOfWeek: 3, isOpen: true, opensAt: "09:00", closesAt: "19:00" },
  54  |             { dayOfWeek: 4, isOpen: true, opensAt: "09:00", closesAt: "19:00" },
  55  |             { dayOfWeek: 5, isOpen: true, opensAt: "09:00", closesAt: "19:00" },
  56  |             { dayOfWeek: 6, isOpen: true, opensAt: "09:00", closesAt: "19:00" },
  57  |             { dayOfWeek: 0, isOpen: true, opensAt: "09:00", closesAt: "19:00" }
  58  |           ]
  59  |         }
  60  |       });
  61  |       expect(registerResponse.ok()).toBeTruthy();
  62  | 
  63  |     });
  64  | 
  65  |     await test.step("Pro owner can login", async () => {
  66  |       await page.goto("/pro/login");
  67  |       await page.locator("#email").fill(proEmail);
  68  |       await page.locator("#password").fill(proPassword);
  69  |       await Promise.all([
> 70  |         page.waitForURL(/\/pro\/(calendar|dashboard)/),
      |              ^ Error: page.waitForURL: Test timeout of 180000ms exceeded.
  71  |         page.getByRole("button", { name: "Se connecter" }).click()
  72  |       ]);
  73  |       await expect(page).toHaveURL(/\/pro\/(calendar|dashboard)/);
  74  |     });
  75  | 
  76  |     const adminPage = await context.newPage();
  77  |     let adminToken = "";
  78  |     let dossierId = "";
  79  | 
  80  |     await test.step("Admin login and open the newly submitted dossier", async () => {
  81  |       await adminPage.goto("/admin/login");
  82  |       await adminPage.getByPlaceholder("nom@beauteavenue.com").fill(process.env.PW_ADMIN_EMAIL ?? "admin@beauteavenue.local");
  83  |       await adminPage.getByPlaceholder("••••••••").fill(process.env.PW_ADMIN_PASSWORD ?? "supersecure");
  84  | 
  85  |       const loginResponsePromise = adminPage.waitForResponse((response) =>
  86  |         response.url().includes("/api/v1/auth/login") && response.request().method() === "POST"
  87  |       );
  88  | 
  89  |       await Promise.all([
  90  |         adminPage.waitForURL(/\/admin\/dashboard/),
  91  |         adminPage.getByRole("button", { name: "Ouvrir la session" }).click()
  92  |       ]);
  93  | 
  94  |       const loginResponse = await loginResponsePromise;
  95  |       const loginBody = (await loginResponse.json()) as { accessToken: string };
  96  |       adminToken = loginBody.accessToken;
  97  | 
  98  |       await adminPage.goto("/admin/salons");
  99  |       await adminPage.getByPlaceholder("Enseigne...").fill(salonName);
  100 | 
  101 |       const dossierRow = adminPage.locator("article", { hasText: salonName }).first();
  102 |       await expect(dossierRow).toBeVisible({ timeout: 20_000 });
  103 | 
  104 |       const detailResponsePromise = adminPage.waitForResponse((response) =>
  105 |         response.url().includes("/api/v1/admin/salons/") && response.request().method() === "GET"
  106 |       );
  107 | 
  108 |       await dossierRow.getByRole("button", { name: "Dossier" }).click();
  109 |       await adminPage.getByRole("link", { name: "Voir le dossier" }).first().click();
  110 |       await expect(adminPage).toHaveURL(/\/admin\/salons\//);
  111 | 
  112 |       const detailResponse = await detailResponsePromise;
  113 |       const detailBody = (await detailResponse.json()) as { id: string };
  114 |       dossierId = detailBody.id;
  115 |       expect(dossierId.length).toBeGreaterThan(5);
  116 |     });
  117 | 
  118 |     await test.step("Admin requests more info then rejects dossier", async () => {
  119 |       await adminPage.locator('label:has-text("Compléments")').click();
  120 |       await adminPage.getByPlaceholder("Requis...").fill("Merci d'ajouter un justificatif fiscal.");
  121 | 
  122 |       await Promise.all([
  123 |         adminPage.waitForResponse((response) =>
  124 |           response.url().includes(`/api/v1/admin/salons/${dossierId}/request-info`) && response.status() === 200
  125 |         ),
  126 |         adminPage.getByRole("button", { name: "Confirmer" }).click()
  127 |       ]);
  128 | 
  129 |       await adminPage.locator('label:has-text("Rejeter")').click();
  130 |       await adminPage.getByPlaceholder("Requis...").fill("Dossier incomplet après relance.");
  131 | 
  132 |       await Promise.all([
  133 |         adminPage.waitForResponse((response) =>
  134 |           response.url().includes(`/api/v1/admin/salons/${dossierId}/reject`) && response.status() === 200
  135 |         ),
  136 |         adminPage.getByRole("button", { name: "Confirmer" }).click()
  137 |       ]);
  138 |     });
  139 | 
  140 |     await test.step("Live API verification with bearer token", async () => {
  141 |       const verifyResponse = await context.request.get(`${API_BASE_URL}/api/v1/admin/salons/${dossierId}`, {
  142 |         headers: {
  143 |           authorization: `Bearer ${adminToken}`
  144 |         }
  145 |       });
  146 |       expect(verifyResponse.ok()).toBeTruthy();
  147 |       const payload = (await verifyResponse.json()) as { approvalStatus: string; owner: { email: string } };
  148 |       expect(payload.owner.email).toBe(proEmail);
  149 |       expect(payload.approvalStatus).toBe("rejected");
  150 |     });
  151 | 
  152 |     await adminPage.close();
  153 |   });
  154 | });
  155 | 
```