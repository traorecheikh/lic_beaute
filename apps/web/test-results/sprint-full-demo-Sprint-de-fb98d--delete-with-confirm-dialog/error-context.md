# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: sprint-full-demo.spec.ts >> Sprint demo — full feature coverage >> 5 · Pro services: add new service then delete with confirm dialog
- Location: tests/e2e/sprint-full-demo.spec.ts:306:3

# Error details

```
Test timeout of 60000ms exceeded.
```

```
Error: locator.fill: Test timeout of 60000ms exceeded.
Call log:
  - waiting for getByPlaceholder('Coiffure, Ongles, Spa...')

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
            - paragraph [ref=e10]: Dione Signature
          - navigation [ref=e11]:
            - link "Agenda" [ref=e12] [cursor=pointer]:
              - /url: /pro/calendar
              - img [ref=e13]
              - generic [ref=e15]: Agenda
            - link "Clients" [ref=e16] [cursor=pointer]:
              - /url: /pro/clients
              - img [ref=e17]
              - generic [ref=e19]: Clients
            - link "Ventes" [ref=e20] [cursor=pointer]:
              - /url: /pro/payouts
              - img [ref=e21]
              - generic [ref=e23]: Ventes
            - link "Inbox" [ref=e24] [cursor=pointer]:
              - /url: /pro/bookings/inbox
              - img [ref=e25]
              - generic [ref=e27]: Inbox
            - link "Rapports" [ref=e28] [cursor=pointer]:
              - /url: /pro/analytics
              - img [ref=e29]
              - generic [ref=e31]: Rapports
            - link "Services" [ref=e32] [cursor=pointer]:
              - /url: /pro/salon/services
              - img [ref=e33]
              - generic [ref=e35]: Services
          - generic [ref=e36]:
            - link "Contacter le support via WhatsApp" [ref=e37] [cursor=pointer]:
              - /url: https://wa.me/221338671010
              - img [ref=e38]
            - button "0 notifications non lues" [ref=e40]:
              - img [ref=e41]
            - generic [ref=e44]:
              - generic [ref=e45]:
                - paragraph [ref=e46]: Aïda Dione
                - paragraph [ref=e47]: Propriétaire
              - button "AD" [ref=e49]
      - main [ref=e50]:
        - generic [ref=e52]:
          - generic [ref=e53]:
            - generic [ref=e54]:
              - heading "Prestations" [level=1] [ref=e55]
              - paragraph [ref=e56]: Gérez votre menu de services, vos tarifs et vos acomptes.
            - button "Nouvelle prestation" [ref=e57]:
              - img [ref=e58]
              - text: Nouvelle prestation
          - generic [ref=e60]:
            - button "Tout voir" [ref=e61]
            - button "general" [ref=e62]
          - generic [ref=e64]:
            - heading "general" [level=2] [ref=e65]
            - generic [ref=e66]:
              - generic [ref=e67]:
                - generic [ref=e68]:
                  - img [ref=e70]
                  - generic [ref=e72]:
                    - paragraph [ref=e73]: Brushing
                    - generic [ref=e74]:
                      - generic [ref=e75]:
                        - img [ref=e76]
                        - text: 45 min
                      - generic [ref=e79]: 12 000 F CFA
                - generic [ref=e80]:
                  - generic [ref=e81]:
                    - paragraph [ref=e82]: Acompte
                    - paragraph [ref=e83]: 3 000 F CFA
                  - generic [ref=e84]:
                    - button [ref=e85]:
                      - img [ref=e86]
                    - button [ref=e88]:
                      - img [ref=e89]
              - generic [ref=e91]:
                - generic [ref=e92]:
                  - img [ref=e94]
                  - generic [ref=e96]:
                    - paragraph [ref=e97]: Balayage
                    - generic [ref=e98]:
                      - generic [ref=e99]:
                        - img [ref=e100]
                        - text: 120 min
                      - generic [ref=e103]: 45 000 F CFA
                - generic [ref=e104]:
                  - generic [ref=e105]:
                    - paragraph [ref=e106]: Acompte
                    - paragraph [ref=e107]: 10 000 F CFA
                  - generic [ref=e108]:
                    - button [ref=e109]:
                      - img [ref=e110]
                    - button [ref=e112]:
                      - img [ref=e113]
              - generic [ref=e115]:
                - generic [ref=e116]:
                  - img [ref=e118]
                  - generic [ref=e120]:
                    - paragraph [ref=e121]: Soin kératine
                    - generic [ref=e122]:
                      - generic [ref=e123]:
                        - img [ref=e124]
                        - text: 90 min
                      - generic [ref=e127]: 35 000 F CFA
                - generic [ref=e129]:
                  - button [ref=e130]:
                    - img [ref=e131]
                  - button [ref=e133]:
                    - img [ref=e134]
              - generic [ref=e136]:
                - generic [ref=e137]:
                  - img [ref=e139]
                  - generic [ref=e141]:
                    - paragraph [ref=e142]: Coupe & Coiffage
                    - generic [ref=e143]:
                      - generic [ref=e144]:
                        - img [ref=e145]
                        - text: 60 min
                      - generic [ref=e148]: 15 000 F CFA
                - generic [ref=e150]:
                  - button [ref=e151]:
                    - img [ref=e152]
                  - button [ref=e154]:
                    - img [ref=e155]
  - generic [ref=e159]:
    - generic [ref=e160]:
      - generic [ref=e161]:
        - generic [ref=e162]:
          - heading "Nouvelle prestation" [level=3] [ref=e163]
          - paragraph [ref=e164]: Étape 1 sur 3
        - button [ref=e165]:
          - img [ref=e166]
      - generic [ref=e168]:
        - generic [ref=e169]:
          - generic [ref=e171]: "1"
          - generic [ref=e172]: Identité
        - generic [ref=e174]:
          - generic [ref=e176]: "2"
          - generic [ref=e177]: Tarification
        - generic [ref=e179]:
          - generic [ref=e181]: "3"
          - generic [ref=e182]: Acompte
    - generic [ref=e184]:
      - generic [ref=e185]:
        - generic [ref=e186]:
          - generic [ref=e187]: Nom de la prestation
          - 'textbox "ex: Brushing + Soin profond" [active] [ref=e188]': Soin Test 1779590838207
        - generic [ref=e189]:
          - generic [ref=e190]: Catégorie
          - 'combobox "ex: Coiffure, Ongles, Soins…" [ref=e191]'
          - paragraph [ref=e192]: La catégorie regroupe vos prestations dans votre catalogue.
      - generic [ref=e193]:
        - button "Annuler" [ref=e194]
        - button "Continuer →" [disabled] [ref=e195]
```

