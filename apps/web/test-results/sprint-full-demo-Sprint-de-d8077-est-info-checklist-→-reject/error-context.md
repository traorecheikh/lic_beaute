# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: sprint-full-demo.spec.ts >> Sprint demo — full feature coverage >> 2 · Admin: request-info checklist → reject
- Location: tests/e2e/sprint-full-demo.spec.ts:172:3

# Error details

```
Test timeout of 60000ms exceeded.
```

```
Error: page.waitForResponse: Test timeout of 60000ms exceeded.
```

# Page snapshot

```yaml
- generic [ref=e2]:
  - region "Notifications alt+T":
    - list
  - generic [ref=e3]:
    - banner [ref=e4]:
      - generic [ref=e5]:
        - link "Beauté Avenue Beauté Avenue" [ref=e6] [cursor=pointer]:
          - /url: /admin/dashboard
          - img "Beauté Avenue" [ref=e7]
          - paragraph [ref=e9]: Beauté Avenue
        - navigation [ref=e10]:
          - link "Pilotage" [ref=e11] [cursor=pointer]:
            - /url: /admin/dashboard
            - img [ref=e12]
            - generic [ref=e14]: Pilotage
          - link "Salons" [ref=e15] [cursor=pointer]:
            - /url: /admin/salons
            - img [ref=e16]
            - generic [ref=e18]: Salons
          - link "Abonnements" [ref=e19] [cursor=pointer]:
            - /url: /admin/subscriptions
            - img [ref=e20]
            - generic [ref=e22]: Abonnements
          - link "Audit log" [ref=e23] [cursor=pointer]:
            - /url: /admin/audit
            - img [ref=e24]
            - generic [ref=e26]: Audit log
          - link "Configuration" [ref=e27] [cursor=pointer]:
            - /url: /admin/config
            - img [ref=e28]
            - generic [ref=e31]: Configuration
          - link "Compte" [ref=e32] [cursor=pointer]:
            - /url: /admin/account
            - img [ref=e33]
            - generic [ref=e35]: Compte
        - generic [ref=e36]:
          - button "0 notifications non lues" [ref=e37]:
            - img [ref=e38]
          - generic [ref=e40]:
            - generic [ref=e41]: CP
            - paragraph [ref=e42]: Cheikh Platform
          - button "Déconnexion" [ref=e43]:
            - img [ref=e44]
            - text: Déconnexion
    - main [ref=e46]:
      - generic [ref=e48]:
        - generic [ref=e49]:
          - heading "Salons" [level=2] [ref=e51]
          - generic [ref=e52]:
            - link "Créer un salon" [ref=e53] [cursor=pointer]:
              - /url: /admin/salons/new
              - img [ref=e54]
              - text: Créer un salon
            - generic [ref=e56]:
              - textbox "Enseigne..." [active] [ref=e57]: Checklist 1779590766266
              - img
            - generic [ref=e58]:
              - textbox "Ville..." [ref=e59]
              - img
            - generic [ref=e60]:
              - combobox [ref=e61]:
                - option "Tous statuts"
                - option "À traiter" [selected]
                - option "Besoin d'infos"
                - option "Approuvé"
                - option "Rejeté"
              - img
        - generic [ref=e62]:
          - paragraph [ref=e63]: 1 dossiers
          - article [ref=e65]:
            - generic [ref=e66]:
              - generic [ref=e67]:
                - heading "Checklist 1779590766266" [level=3] [ref=e68]
                - generic [ref=e69]:
                  - generic [ref=e70]: À traiter
                  - generic [ref=e71]: Standard
              - generic [ref=e72]:
                - generic [ref=e74]: Dakar
                - generic [ref=e76]: Coiffure
                - generic [ref=e78]: "Gérant: Test Checklist"
            - button "Dossier" [ref=e81]:
              - text: Dossier
              - img [ref=e82]
```

# Test source

