# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: sprint-full-demo.spec.ts >> Sprint demo — full feature coverage >> 1 · Dhouleymatou dossier: register → admin approve (email triggered)
- Location: tests/e2e/sprint-full-demo.spec.ts:82:3

# Error details

```
Error: login failed for dhouleymatou150@planys.online: 401

expect(received).toBeTruthy()

Received: false
```

# Page snapshot

```yaml
- generic [ref=e2]:
  - region "Notifications alt+T":
    - list:
      - listitem [ref=e3]:
        - img [ref=e5]
        - generic [ref=e8]: Décision enregistrée.
  - generic [ref=e9]:
    - banner [ref=e10]:
      - generic [ref=e11]:
        - link "Beauté Avenue Beauté Avenue" [ref=e12] [cursor=pointer]:
          - /url: /admin/dashboard
          - img "Beauté Avenue" [ref=e13]
          - paragraph [ref=e15]: Beauté Avenue
        - navigation [ref=e16]:
          - link "Pilotage" [ref=e17] [cursor=pointer]:
            - /url: /admin/dashboard
            - img [ref=e18]
            - generic [ref=e20]: Pilotage
          - link "Salons" [ref=e21] [cursor=pointer]:
            - /url: /admin/salons
            - img [ref=e22]
            - generic [ref=e24]: Salons
          - link "Abonnements" [ref=e25] [cursor=pointer]:
            - /url: /admin/subscriptions
            - img [ref=e26]
            - generic [ref=e28]: Abonnements
          - link "Versements" [ref=e29] [cursor=pointer]:
            - /url: /admin/payouts
            - img [ref=e30]
            - generic [ref=e32]: Versements
          - link "Audit log" [ref=e33] [cursor=pointer]:
            - /url: /admin/audit
            - img [ref=e34]
            - generic [ref=e36]: Audit log
          - link "Configuration" [ref=e37] [cursor=pointer]:
            - /url: /admin/config
            - img [ref=e38]
            - generic [ref=e41]: Configuration
          - link "Compte" [ref=e42] [cursor=pointer]:
            - /url: /admin/account
            - img [ref=e43]
            - generic [ref=e45]: Compte
        - generic [ref=e46]:
          - button "18" [ref=e47]:
            - img [ref=e48]
            - generic [ref=e50]: "18"
          - generic [ref=e51]:
            - generic [ref=e52]: CP
            - paragraph [ref=e53]: Cheikh Platform
          - button "Déconnexion" [ref=e54]:
            - img [ref=e55]
            - text: Déconnexion
    - main [ref=e57]:
      - generic [ref=e59]:
        - generic [ref=e60]:
          - link "Retour à la file" [ref=e61] [cursor=pointer]:
            - /url: /admin/salons
            - img [ref=e62]
            - text: Retour à la file
          - generic [ref=e64]:
            - paragraph [ref=e65]: "Dossier:"
            - paragraph [ref=e66]: cmq2wx06
            - link "Voir l'abonnement →" [ref=e67] [cursor=pointer]:
              - /url: /admin/subscriptions/cmqiktmfh001nbmi4x6swyzm8
        - article [ref=e68]:
          - generic [ref=e69]:
            - generic [ref=e70]:
              - generic [ref=e71]:
                - heading "Dhouley Beauty Studio" [level=2] [ref=e72]
                - generic [ref=e73]: Approuvé
                - generic [ref=e74]: Standard
              - generic [ref=e75]:
                - generic [ref=e76]:
                  - img [ref=e77]
                  - generic [ref=e80]: Mermoz, Dakar, Dakar
                - generic [ref=e81]:
                  - img [ref=e82]
                  - generic [ref=e84]: Coiffure
            - generic [ref=e86]:
              - paragraph [ref=e87]: Inscrit le
              - paragraph [ref=e88]: 6 juin 2026 · 22:16
          - paragraph [ref=e90]: Salon de beauté haut de gamme
          - generic [ref=e91]:
            - generic [ref=e92]:
              - paragraph [ref=e93]: Identité Gérant
              - paragraph [ref=e94]: Dhouleymatou BA
            - generic [ref=e95]:
              - paragraph [ref=e96]: Téléphone
              - paragraph [ref=e97]: "+221775001500"
            - generic [ref=e98]:
              - paragraph [ref=e99]: E-mail
              - paragraph [ref=e100]: dhouleymatou150@gmail.com
              - button "Envoyer un accès" [ref=e102]:
                - img [ref=e103]
                - text: Envoyer un accès
                - img [ref=e105]
            - generic [ref=e107]:
              - paragraph [ref=e108]: Date Soumission
              - paragraph [ref=e109]: 6 juin 2026 · 22:16
        - generic [ref=e110]:
          - generic [ref=e113]:
            - heading "Pièces Justificatives" [level=3] [ref=e114]
            - generic [ref=e115]: 0 documents
          - generic [ref=e116]:
            - heading "Visuels Salon" [level=3] [ref=e118]
            - generic [ref=e119]:
              - generic [ref=e120]:
                - heading "Catalogue Services" [level=3] [ref=e121]
                - button "Ajouter" [ref=e122]:
                  - img [ref=e123]
                  - text: Ajouter
              - generic [ref=e125]:
                - article [ref=e126]:
                  - generic [ref=e127]:
                    - paragraph [ref=e128]: Tresses Box Braids
                    - paragraph [ref=e129]: 180 min • 35 000 F CFA
                  - generic [ref=e130]:
                    - generic [ref=e131]: Aucun
                    - button [ref=e132]:
                      - img [ref=e133]
                    - button [ref=e135]:
                      - img [ref=e136]
                - article [ref=e138]:
                  - generic [ref=e139]:
                    - paragraph [ref=e140]: Coupe + Brushing
                    - paragraph [ref=e141]: 60 min • 15 000 F CFA
                  - generic [ref=e142]:
                    - generic [ref=e143]: Aucun
                    - button [ref=e144]:
                      - img [ref=e145]
                    - button [ref=e147]:
                      - img [ref=e148]
        - generic [ref=e150]:
          - img [ref=e152]
          - generic [ref=e154]:
            - heading "Salon approuvé" [level=4] [ref=e155]
            - paragraph [ref=e156]: Ce dossier est en production. Toute modification opérationnelle doit passer par le menu d'abonnement ou les outils de sanction.
```