# Test source

```ts
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
  306 |   test("5 · Pro services: add new service then delete with confirm dialog", async ({
  307 |     page, context
  308 |   }) => {
  309 |     await waitForApi(page);
  310 |     await proLogin(page, context, "aida@dionesignature.sn", "salon1234");
  311 | 
  312 |     await page.goto("/pro/salon/services");
  313 |     await page.waitForTimeout(1_000);
  314 | 
  315 |     const svcName = `Soin Test ${Date.now()}`;
  316 | 
  317 |     await test.step("Open create form", async () => {
  318 |       await page.getByRole("button", { name: /Nouvelle prestation/i }).click();
  319 |       await expect(page.getByPlaceholder("Brushing + soin")).toBeVisible({ timeout: 8_000 });
  320 |     });
  321 | 
  322 |     await test.step("Fill and submit", async () => {
  323 |       await page.getByPlaceholder("Brushing + soin").fill(svcName);
  324 |       // Category is required by form validation — must be filled or submit returns early
> 325 |       await page.getByPlaceholder("Coiffure, Ongles, Spa...").fill("Coiffure");
      |                                                               ^ Error: locator.fill: Test timeout of 60000ms exceeded.
  326 |       await page.locator('input[type="number"]').first().fill("45");
  327 |       await page.locator('input[type="number"]').nth(1).fill("12000");
  328 | 
  329 |       await Promise.all([
  330 |         page.waitForResponse(
  331 |           (r) => r.url().includes("/api/v1/pro/services") && [200, 201].includes(r.status()),
  332 |           { timeout: 15_000 }
  333 |         ),
  334 |         page.getByRole("button", { name: /Créer la prestation/i }).click()
  335 |       ]);
  336 |     });
  337 | 
  338 |     await test.step("New service appears in list", async () => {
  339 |       await expect(page.getByText(svcName)).toBeVisible({ timeout: 10_000 });
  340 |     });
  341 | 
  342 |     await test.step("Delete removes item (confirm dialog auto-accepted)", async () => {
  343 |       const row = page.locator("tr", { hasText: svcName }).first();
  344 |       await row.hover();
  345 |       await page.waitForTimeout(300);
  346 | 
  347 |       // Override window.confirm AND fire the button click in a single synchronous
  348 |       // evaluate call — this avoids any event-loop race between the confirm override
  349 |       // and the native dialog being auto-dismissed by Playwright.
  350 |       const deleteResp = page.waitForResponse(
  351 |         (r) => r.url().includes("/api/v1/pro/services") && r.request().method() === "DELETE",
  352 |         { timeout: 15_000 }
  353 |       );
  354 |       await page.evaluate((name) => {
  355 |         (window as any).confirm = () => true;
  356 |         const trs = Array.from(document.querySelectorAll("tr"));
  357 |         const tr = trs.find((r) => r.textContent?.includes(name));
  358 |         if (tr) {
  359 |           const btns = tr.querySelectorAll("button");
  360 |           if (btns.length >= 2) (btns[1] as HTMLButtonElement).click();
  361 |         }
  362 |       }, svcName);
  363 |       await deleteResp;
  364 | 
  365 |       await expect(page.getByText(svcName)).not.toBeVisible({ timeout: 8_000 });
  366 |     });
  367 |   });
  368 | 
  369 |   // ──────────────────────────────────────────────────────────────────────────
  370 |   // 6. PRO: subscription page — gracePeriodEndsAt present in API response
  371 |   // ──────────────────────────────────────────────────────────────────────────
  372 |   test("6 · Pro subscription: gracePeriodEndsAt field in API response", async ({
  373 |     page, context
  374 |   }) => {
  375 |     await waitForApi(page);
  376 | 
  377 |     const loginR = await context.request.post(`${API}/api/v1/auth/login`, {
  378 |       data: { email: "aida@dionesignature.sn", password: "salon1234" }
  379 |     });
  380 |     const { accessToken } = await loginR.json() as { accessToken: string };
  381 | 
  382 |     const subR = await context.request.get(`${API}/api/v1/pro/subscription`, {
  383 |       headers: { authorization: `Bearer ${accessToken}` }
  384 |     });
  385 |     expect(subR.ok()).toBeTruthy();
  386 |     const payload = await subR.json() as Record<string, unknown>;
  387 |     expect("gracePeriodEndsAt" in payload).toBeTruthy();
  388 |   });
  389 | 
  390 |   // ──────────────────────────────────────────────────────────────────────────
  391 |   // 7. PRO: grace banner visible for Seynabou (past_due + gracePeriodEndsAt set)
  392 |   // ──────────────────────────────────────────────────────────────────────────
  393 |   test("7 · Pro grace banner: past_due salon sees expiry warning", async ({
  394 |     page, context
  395 |   }) => {
  396 |     await waitForApi(page);
  397 | 
  398 |     await proLogin(page, context, "seynabou@epilexpress.sn", "salon1234");
  399 | 
  400 |     // Reload to trigger a fresh subscription query — proLogin may land before
  401 |     // ProLayout fires the query, so a reload guarantees it happens while we watch.
  402 |     const subResponse = page.waitForResponse(
  403 |       (r) => r.url().includes("/api/v1/pro/subscription") && r.ok(),
  404 |       { timeout: 20_000 }
  405 |     );
  406 |     await page.reload({ waitUntil: "domcontentloaded" });
  407 |     await subResponse;
  408 |     await page.waitForTimeout(800); // Vue reactivity + TanStack Query state
  409 | 
  410 |     await test.step("Grace banner is visible", async () => {
  411 |       await expect(page.locator('[data-testid="grace-banner"]')).toBeVisible({ timeout: 10_000 });
  412 |     });
  413 |   });
  414 | 
  415 |   // ──────────────────────────────────────────────────────────────────────────
  416 |   // 8. PRO: calendar renders for owner
  417 |   // ──────────────────────────────────────────────────────────────────────────
  418 |   test("8 · Pro calendar: owner view loads without errors", async ({ page, context }) => {
  419 |     await waitForApi(page);
  420 |     await proLogin(page, context, "aida@dionesignature.sn", "salon1234");
  421 | 
  422 |     await page.goto("/pro/calendar");
  423 |     await page.waitForTimeout(1_000);
  424 |     await expect(page.locator("body")).not.toContainText("Erreur interne");
  425 |   });
```