```ts
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
> 205 |       const detailP = page.waitForResponse(
      |                            ^ Error: page.waitForResponse: Test timeout of 60000ms exceeded.
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
  229 | 
  230 |     await test.step("Reject the dossier", async () => {
  231 |       await page.locator('label:has-text("Rejeter")').click();
  232 |       await page.getByPlaceholder("Requis...").fill("Dossier incomplet après relance.");
  233 | 
  234 |       await Promise.all([
  235 |         page.waitForResponse(
  236 |           (r) => r.url().includes(`/api/v1/admin/salons/${salonId}/reject`) && r.status() === 200
  237 |         ),
  238 |         page.getByRole("button", { name: "Confirmer" }).click()
  239 |       ]);
  240 | 
  241 |       const check = await context.request.get(
  242 |         `${API}/api/v1/admin/salons/${salonId}`,
  243 |         { headers: { authorization: `Bearer ${adminToken}` } }
  244 |       );
  245 |       expect(((await check.json()) as { approvalStatus: string }).approvalStatus).toBe("rejected");
  246 |     });
  247 |   });
  248 | 
  249 |   // ──────────────────────────────────────────────────────────────────────────
  250 |   // 3. ADMIN: audit log filter bar
  251 |   // ──────────────────────────────────────────────────────────────────────────
  252 |   test("3 · Admin: audit log filters (action type + date range)", async ({ page, context }) => {
  253 |     await waitForApi(page);
  254 |     await adminLogin(page, context);
  255 | 
  256 |     await page.goto("/admin/audit");
  257 |     await expect(page.getByRole("heading", { name: "Audit" })).toBeVisible();
  258 |     await page.waitForTimeout(800);
  259 | 
  260 |     await test.step("Filter by action type", async () => {
  261 |       const select = page.locator("select").filter({ hasText: /Toutes|action/i }).first();
  262 |       if (await select.isVisible()) {
  263 |         await select.selectOption("approve");
  264 |         await page.waitForTimeout(500);
  265 |         await expect(page.locator("body")).not.toContainText("Erreur interne");
  266 |       }
  267 |     });
  268 | 
  269 |     await test.step("Filter by date range", async () => {
  270 |       const inputs = page.locator('input[type="date"]');
  271 |       if (await inputs.count() >= 2) {
  272 |         await inputs.first().fill("2026-01-01");
  273 |         await inputs.nth(1).fill("2026-12-31");
  274 |         await page.waitForTimeout(500);
  275 |         await expect(page.locator("body")).not.toContainText("Erreur interne");
  276 |       }
  277 |     });
  278 |   });
  279 | 
  280 |   // ──────────────────────────────────────────────────────────────────────────
  281 |   // 4. ADMIN: config — duplicate category prevention
  282 |   // ──────────────────────────────────────────────────────────────────────────
  283 |   test("4 · Admin: config — duplicate category blocked with inline error", async ({
  284 |     page, context
  285 |   }) => {
  286 |     await waitForApi(page);
  287 |     await adminLogin(page, context);
  288 | 
  289 |     await page.goto("/admin/config");
  290 |     await expect(page.getByRole("heading", { name: "Configuration" })).toBeVisible();
  291 |     await page.waitForTimeout(1_000);
  292 | 
  293 |     const nameInput = page.locator('input[placeholder*="Nom"]').first();
  294 |     if (await nameInput.isVisible()) {
  295 |       await nameInput.fill("Coiffure");
  296 |       const slugInput = page.locator('input[placeholder*="slug"]').first();
  297 |       if (await slugInput.isVisible()) await slugInput.fill("coiffure");
  298 |       await page.getByRole("button", { name: /Ajouter|Créer/i }).click();
  299 |       await expect(page.locator("body")).toContainText(/existe déjà/i, { timeout: 5_000 });
  300 |     }
  301 |   });
  302 | 
  303 |   // ──────────────────────────────────────────────────────────────────────────
  304 |   // 5. PRO: services — add → see → delete with native confirm dialog
  305 |   // ──────────────────────────────────────────────────────────────────────────
```