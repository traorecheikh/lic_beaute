# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: sprint-full-demo.spec.ts >> Sprint demo — full feature coverage >> 1 · Dhouleymatou dossier: register → admin approve (email triggered)
- Location: tests/e2e/sprint-full-demo.spec.ts:82:3

# Error details

```
Error: Dhouleymatou salon not found in admin list

expect(received).toBeGreaterThan(expected)

Expected: > 0
Received:   0
```

# Page snapshot

```yaml
- generic [active] [ref=e1]:
  - generic:
    - region "Notifications alt+T":
      - list
```

# Test source

```ts
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
  48  |   expect(loginR.ok(), `login failed for ${email}: ${loginR.status()}`).toBeTruthy();
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
  67  |   return apiLogin(page, ctx, "admin@beauteavenue.local", "admin1234", "beauteavenue.admin.session", "/admin/dashboard");
  68  | }
  69  | 
  70  | async function proLogin(page: Page, ctx: BrowserContext, email: string, password: string) {
  71  |   return apiLogin(page, ctx, email, password, "beauteavenue.pro.session", "/pro/calendar");
  72  | }
  73  | 
  74  | // ─── suite ────────────────────────────────────────────────────────────────────
  75  | 
  76  | test.describe("Sprint demo — full feature coverage", () => {
  77  |   test.setTimeout(60_000);
  78  | 
  79  |   // ──────────────────────────────────────────────────────────────────────────
  80  |   // 1. REAL ACTOR: register dhouleymatou150@gmail.com → admin approves → email
  81  |   // ──────────────────────────────────────────────────────────────────────────
  82  |   test("1 · Dhouleymatou dossier: register → admin approve (email triggered)", async ({
  83  |     page, context
  84  |   }) => {
  85  |     await waitForApi(page);
  86  | 
  87  |     const demoEmail = "dhouleymatou150@gmail.com";
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
> 128 |       expect(list.items.length, "Dhouleymatou salon not found in admin list").toBeGreaterThan(0);
      |                                                                               ^ Error: Dhouleymatou salon not found in admin list
  129 |       salonId = list.items[0].id;
  130 | 
  131 |       // Navigate to the detail page directly
  132 |       await page.goto(`/admin/salons/${salonId}`, { waitUntil: "domcontentloaded" });
  133 |       await page.waitForURL(`/admin/salons/${salonId}`, { timeout: 15_000 });
  134 |     });
  135 | 
  136 |     await test.step("Admin approves (triggers confirmation email to dhouleymatou150@gmail.com)", async () => {
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
  149 |           page.getByRole("button", { name: "Confirmer" }).click()
  150 |         ]);
  151 |       }
  152 |     });
  153 | 
  154 |     await test.step("API confirms approvalStatus = approved", async () => {
  155 |       const check = await context.request.get(`${API}/api/v1/admin/salons/${salonId}`, {
  156 |         headers: { authorization: `Bearer ${adminToken}` }
  157 |       });
  158 |       expect(((await check.json()) as { approvalStatus: string }).approvalStatus).toBe("approved");
  159 |     });
  160 | 
  161 |     await test.step("Dhouleymatou logs in to pro panel", async () => {
  162 |       const proPage = await context.newPage();
  163 |       await proLogin(proPage, context, demoEmail, demoPassword);
  164 |       await expect(proPage).toHaveURL(/\/pro\/(calendar|dashboard|approval-status)/);
  165 |       await proPage.close();
  166 |     });
  167 |   });
  168 | 
  169 |   // ──────────────────────────────────────────────────────────────────────────
  170 |   // 2. ADMIN: request-info checklist → reject a fresh dossier
  171 |   // ──────────────────────────────────────────────────────────────────────────
  172 |   test("2 · Admin: request-info checklist → reject", async ({ page, context }) => {
  173 |     await waitForApi(page);
  174 | 
  175 |     const runId = Date.now();
  176 |     const email = `checklist.${runId}@example.sn`;
  177 |     let salonId = "";
  178 | 
  179 |     await test.step("Register test dossier via API", async () => {
  180 |       const r = await context.request.post(`${API}/api/v1/auth/register`, {
  181 |         data: {
  182 |           type: "salon_owner",
  183 |           fullName: "Test Checklist",
  184 |           email,
  185 |           phone: `+22177${String(runId).slice(-7)}`,
  186 |           password: "test1234",
  187 |           salon: { name: `Checklist ${runId}`, category: "Coiffure", city: "Dakar", address: "Dakar", description: "" },
  188 |           services: [{ name: "Soin", durationMinutes: 30, priceXof: 5000, depositMode: "none" }],
  189 |           hours: Array.from({ length: 7 }, (_, i) => ({ dayOfWeek: i, isOpen: true, opensAt: "09:00", closesAt: "18:00" }))
  190 |         }
  191 |       });
  192 |       expect([200, 201]).toContain(r.status());
  193 |     });
  194 | 
  195 |     const adminToken = await adminLogin(page, context);
  196 | 
  197 |     await test.step("Find dossier", async () => {
  198 |       await page.goto("/admin/salons");
  199 |       await page.getByPlaceholder("Enseigne...").fill(`Checklist ${runId}`);
  200 |       await page.waitForTimeout(600);
  201 | 
  202 |       const row = page.locator("article", { hasText: `Checklist ${runId}` }).first();
  203 |       await expect(row).toBeVisible({ timeout: 15_000 });
  204 | 
  205 |       const detailP = page.waitForResponse(
  206 |         (r) => r.url().includes("/api/v1/admin/salons/") && r.request().method() === "GET"
  207 |       );
  208 |       await row.getByRole("link", { name: "Dossier" }).click();
  209 |       salonId = ((await (await detailP).json()) as { id: string }).id;
  210 |     });
  211 | 
  212 |     await test.step("Select request-info and check checklist", async () => {
  213 |       await page.locator('label:has-text("Compléments")').click();
  214 | 
  215 |       const checkboxes = page.locator("input[type='checkbox']");
  216 |       if (await checkboxes.count() > 0) {
  217 |         await checkboxes.first().check();
  218 |       } else {
  219 |         await page.getByPlaceholder("Requis...").fill("Merci de fournir un justificatif NINEA.");
  220 |       }
  221 | 
  222 |       await Promise.all([
  223 |         page.waitForResponse(
  224 |           (r) => r.url().includes(`/api/v1/admin/salons/${salonId}/request-info`) && r.status() === 200
  225 |         ),
  226 |         page.getByRole("button", { name: "Confirmer" }).click()
  227 |       ]);
  228 |     });
```