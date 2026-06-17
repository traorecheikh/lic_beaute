# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: pro-subscription-checkout.spec.ts >> pro subscription checkout >> logs in with an existing pro account and drives checkout up to the payment result
- Location: tests/e2e/pro-subscription-checkout.spec.ts:37:3

# Error details

```
Error: expect(locator).toBeVisible() failed

Locator: getByText('Abonnement Beauté Avenue')
Expected: visible
Timeout: 5000ms
Error: element(s) not found

Call log:
  - Expect "toBeVisible" with timeout 5000ms
  - waiting for getByText('Abonnement Beauté Avenue')

```

# Page snapshot

```yaml
- generic [ref=e1]:
  - generic [ref=e2]:
    - region "Notifications alt+T":
      - list
    - generic [ref=e3]:
      - banner [ref=e4]:
        - generic [ref=e5]:
          - link "Beauté Avenue Studio Kadija" [ref=e7] [cursor=pointer]:
            - /url: /pro/calendar
            - img "Beauté Avenue" [ref=e8]
            - paragraph [ref=e11]: Studio Kadija
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
                - paragraph [ref=e49]: Kadija Fall
                - paragraph [ref=e50]: Propriétaire
              - button "KF" [ref=e52]
      - main [ref=e53]:
        - generic [ref=e55]:
          - generic [ref=e56]:
            - generic [ref=e57]:
              - heading "Abonnement & Facturation" [level=1] [ref=e58]
              - paragraph [ref=e59]: Gérez votre plan, vos factures et votre mode de paiement.
            - generic [ref=e61]:
              - generic [ref=e62]: "Statut :"
              - text: Actif
          - generic [ref=e63]:
            - generic [ref=e64]:
              - paragraph [ref=e65]: Plan actuel
              - paragraph [ref=e66]: Beauté Avenue Standard
              - paragraph [ref=e67]: Prochaine échéance à définir • renouvellement auto désactivé
            - generic [ref=e68]:
              - button "Passer en Premium" [ref=e69]
              - button "Renouveler" [ref=e70]
              - button "Résilier" [ref=e71]
          - generic [ref=e72]:
            - generic [ref=e73]:
              - generic [ref=e74]: Plan actuel
              - generic [ref=e76]:
                - paragraph [ref=e77]: Standard
                - paragraph [ref=e78]: 200 XOF
                - paragraph [ref=e79]: / mois
              - list [ref=e80]:
                - listitem [ref=e81]:
                  - img [ref=e82]
                  - generic [ref=e84]: ✓
                  - generic [ref=e85]: Agenda illimité
                - listitem [ref=e86]:
                  - img [ref=e87]
                  - generic [ref=e89]: ✓
                  - generic [ref=e90]: Gestion de l'équipe
                - listitem [ref=e91]:
                  - img [ref=e92]
                  - generic [ref=e94]: ✗
                  - generic [ref=e95]: Acompte client
                - listitem [ref=e96]:
                  - img [ref=e97]
                  - generic [ref=e99]: ✗
                  - generic [ref=e100]: Rapports financiers
                - listitem [ref=e101]:
                  - img [ref=e102]
                  - generic [ref=e104]: ✗
                  - generic [ref=e105]: Export CSV
                - listitem [ref=e106]:
                  - img [ref=e107]
                  - generic [ref=e109]: ✗
                  - generic [ref=e110]: Badge « Vérifié »
                - listitem [ref=e111]:
                  - img [ref=e112]
                  - generic [ref=e114]: ✗
                  - generic [ref=e115]: Support prioritaire 24/7
            - generic [ref=e116]:
              - generic [ref=e118]:
                - paragraph [ref=e119]: Premium
                - paragraph [ref=e120]: 300 XOF
                - paragraph [ref=e121]: / mois
              - list [ref=e122]:
                - listitem [ref=e123]:
                  - img [ref=e124]
                  - generic [ref=e126]: ✓
                  - generic [ref=e127]: Agenda illimité
                - listitem [ref=e128]:
                  - img [ref=e129]
                  - generic [ref=e131]: ✓
                  - generic [ref=e132]: Gestion de l'équipe
                - listitem [ref=e133]:
                  - img [ref=e134]
                  - generic [ref=e136]: ✓
                  - generic [ref=e137]: Acompte client
                - listitem [ref=e138]:
                  - img [ref=e139]
                  - generic [ref=e141]: ✓
                  - generic [ref=e142]: Rapports financiers
                - listitem [ref=e143]:
                  - img [ref=e144]
                  - generic [ref=e146]: ✓
                  - generic [ref=e147]: Export CSV
                - listitem [ref=e148]:
                  - img [ref=e149]
                  - generic [ref=e151]: ✓
                  - generic [ref=e152]: Badge « Vérifié »
                - listitem [ref=e153]:
                  - img [ref=e154]
                  - generic [ref=e156]: ✓
                  - generic [ref=e157]: Support prioritaire 24/7
          - generic [ref=e158]:
            - generic [ref=e160]:
              - generic [ref=e161]:
                - heading "Historique des factures" [level=2] [ref=e162]
                - generic [ref=e163]: 0 factures
              - status [ref=e164]:
                - paragraph [ref=e165]: Aucune facture pour le moment.
                - paragraph [ref=e166]: Vos prochaines factures apparaîtront ici.
            - generic [ref=e167]:
              - generic [ref=e168]:
                - heading "Mode de paiement" [level=2] [ref=e169]
                - generic [ref=e170]:
                  - paragraph [ref=e171]: Aucun moyen de paiement configuré.
                  - paragraph [ref=e172]: Requis pour le renouvellement automatique.
                - button "Configurer" [ref=e173]:
                  - img [ref=e174]
                  - text: Configurer
              - generic [ref=e176]:
                - heading "Renouvellement automatique" [level=2] [ref=e177]
                - generic [ref=e178]:
                  - generic [ref=e179]:
                    - paragraph [ref=e180]: Désactivé
                    - paragraph [ref=e181]: Vous devrez renouveler manuellement.
                  - 'switch "Renouvellement automatique : désactivé" [ref=e182]'
              - generic [ref=e184]:
                - heading "Support" [level=2] [ref=e185]
                - paragraph [ref=e186]: Une question sur votre abonnement ou une facture ?
                - button "Contacter le support" [ref=e187]:
                  - img [ref=e188]
                  - text: Contacter le support
  - dialog [ref=e190]:
    - generic [ref=e192]:
      - generic [ref=e193]:
        - generic [ref=e194]:
          - heading "Passer en Premium" [level=3] [ref=e195]
          - paragraph [ref=e196]: Choisissez votre moyen de paiement et finalisez.
        - button "Fermer" [active] [ref=e197]:
          - img [ref=e198]
      - generic [ref=e202]:
        - generic [ref=e203]:
          - generic [ref=e204]: Cycle de facturation
          - generic [ref=e205]:
            - button "Mensuel" [ref=e206]
            - button "Annuel" [ref=e207]
        - generic [ref=e208]:
          - generic [ref=e209]: Pays de facturation
          - combobox [ref=e210]:
            - option "🇸🇳 SN" [selected]
        - generic [ref=e211]:
          - generic [ref=e212]: Moyen de paiement
          - generic [ref=e213]:
            - button "Wave Wave" [ref=e214]:
              - img "Wave" [ref=e216]
              - paragraph [ref=e217]: Wave
            - button "Orange Money Orange Money" [ref=e218]:
              - img "Orange Money" [ref=e220]
              - paragraph [ref=e221]: Orange Money
      - generic [ref=e223]:
        - button "Annuler" [ref=e224]
        - button "Continuer" [disabled] [ref=e225]
```

