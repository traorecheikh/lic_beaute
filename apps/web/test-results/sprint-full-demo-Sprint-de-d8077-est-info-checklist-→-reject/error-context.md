# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: sprint-full-demo.spec.ts >> Sprint demo — full feature coverage >> 2 · Admin: request-info checklist → reject
- Location: tests/e2e/sprint-full-demo.spec.ts:172:3

# Error details

```
Test timeout of 120000ms exceeded.
```

```
Error: page.waitForResponse: Test timeout of 120000ms exceeded.
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
          - link "Versements" [ref=e23] [cursor=pointer]:
            - /url: /admin/payouts
            - img [ref=e24]
            - generic [ref=e26]: Versements
          - link "Audit log" [ref=e27] [cursor=pointer]:
            - /url: /admin/audit
            - img [ref=e28]
            - generic [ref=e30]: Audit log
          - link "Configuration" [ref=e31] [cursor=pointer]:
            - /url: /admin/config
            - img [ref=e32]
            - generic [ref=e35]: Configuration
          - link "Compte" [ref=e36] [cursor=pointer]:
            - /url: /admin/account
            - img [ref=e37]
            - generic [ref=e39]: Compte
        - generic [ref=e40]:
          - button "19" [ref=e41]:
            - img [ref=e42]
            - generic [ref=e44]: "19"
          - generic [ref=e45]:
            - generic [ref=e46]: CP
            - paragraph [ref=e47]: Cheikh Platform
          - button "Déconnexion" [ref=e48]:
            - img [ref=e49]
            - text: Déconnexion
    - main [ref=e51]:
      - generic [ref=e53]:
        - generic [ref=e54]:
          - link "Retour à la file" [ref=e55] [cursor=pointer]:
            - /url: /admin/salons
            - img [ref=e56]
            - text: Retour à la file
          - generic [ref=e58]:
            - paragraph [ref=e59]: "Dossier:"
            - paragraph [ref=e60]: cmqiktoi
        - article [ref=e61]:
          - generic [ref=e62]:
            - generic [ref=e63]:
              - generic [ref=e64]:
                - heading "Checklist 1781731319078" [level=2] [ref=e65]
                - generic [ref=e66]: Infos requises
                - generic [ref=e67]: Standard
              - generic [ref=e68]:
                - generic [ref=e69]:
                  - img [ref=e70]
                  - generic [ref=e73]: Dakar, Dakar
                - generic [ref=e74]:
                  - img [ref=e75]
                  - generic [ref=e77]: Coiffure
            - generic [ref=e79]:
              - paragraph [ref=e80]: Inscrit le
              - paragraph [ref=e81]: 17 juin 2026 · 21:21
          - generic [ref=e82]:
            - paragraph
          - generic [ref=e83]:
            - generic [ref=e84]:
              - paragraph [ref=e85]: Identité Gérant
              - paragraph [ref=e86]: Test Checklist
            - generic [ref=e87]:
              - paragraph [ref=e88]: Téléphone
              - paragraph [ref=e89]: "+221771319078"
            - generic [ref=e90]:
              - paragraph [ref=e91]: E-mail
              - paragraph [ref=e92]: checklist.1781731319078@example.sn
            - generic [ref=e93]:
              - paragraph [ref=e94]: Date Soumission
              - paragraph [ref=e95]: 17 juin 2026 · 21:21
        - generic [ref=e96]:
          - generic [ref=e99]:
            - heading "Pièces Justificatives" [level=3] [ref=e100]
            - generic [ref=e101]: 0 documents
          - generic [ref=e102]:
            - heading "Visuels Salon" [level=3] [ref=e104]
            - generic [ref=e105]:
              - generic [ref=e106]:
                - heading "Catalogue Services" [level=3] [ref=e107]
                - button "Ajouter" [ref=e108]:
                  - img [ref=e109]
                  - text: Ajouter
              - article [ref=e112]:
                - generic [ref=e113]:
                  - paragraph [ref=e114]: Soin
                  - paragraph [ref=e115]: 30 min • 5 000 F CFA
                - generic [ref=e116]:
                  - generic [ref=e117]: Aucun
                  - button [ref=e118]:
                    - img [ref=e119]
                  - button [ref=e121]:
                    - img [ref=e122]
        - generic [ref=e126]:
          - generic [ref=e127]:
            - heading "Verdict Final" [level=3] [ref=e128]
            - heading "Enregistrer une décision système" [level=4] [ref=e129]
            - paragraph [ref=e130]: Action irréversible notifiée au gérant.
          - generic [ref=e131]:
            - generic [ref=e132]:
              - text: Action
              - generic [ref=e133]:
                - generic [ref=e134] [cursor=pointer]:
                  - radio "Approuver" [checked] [ref=e135]
                  - img [ref=e136]
                  - generic [ref=e138]: Approuver
                - generic [ref=e139] [cursor=pointer]:
                  - radio "Compléments" [ref=e140]
                  - img [ref=e141]
                  - generic [ref=e143]: Compléments
                - generic [ref=e144] [cursor=pointer]:
                  - radio "Rejeter" [ref=e145]
                  - img [ref=e146]
                  - generic [ref=e148]: Rejeter
            - generic [ref=e149]:
              - text: Motif
              - textbox "Motif" [ref=e150]:
                - /placeholder: Optionnel...
            - generic [ref=e151]:
              - generic [ref=e152]: Validation par Cheikh Platform
              - generic [ref=e153]:
                - button "Réinitialiser" [ref=e154]
                - button "Confirmer" [ref=e155]
```

# Test source

