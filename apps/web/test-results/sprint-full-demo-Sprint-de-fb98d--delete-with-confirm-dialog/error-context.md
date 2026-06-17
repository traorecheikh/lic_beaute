# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: sprint-full-demo.spec.ts >> Sprint demo — full feature coverage >> 5 · Pro services: add new service then delete with confirm dialog
- Location: tests/e2e/sprint-full-demo.spec.ts:309:3

# Error details

```
Error: expect(locator).toBeVisible() failed

Locator: getByPlaceholder('ex: Brushing + Soin profond')
Expected: visible
Timeout: 8000ms
Error: element(s) not found

Call log:
  - Expect "toBeVisible" with timeout 8000ms
  - waiting for getByPlaceholder('ex: Brushing + Soin profond')

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
          - link "Beauté Avenue Dione Signature" [ref=e7] [cursor=pointer]:
            - /url: /pro/calendar
            - img "Beauté Avenue" [ref=e8]
            - paragraph [ref=e11]: Dione Signature
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
                - paragraph [ref=e49]: Aïda Dione
                - paragraph [ref=e50]: Propriétaire
              - button "AD" [ref=e52]
      - main [ref=e53]:
        - generic [ref=e55]:
          - generic [ref=e56]:
            - generic [ref=e57]:
              - heading "Prestations" [level=1] [ref=e58]
              - paragraph [ref=e59]: Gérez votre menu de services, vos tarifs et vos acomptes.
            - button "Nouvelle prestation" [active] [ref=e60]:
              - img [ref=e61]
              - text: Nouvelle prestation
          - generic [ref=e63]:
            - button "Tout voir" [ref=e64]
            - button "general" [ref=e65]
          - generic [ref=e67]:
            - heading "general" [level=2] [ref=e68]
            - generic [ref=e69]:
              - generic [ref=e70]:
                - generic [ref=e71]:
                  - img [ref=e73]
                  - generic [ref=e75]:
                    - paragraph [ref=e76]: Brushing
                    - generic [ref=e77]:
                      - generic [ref=e78]:
                        - img [ref=e79]
                        - text: 45 min
                      - generic [ref=e82]: 12 000 F CFA
                    - generic [ref=e83]:
                      - generic [ref=e84]: Acompte 200 F CFA
                      - generic [ref=e85]: déduit du total
                - generic [ref=e86]:
                  - generic [ref=e87]:
                    - paragraph [ref=e88]: Acompte
                    - paragraph [ref=e89]: 200 F CFA
                  - generic [ref=e90]:
                    - button [ref=e91]:
                      - img [ref=e92]
                    - button [ref=e94]:
                      - img [ref=e95]
              - generic [ref=e97]:
                - generic [ref=e98]:
                  - img [ref=e100]
                  - generic [ref=e102]:
                    - paragraph [ref=e103]: Balayage
                    - generic [ref=e104]:
                      - generic [ref=e105]:
                        - img [ref=e106]
                        - text: 120 min
                      - generic [ref=e109]: 45 000 F CFA
                    - generic [ref=e110]:
                      - generic [ref=e111]: Acompte 200 F CFA
                      - generic [ref=e112]: déduit du total
                - generic [ref=e113]:
                  - generic [ref=e114]:
                    - paragraph [ref=e115]: Acompte
                    - paragraph [ref=e116]: 200 F CFA
                  - generic [ref=e117]:
                    - button [ref=e118]:
                      - img [ref=e119]
                    - button [ref=e121]:
                      - img [ref=e122]
              - generic [ref=e124]:
                - generic [ref=e125]:
                  - img [ref=e127]
                  - generic [ref=e129]:
                    - paragraph [ref=e130]: Soin kératine
                    - generic [ref=e131]:
                      - generic [ref=e132]:
                        - img [ref=e133]
                        - text: 90 min
                      - generic [ref=e136]: 35 000 F CFA
                    - generic [ref=e137]:
                      - generic [ref=e138]: Acompte 200 F CFA
                      - generic [ref=e139]: déduit du total
                - generic [ref=e140]:
                  - generic [ref=e141]:
                    - paragraph [ref=e142]: Acompte
                    - paragraph [ref=e143]: 200 F CFA
                  - generic [ref=e144]:
                    - button [ref=e145]:
                      - img [ref=e146]
                    - button [ref=e148]:
                      - img [ref=e149]
              - generic [ref=e151]:
                - generic [ref=e152]:
                  - img [ref=e154]
                  - generic [ref=e156]:
                    - paragraph [ref=e157]: Coupe & Coiffage
                    - generic [ref=e158]:
                      - generic [ref=e159]:
                        - img [ref=e160]
                        - text: 60 min
                      - generic [ref=e163]: 15 000 F CFA
                    - generic [ref=e164]:
                      - generic [ref=e165]: Acompte 200 F CFA
                      - generic [ref=e166]: déduit du total
                - generic [ref=e167]:
                  - generic [ref=e168]:
                    - paragraph [ref=e169]: Acompte
                    - paragraph [ref=e170]: 200 F CFA
                  - generic [ref=e171]:
                    - button [ref=e172]:
                      - img [ref=e173]
                    - button [ref=e175]:
                      - img [ref=e176]
  - generic [ref=e180]:
    - generic [ref=e181]:
      - generic [ref=e182]:
        - generic [ref=e183]:
          - heading "Nouvelle prestation" [level=3] [ref=e184]
          - paragraph [ref=e185]: Étape 1 sur 3
        - button [ref=e186]:
          - img [ref=e187]
      - generic [ref=e189]:
        - generic [ref=e190]:
          - generic [ref=e192]: "1"
          - generic [ref=e193]: Identité
        - generic [ref=e195]:
          - generic [ref=e197]: "2"
          - generic [ref=e198]: Tarification
        - generic [ref=e200]:
          - generic [ref=e202]: "3"
          - generic [ref=e203]: Acompte
    - generic [ref=e205]:
      - generic [ref=e207]:
        - generic [ref=e208]: Nom de la prestation
        - textbox "Recherchez ou sélectionnez une prestation…" [ref=e210]
        - paragraph [ref=e211]: Sélectionnez une prestation dans la liste pour définir automatiquement sa catégorie.
      - generic [ref=e212]:
        - button "Annuler" [ref=e213]
        - button "Continuer →" [disabled] [ref=e214]
```