# Test source

```ts
  1   | import { expect, test } from "@playwright/test";
  2   | 
  3   | const API = (process.env.PW_API_BASE_URL ?? process.env.PW_BASE_URL ?? "http://127.0.0.1:3000").replace(/\/$/, "");
  4   | const PRO_EMAIL = process.env.PW_PRO_EMAIL ?? "kadija@studiokadija.sn";
  5   | const PRO_PASSWORD = process.env.PW_PRO_PASSWORD ?? "salon1234";
  6   | const SUBSCRIPTION_PHONE = process.env.PW_SUBSCRIPTION_PHONE ?? "78 170 61 84";
  7   | const SUBSCRIPTION_FULL_NAME = process.env.PW_SUBSCRIPTION_FULL_NAME ?? "Kadija Fall";
  8   | const SUBSCRIPTION_EMAIL = process.env.PW_SUBSCRIPTION_EMAIL ?? PRO_EMAIL;
  9   | 
  10  | async function waitForApi(page: Parameters<typeof test>[0]["page"], maxSeconds = 45) {
  11  |   for (let i = 0; i < maxSeconds; i += 1) {
  12  |     try {
  13  |       const response = await page.request.get(`${API}/health`);
  14  |       if (response.ok()) return;
  15  |     } catch {
  16  |       // API still booting.
  17  |     }
  18  |     await page.waitForTimeout(1_000);
  19  |   }
  20  |   throw new Error("API never became healthy");
  21  | }
  22  | 
  23  | async function apiLogin(page: Parameters<typeof test>[0]["page"], email: string, password: string) {
  24  |   const loginResponse = await page.request.post(`${API}/api/v1/auth/login`, {
  25  |     data: { email, password }
  26  |   });
  27  |   expect(loginResponse.ok(), `login failed for ${email}: ${loginResponse.status()}`).toBeTruthy();
  28  |   const session = await loginResponse.json() as { accessToken: string; refreshToken: string };
  29  | 
  30  |   await page.goto("/pro/login", { waitUntil: "domcontentloaded" });
  31  |   await page.evaluate((payload) => {
  32  |     localStorage.setItem("beauteavenue.pro.session", JSON.stringify(payload));
  33  |   }, session);
  34  | }
  35  | 
  36  | test.describe("pro subscription checkout", () => {
  37  |   test("logs in with an existing pro account and drives checkout up to the payment result", async ({ page }, testInfo) => {
  38  |     await waitForApi(page);
  39  |     await apiLogin(page, PRO_EMAIL, PRO_PASSWORD);
  40  | 
  41  |     await page.goto("/pro/subscription", { waitUntil: "domcontentloaded" });
  42  |     await expect(page.getByRole("heading", { name: "Abonnement & Facturation" })).toBeVisible();
  43  | 
  44  |     await expect(page.locator("body")).toContainText("200 XOF");
  45  |     await expect(page.locator("body")).toContainText("300 XOF");
  46  | 
  47  |     await page.getByRole("button", { name: "Passer en Premium" }).click();
> 48  |     await expect(page.getByText("Abonnement Beauté Avenue")).toBeVisible();
      |                                                              ^ Error: expect(locator).toBeVisible() failed
  49  | 
  50  |     await page.getByRole("button", { name: /Wave Sénégal/i }).click();
  51  |     await page.getByRole("button", { name: "Continuer" }).click();
  52  | 
  53  |     const paymentModal = page.getByText("Détails de paiement - Wave Sénégal").locator("..");
  54  |     await paymentModal.locator('input[type="tel"]').first().fill(SUBSCRIPTION_PHONE);
  55  |     await paymentModal.locator('input[type="text"]').first().fill(SUBSCRIPTION_FULL_NAME);
  56  |     await paymentModal.locator('input[type="email"]').first().fill(SUBSCRIPTION_EMAIL);
  57  | 
  58  |     const checkoutResponsePromise = page.waitForResponse((response) =>
  59  |       response.url().includes("/api/v1/pro/subscription/checkout") &&
  60  |       response.request().method() === "POST"
  61  |     );
  62  | 
  63  |     await page.getByRole("button", { name: "Confirmer et Payer" }).click();
  64  | 
  65  |     const checkoutResponse = await checkoutResponsePromise;
  66  |     const checkoutJson = await checkoutResponse.json() as Record<string, unknown>;
  67  | 
  68  |     await testInfo.attach("subscription-checkout-init.json", {
  69  |       body: JSON.stringify(checkoutJson, null, 2),
  70  |       contentType: "application/json"
  71  |     });
  72  | 
  73  |     if (checkoutResponse.status() === 409 && checkoutJson.code === "upgrade_pending") {
  74  |       await expect(page.locator("body")).toContainText(String(checkoutJson.message), { timeout: 15_000 });
  75  |       return;
  76  |     }
  77  | 
  78  |     expect(checkoutResponse.ok(), JSON.stringify(checkoutJson)).toBeTruthy();
  79  | 
  80  |     const executeResponse = await page.waitForResponse((response) =>
  81  |       response.url().includes("/api/v1/pro/subscription/charge/") &&
  82  |       response.url().includes("/execute") &&
  83  |       response.request().method() === "POST"
  84  |     );
  85  |     const executeJson = await executeResponse.json() as Record<string, unknown>;
  86  | 
  87  |     await testInfo.attach("subscription-checkout-execute.json", {
  88  |       body: JSON.stringify(executeJson, null, 2),
  89  |       contentType: "application/json"
  90  |     });
  91  | 
  92  |     expect(executeResponse.ok(), JSON.stringify(executeJson)).toBeTruthy();
  93  | 
  94  |     if ((executeJson.success as boolean | undefined) === true) {
  95  |       await expect(page.locator("body")).toContainText(/Confirmation du paiement en cours|Validation OTP Wizall|En attente de confirmation|mise à niveau est déjà en attente de paiement|Paiement confirmé|Plan actuel/i, {
  96  |         timeout: 15_000
  97  |       });
  98  |       return;
  99  |     }
  100 | 
  101 |     await expect(page.locator("body")).toContainText(String(executeJson.message ?? "Échec du paiement."), { timeout: 15_000 });
  102 |   });
  103 | });
  104 | 
```