```ts
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
  208 |       await row.getByRole("button", { name: "Dossier" }).click();
  209 |       await page.getByRole("link", { name: "Voir le dossier" }).first().click();
  210 |       salonId = ((await (await detailP).json()) as { id: string }).id;
  211 |     });
  212 | 
  213 |     await test.step("Select request-info and check checklist", async () => {
  214 |       await page.locator('label:has-text("Compléments")').click();
  215 | 
  216 |       const checkboxes = page.locator("input[type='checkbox']");
  217 |       if (await checkboxes.count() > 0) {
  218 |         await checkboxes.first().check();
  219 |       } else {
  220 |         await page.getByPlaceholder("Requis...").fill("Merci de fournir un justificatif NINEA.");
  221 |       }
  222 | 
  223 |       await Promise.all([
> 224 |         page.waitForResponse(
      |              ^ Error: page.waitForResponse: Test timeout of 120000ms exceeded.
  225 |           (r) => r.url().includes(`/api/v1/admin/salons/${salonId}/request-info`) && r.status() === 200
  226 |         ),
  227 |         page.getByRole("button", { name: "Confirmer" }).click()
  228 |       ]);
  229 |     });
  230 | 
  231 |     await test.step("Reject the dossier", async () => {
  232 |       // Let the page re-fetch salon data after the request-info mutation before interacting
  233 |       await page.waitForTimeout(1_500);
  234 |       await page.locator('label:has-text("Rejeter")').click();
  235 |       await page.getByPlaceholder("Requis...").fill("Dossier incomplet après relance.");
  236 | 
  237 |       await Promise.all([
  238 |         page.waitForResponse(
  239 |           (r) => r.url().includes(`/api/v1/admin/salons/${salonId}/reject`) && r.status() === 200
  240 |         ),
  241 |         page.getByRole("button", { name: "Confirmer" }).click()
  242 |       ]);
  243 | 
  244 |       const check = await context.request.get(
  245 |         `${API}/api/v1/admin/salons/${salonId}`,
  246 |         { headers: { authorization: `Bearer ${adminToken}` } }
  247 |       );
  248 |       expect(((await check.json()) as { approvalStatus: string }).approvalStatus).toBe("rejected");
  249 |     });
  250 |   });
  251 | 
  252 |   // ──────────────────────────────────────────────────────────────────────────
  253 |   // 3. ADMIN: audit log filter bar
  254 |   // ──────────────────────────────────────────────────────────────────────────
  255 |   test("3 · Admin: audit log filters (action type + date range)", async ({ page, context }) => {
  256 |     await waitForApi(page);
  257 |     await adminLogin(page, context);
  258 | 
  259 |     await page.goto("/admin/audit");
  260 |     await expect(page.getByRole("heading", { name: "Audit" })).toBeVisible();
  261 |     await page.waitForTimeout(800);
  262 | 
  263 |     await test.step("Filter by action type", async () => {
  264 |       const select = page.locator("select").filter({ hasText: /Toutes|action/i }).first();
  265 |       if (await select.isVisible()) {
  266 |         await select.selectOption("approve");
  267 |         await page.waitForTimeout(500);
  268 |         await expect(page.locator("body")).not.toContainText("Erreur interne");
  269 |       }
  270 |     });
  271 | 
  272 |     await test.step("Filter by date range", async () => {
  273 |       const inputs = page.locator('input[type="date"]');
  274 |       if (await inputs.count() >= 2) {
  275 |         await inputs.first().fill("2026-01-01");
  276 |         await inputs.nth(1).fill("2026-12-31");
  277 |         await page.waitForTimeout(500);
  278 |         await expect(page.locator("body")).not.toContainText("Erreur interne");
  279 |       }
  280 |     });
  281 |   });
  282 | 
  283 |   // ──────────────────────────────────────────────────────────────────────────
  284 |   // 4. ADMIN: config — duplicate category prevention
  285 |   // ──────────────────────────────────────────────────────────────────────────
  286 |   test("4 · Admin: config — duplicate category blocked with inline error", async ({
  287 |     page, context
  288 |   }) => {
  289 |     await waitForApi(page);
  290 |     await adminLogin(page, context);
  291 | 
  292 |     await page.goto("/admin/config");
  293 |     await expect(page.getByRole("heading", { name: "Configuration" })).toBeVisible();
  294 |     await page.waitForTimeout(1_000);
  295 | 
  296 |     const nameInput = page.locator('input[placeholder*="Nom"]').first();
  297 |     if (await nameInput.isVisible()) {
  298 |       await nameInput.fill("Coiffure");
  299 |       const slugInput = page.locator('input[placeholder*="slug"]').first();
  300 |       if (await slugInput.isVisible()) await slugInput.fill("coiffure");
  301 |       await page.getByRole("button", { name: /Ajouter|Créer/i }).click();
  302 |       await expect(page.locator("body")).toContainText(/existe déjà/i, { timeout: 5_000 });
  303 |     }
  304 |   });
  305 | 
  306 |   // ──────────────────────────────────────────────────────────────────────────
  307 |   // 5. PRO: services — add → see → delete with native confirm dialog
  308 |   // ──────────────────────────────────────────────────────────────────────────
  309 |   test("5 · Pro services: add new service then delete with confirm dialog", async ({
  310 |     page, context
  311 |   }) => {
  312 |     await waitForApi(page);
  313 |     await proLogin(page, context, "aida@dionesignature.sn", "salon1234");
  314 | 
  315 |     await page.goto("/pro/salon/services");
  316 |     await page.waitForTimeout(1_000);
  317 | 
  318 |     const svcName = `Soin Test ${Date.now()}`;
  319 | 
  320 |     await test.step("Open create form", async () => {
  321 |       await page.getByRole("button", { name: /Nouvelle prestation/i }).click();
  322 |       await expect(page.getByPlaceholder("ex: Brushing + Soin profond")).toBeVisible({ timeout: 8_000 });
  323 |     });
  324 | 
```