# Test source

```ts
  1   | /**
  2   |  * Full sprint demo — Playwright end-to-end suite
  3   |  *
  4   |  * Covers every feature shipped in the sprint:
  5   |  *   • Admin: salon dossier approval, request-info checklist, reject, audit filters,
  6   |  *            config duplicate prevention, subscription management
  7   |  *   • Pro:   services add/delete (confirm dialog), subscription grace banner,
  8   |  *            calendar, bookings inbox, analytics tier gate
  9   |  *   • Real actor: dhouleymatou150@planys.online registered and approved → email triggered
  10  |  *
  11  |  * Run for demo (visible, slow):
  12  |  *   PW_HEADLESS=false PW_SLOWMO=600 pnpm --filter @beauteavenue/web-admin test:e2e \
  13  |  *     --project=chromium tests/e2e/sprint-full-demo.spec.ts
  14  |  *
  15  |  * Run for CI (headless, fast):
  16  |  *   pnpm --filter @beauteavenue/web-admin test:e2e tests/e2e/sprint-full-demo.spec.ts
  17  |  */
  18  | 
  19  | import { expect, test, type BrowserContext, type Page } from "@playwright/test";
  20  | 
  21  | const API = process.env.PW_BASE_URL ?? "http://127.0.0.1:3000";
  22  | 
  23  | // ─── helpers ──────────────────────────────────────────────────────────────────
  24  | 
  25  | async function waitForApi(page: Page, maxSeconds = 45) {
  26  |   for (let i = 0; i < maxSeconds; i++) {
  27  |     try {
  28  |       const r = await page.request.get(`${API}/health`);
  29  |       if (r.ok()) return;
  30  |     } catch { /* booting */ }
  31  |     await page.waitForTimeout(1_000);
  32  |   }
  33  |   throw new Error("API never became healthy");
  34  | }
  35  | 
  36  | /** Get a JWT via API (no UI form → avoids rate limiter) and inject into localStorage. */
  37  | async function apiLogin(
  38  |   page: Page,
  39  |   context: BrowserContext,
  40  |   email: string,
  41  |   password: string,
  42  |   storeKey: "beauteavenue.admin.session" | "beauteavenue.pro.session",
  43  |   landingPath: string
  44  | ) {
  45  |   const loginR = await context.request.post(`${API}/api/v1/auth/login`, {
  46  |     data: { email, password }
  47  |   });
> 48  |   expect(loginR.ok(), `login failed for ${email}: ${loginR.status()}`).toBeTruthy();
      |                                                                        ^ Error: login failed for dhouleymatou150@planys.online: 401
  49  |   const { accessToken, refreshToken } = await loginR.json() as { accessToken: string; refreshToken: string };
  50  | 
  51  |   // Set a neutral page first so localStorage is on the correct origin
  52  |   await page.goto("/admin/login", { waitUntil: "domcontentloaded" });
  53  |   await page.evaluate(
  54  |     ({ key, val }) => localStorage.setItem(key, JSON.stringify(val)),
  55  |     { key: storeKey, val: { accessToken, refreshToken } }
  56  |   );
  57  |   await page.goto(landingPath, { waitUntil: "domcontentloaded" });
  58  |   await page.waitForFunction(
  59  |     (path) => window.location.pathname.startsWith(path),
  60  |     landingPath,
  61  |     { timeout: 20_000 }
  62  |   );
  63  |   return accessToken;
  64  | }
  65  | 
  66  | async function adminLogin(page: Page, ctx: BrowserContext) {
  67  |   return apiLogin(page, ctx, process.env.PW_ADMIN_EMAIL ?? "admin@beauteavenue.local", process.env.PW_ADMIN_PASSWORD ?? "supersecure", "beauteavenue.admin.session", "/admin/dashboard");
  68  | }
  69  | 
  70  | async function proLogin(page: Page, ctx: BrowserContext, email: string, password: string) {
  71  |   return apiLogin(page, ctx, email, password, "beauteavenue.pro.session", "/pro/calendar");
  72  | }
  73  | 
  74  | // ─── suite ────────────────────────────────────────────────────────────────────
  75  | 
  76  | test.describe("Sprint demo — full feature coverage", () => {
  77  |   test.setTimeout(120_000);
  78  | 
  79  |   // ──────────────────────────────────────────────────────────────────────────
  80  |   // 1. REAL ACTOR: register dhouleymatou150@planys.online → admin approves → email
  81  |   // ──────────────────────────────────────────────────────────────────────────
  82  |   test("1 · Dhouleymatou dossier: register → admin approve (email triggered)", async ({
  83  |     page, context
  84  |   }) => {
  85  |     await waitForApi(page);
  86  | 
  87  |     const demoEmail = "dhouleymatou150@planys.online";
  88  |     const demoPassword = "Dhouley2024!";
  89  |     const demoSalon = "Dhouley Beauty Studio";
  90  |     let salonId = "";
  91  | 
  92  |     await test.step("Register or locate salon owner dossier", async () => {
  93  |       const reg = await context.request.post(`${API}/api/v1/auth/register`, {
  94  |         data: {
  95  |           type: "salon_owner",
  96  |           fullName: "Dhouleymatou BA",
  97  |           email: demoEmail,
  98  |           phone: "+221775001500",
  99  |           password: demoPassword,
  100 |           salon: {
  101 |             name: demoSalon,
  102 |             category: "Coiffure",
  103 |             city: "Dakar",
  104 |             address: "Mermoz, Dakar",
  105 |             description: "Salon de beauté haut de gamme"
  106 |           },
  107 |           services: [
  108 |             { name: "Tresses Box Braids", durationMinutes: 180, priceXof: 35000, depositMode: "none" },
  109 |             { name: "Coupe + Brushing", durationMinutes: 60, priceXof: 15000, depositMode: "percent", depositPercent: 30 }
  110 |           ],
  111 |           hours: Array.from({ length: 7 }, (_, i) => ({
  112 |             dayOfWeek: i, isOpen: i !== 0, opensAt: "09:00", closesAt: "20:00"
  113 |           }))
  114 |         }
  115 |       });
  116 |       // 409 = already registered from a prior run — that's fine
  117 |       expect([200, 201, 409]).toContain(reg.status());
  118 |     });
  119 | 
  120 |     const adminToken = await adminLogin(page, context);
  121 | 
  122 |     await test.step("Admin finds dossier via API and navigates to detail", async () => {
  123 |       // Use admin API to look up salonId directly — avoids status-filter UI state issues
  124 |       const listR = await context.request.get(`${API}/api/v1/admin/salons?search=${encodeURIComponent(demoSalon)}`, {
  125 |         headers: { authorization: `Bearer ${adminToken}` }
  126 |       });
  127 |       const list = await listR.json() as { items: Array<{ id: string }> };
  128 |       expect(list.items.length, "Dhouleymatou salon not found in admin list").toBeGreaterThan(0);
  129 |       salonId = list.items[0].id;
  130 | 
  131 |       // Navigate to the detail page directly
  132 |       await page.goto(`/admin/salons/${salonId}`, { waitUntil: "domcontentloaded" });
  133 |       await page.waitForURL(`/admin/salons/${salonId}`, { timeout: 15_000 });
  134 |     });
  135 | 
  136 |     await test.step("Admin approves (triggers confirmation email to dhouleymatou150@planys.online)", async () => {
  137 |       // If already approved from a previous run, skip
  138 |       const detail = await context.request.get(`${API}/api/v1/admin/salons/${salonId}`, {
  139 |         headers: { authorization: `Bearer ${adminToken}` }
  140 |       });
  141 |       const payload = await detail.json() as { approvalStatus: string };
  142 | 
  143 |       if (payload.approvalStatus !== "approved") {
  144 |         await page.locator('label:has-text("Approuver")').click();
  145 |         await Promise.all([
  146 |           page.waitForResponse(
  147 |             (r) => r.url().includes(`/api/v1/admin/salons/${salonId}/approve`) && r.status() === 200
  148 |           ),
```