# Test source

```ts
  222 | 
  223 |       await Promise.all([
  224 |         page.waitForResponse(
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
> 322 |       await expect(page.getByPlaceholder("ex: Brushing + Soin profond")).toBeVisible({ timeout: 8_000 });
      |                                                                          ^ Error: expect(locator).toBeVisible() failed
  323 |     });
  324 | 
  325 |     await test.step("Fill and submit (multi-step wizard)", async () => {
  326 |       // Step 1: Identity
  327 |       await page.getByPlaceholder("ex: Brushing + Soin profond").fill(svcName);
  328 |       await page.getByPlaceholder("ex: Coiffure, Ongles, Soins…").fill("Coiffure");
  329 |       await page.getByRole("button", { name: "Continuer →" }).click();
  330 | 
  331 |       // Step 2: Pricing
  332 |       await page.waitForTimeout(400);
  333 |       await page.locator('input[type="number"]').first().fill("45");
  334 |       await page.locator('input[type="number"]').nth(1).fill("12000");
  335 | 
  336 |       // Set up the response listener before the final click(s).
  337 |       // nextStep() at step 2: if depositsAvailable→step 3, else submitService() directly.
  338 |       // So "Continuer →" may itself fire the POST — listener must be ready before the click.
  339 |       const serviceCreateResp = page.waitForResponse(
  340 |         (r) => r.url().includes("/api/v1/pro/services") && [200, 201].includes(r.status()),
  341 |         { timeout: 20_000 }
  342 |       );
  343 |       await page.getByRole("button", { name: "Continuer →" }).click();
  344 | 
  345 |       // If we advanced to step 3 (depositsAvailable=true), an explicit submit button appears
  346 |       const submitBtn = page.getByRole("button", { name: /Ajouter à ma carte/i });
  347 |       const onStep3 = await submitBtn.isVisible({ timeout: 2_000 }).catch(() => false);
  348 |       if (onStep3) await submitBtn.click();
  349 | 
  350 |       await serviceCreateResp;
  351 | 
  352 |       // Wait for the create form to close: Vue onSuccess → cancelCreateService()
  353 |       await page.getByRole("heading", { name: "Nouvelle prestation" }).waitFor({ state: "detached", timeout: 10_000 });
  354 |     });
  355 | 
  356 |     await test.step("New service appears in list", async () => {
  357 |       await expect(page.getByText(svcName)).toBeVisible({ timeout: 10_000 });
  358 |     });
  359 | 
  360 |     await test.step("Delete removes item (native window.confirm dialog)", async () => {
  361 |       // Allow background Vue Query refetch to settle after create
  362 |       await page.waitForTimeout(1_500);
  363 | 
  364 |       // Use filter+exact match for the specific service card
  365 |       const card = page.locator("div.panel-clean").filter({
  366 |         has: page.getByText(svcName, { exact: true })
  367 |       });
  368 |       await expect(card).toBeVisible({ timeout: 10_000 });
  369 | 
  370 |       // Register dialog handler BEFORE click — prod uses window.confirm(), not a Vue modal
  371 |       const deleteResp = page.waitForResponse(
  372 |         (r) => r.url().includes("/api/v1/pro/services") && r.request().method() === "DELETE",
  373 |         { timeout: 15_000 }
  374 |       );
  375 |       page.once("dialog", (dialog) => dialog.accept());
  376 |       await card.locator("button").last().click();
  377 |       await deleteResp;
  378 | 
  379 |       await expect(page.getByText(svcName)).not.toBeVisible({ timeout: 8_000 });
  380 |     });
  381 |   });
  382 | 
  383 |   // ──────────────────────────────────────────────────────────────────────────
  384 |   // 6. PRO: subscription page — gracePeriodEndsAt present in API response
  385 |   // ──────────────────────────────────────────────────────────────────────────
  386 |   test("6 · Pro subscription: gracePeriodEndsAt field in API response", async ({
  387 |     page, context
  388 |   }) => {
  389 |     await waitForApi(page);
  390 | 
  391 |     const loginR = await context.request.post(`${API}/api/v1/auth/login`, {
  392 |       data: { email: "aida@dionesignature.sn", password: "salon1234" }
  393 |     });
  394 |     const { accessToken } = await loginR.json() as { accessToken: string };
  395 | 
  396 |     const subR = await context.request.get(`${API}/api/v1/pro/subscription`, {
  397 |       headers: { authorization: `Bearer ${accessToken}` }
  398 |     });
  399 |     expect(subR.ok()).toBeTruthy();
  400 |     const payload = await subR.json() as Record<string, unknown>;
  401 |     expect("gracePeriodEndsAt" in payload).toBeTruthy();
  402 |   });
  403 | 
  404 |   // ──────────────────────────────────────────────────────────────────────────
  405 |   // 7. PRO: grace banner visible for Seynabou (past_due + gracePeriodEndsAt set)
  406 |   // ──────────────────────────────────────────────────────────────────────────
  407 |   test("7 · Pro grace banner: subscription API returns gracePeriodEndsAt field", async ({
  408 |     page, context
  409 |   }) => {
  410 |     await waitForApi(page);
  411 | 
  412 |     // Use direct API call — waitForResponse would catch /subscription/features first
  413 |     const loginR = await context.request.post(`${API}/api/v1/auth/login`, {
  414 |       data: { email: "seynabou@epilexpress.sn", password: "salon1234" }
  415 |     });
  416 |     expect(loginR.ok(), "seynabou login failed").toBeTruthy();
  417 |     const { accessToken } = await loginR.json() as { accessToken: string };
  418 | 
  419 |     const subR = await context.request.get(`${API}/api/v1/pro/subscription`, {
  420 |       headers: { authorization: `Bearer ${accessToken}` }
  421 |     });
  422 |     expect(subR.ok()).toBeTruthy();
```