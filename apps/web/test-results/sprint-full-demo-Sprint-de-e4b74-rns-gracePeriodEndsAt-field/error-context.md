# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: sprint-full-demo.spec.ts >> Sprint demo — full feature coverage >> 7 · Pro grace banner: subscription API returns gracePeriodEndsAt field
- Location: tests/e2e/sprint-full-demo.spec.ts:407:3

# Error details

```
Error: expect(received).not.toBe(expected) // Object.is equality

Expected: not "past_due"
```

# Page snapshot

```yaml
- generic [ref=e2]:
  - region "Notifications alt+T":
    - list
  - generic [ref=e3]:
    - banner [ref=e4]:
      - generic [ref=e5]:
        - link "Beauté Avenue Épil Express" [ref=e7] [cursor=pointer]:
          - /url: /pro/calendar
          - img "Beauté Avenue" [ref=e8]
          - paragraph [ref=e11]: Épil Express
        - navigation [ref=e12]:
          - link "Agenda" [ref=e13] [cursor=pointer]:
            - /url: /pro/calendar
            - img [ref=e14]
            - generic [ref=e16]: Agenda
          - link "Clients" [ref=e17] [cursor=pointer]:
            - /url: /pro/clients
            - img [ref=e18]
            - generic [ref=e20]: Clients
          - link "Ventes" [ref=e21] [cursor=pointer]:
            - /url: /pro/payouts
            - img [ref=e22]
            - generic [ref=e24]: Ventes
          - link "Inbox" [ref=e25] [cursor=pointer]:
            - /url: /pro/bookings/inbox
            - img [ref=e26]
            - generic [ref=e28]: Inbox
          - link "Rapports" [ref=e29] [cursor=pointer]:
            - /url: /pro/analytics
            - img [ref=e30]
            - generic [ref=e32]: Rapports
          - link "Services" [ref=e33] [cursor=pointer]:
            - /url: /pro/salon/services
            - img [ref=e34]
            - generic [ref=e36]: Services
        - generic [ref=e37]:
          - link "Contacter le support via WhatsApp" [ref=e38] [cursor=pointer]:
            - /url: https://wa.me/221338671010
            - img [ref=e39]
          - button "0 notifications non lues" [ref=e41]:
            - img [ref=e42]
          - generic [ref=e45]:
            - generic [ref=e46]:
              - paragraph [ref=e47]: Seynabou Diallo
              - paragraph [ref=e48]: Propriétaire
            - button "SD" [ref=e50]
    - main [ref=e51]:
      - generic [ref=e53]:
        - generic [ref=e55]:
          - heading "Abonnement & Facturation" [level=1] [ref=e56]
          - paragraph [ref=e57]: Gérez votre plan, vos factures et votre mode de paiement.
        - generic [ref=e58]:
          - generic [ref=e59]:
            - paragraph [ref=e60]: Plan actuel
            - paragraph [ref=e61]: Beauté Avenue Standard
            - paragraph [ref=e62]: Chargement de l'abonnement...
          - generic [ref=e63]:
            - button "Activer Standard" [ref=e64]
            - button "Activer Premium" [ref=e65]
        - generic [ref=e66]:
          - generic [ref=e67]:
            - generic [ref=e68]: Plan actuel
            - generic [ref=e70]:
              - paragraph [ref=e71]: Standard
              - paragraph [ref=e72]: 200 XOF
              - paragraph [ref=e73]: / mois
            - list [ref=e74]:
              - listitem [ref=e75]:
                - img [ref=e76]
                - generic [ref=e78]: ✓
                - generic [ref=e79]: Agenda illimité
              - listitem [ref=e80]:
                - img [ref=e81]
                - generic [ref=e83]: ✓
                - generic [ref=e84]: Gestion de l'équipe
              - listitem [ref=e85]:
                - img [ref=e86]
                - generic [ref=e88]: ✗
                - generic [ref=e89]: Acompte client
              - listitem [ref=e90]:
                - img [ref=e91]
                - generic [ref=e93]: ✗
                - generic [ref=e94]: Rapports financiers
              - listitem [ref=e95]:
                - img [ref=e96]
                - generic [ref=e98]: ✗
                - generic [ref=e99]: Export CSV
              - listitem [ref=e100]:
                - img [ref=e101]
                - generic [ref=e103]: ✗
                - generic [ref=e104]: Badge « Vérifié »
              - listitem [ref=e105]:
                - img [ref=e106]
                - generic [ref=e108]: ✗
                - generic [ref=e109]: Support prioritaire 24/7
          - generic [ref=e110]:
            - generic [ref=e112]:
              - paragraph [ref=e113]: Premium
              - paragraph [ref=e114]: 300 XOF
              - paragraph [ref=e115]: / mois
            - list [ref=e116]:
              - listitem [ref=e117]:
                - img [ref=e118]
                - generic [ref=e120]: ✓
                - generic [ref=e121]: Agenda illimité
              - listitem [ref=e122]:
                - img [ref=e123]
                - generic [ref=e125]: ✓
                - generic [ref=e126]: Gestion de l'équipe
              - listitem [ref=e127]:
                - img [ref=e128]
                - generic [ref=e130]: ✓
                - generic [ref=e131]: Acompte client
              - listitem [ref=e132]:
                - img [ref=e133]
                - generic [ref=e135]: ✓
                - generic [ref=e136]: Rapports financiers
              - listitem [ref=e137]:
                - img [ref=e138]
                - generic [ref=e140]: ✓
                - generic [ref=e141]: Export CSV
              - listitem [ref=e142]:
                - img [ref=e143]
                - generic [ref=e145]: ✓
                - generic [ref=e146]: Badge « Vérifié »
              - listitem [ref=e147]:
                - img [ref=e148]
                - generic [ref=e150]: ✓
                - generic [ref=e151]: Support prioritaire 24/7
        - generic [ref=e152]:
          - generic [ref=e154]:
            - generic [ref=e155]:
              - heading "Historique des factures" [level=2] [ref=e156]
              - generic [ref=e157]: 0 factures
            - status [ref=e158]:
              - paragraph [ref=e159]: Aucune facture pour le moment.
              - paragraph [ref=e160]: Vos prochaines factures apparaîtront ici.
          - generic [ref=e161]:
            - generic [ref=e162]:
              - heading "Mode de paiement" [level=2] [ref=e163]
              - generic [ref=e164]:
                - paragraph [ref=e165]: Aucun moyen de paiement configuré.
                - paragraph [ref=e166]: Requis pour le renouvellement automatique.
              - button "Configurer" [ref=e167]:
                - img [ref=e168]
                - text: Configurer
            - generic [ref=e170]:
              - heading "Renouvellement automatique" [level=2] [ref=e171]
              - generic [ref=e172]:
                - generic [ref=e173]:
                  - paragraph [ref=e174]: Désactivé
                  - paragraph [ref=e175]: Vous devrez renouveler manuellement.
                - 'switch "Renouvellement automatique : désactivé" [ref=e176]'
            - generic [ref=e178]:
              - heading "Support" [level=2] [ref=e179]
              - paragraph [ref=e180]: Une question sur votre abonnement ou une facture ?
              - button "Contacter le support" [ref=e181]:
                - img [ref=e182]
                - text: Contacter le support
```

# Test source

```ts
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
  423 |     const sub = await subR.json() as Record<string, unknown>;
  424 | 
  425 |     await test.step("Subscription API response has gracePeriodEndsAt field", async () => {
  426 |       expect("gracePeriodEndsAt" in sub, `gracePeriodEndsAt missing from subscription response: ${JSON.stringify(sub)}`).toBe(true);
  427 |     });
  428 | 
  429 |     await test.step("Pro subscription page renders plan info", async () => {
  430 |       await proLogin(page, context, "seynabou@epilexpress.sn", "salon1234");
  431 |       await page.goto("/pro/subscription", { waitUntil: "domcontentloaded" });
  432 |       await expect(page.locator("body")).toContainText(/Standard|Premium|Abonnement/i, { timeout: 10_000 });
  433 |     });
  434 | 
  435 |     // Grace banner only visible when subscription is past_due with an active grace window.
  436 |     const isGraceBannerVisible = await page.locator('[data-testid="grace-banner"]').isVisible();
  437 |     if (!isGraceBannerVisible) {
> 438 |       expect(sub.status).not.toBe("past_due");
      |                              ^ Error: expect(received).not.toBe(expected) // Object.is equality
  439 |     }
  440 |   });
  441 | 
  442 |   // ──────────────────────────────────────────────────────────────────────────
  443 |   // 8. PRO: calendar renders for owner
  444 |   // ──────────────────────────────────────────────────────────────────────────
  445 |   test("8 · Pro calendar: owner view loads without errors", async ({ page, context }) => {
  446 |     await waitForApi(page);
  447 |     await proLogin(page, context, "aida@dionesignature.sn", "salon1234");
  448 | 
  449 |     await page.goto("/pro/calendar");
  450 |     await page.waitForTimeout(1_000);
  451 |     await expect(page.locator("body")).not.toContainText("Erreur interne");
  452 |   });
  453 | 
  454 |   // ──────────────────────────────────────────────────────────────────────────
  455 |   // 9. PRO: bookings inbox
  456 |   // ──────────────────────────────────────────────────────────────────────────
  457 |   test("9 · Pro bookings inbox renders", async ({ page, context }) => {
  458 |     await waitForApi(page);
  459 |     await proLogin(page, context, "aida@dionesignature.sn", "salon1234");
  460 | 
  461 |     await page.goto("/pro/bookings/inbox");
  462 |     await expect(page.locator("body")).not.toContainText("Erreur interne");
  463 |   });
  464 | 
  465 |   // ──────────────────────────────────────────────────────────────────────────
  466 |   // 10. PRO: analytics tier gate — standard→402/403, premium→200
  467 |   // ──────────────────────────────────────────────────────────────────────────
  468 |   test("10 · Pro analytics: standard blocked (402/403), premium passes (200)", async ({
  469 |     page, context
  470 |   }) => {
  471 |     await waitForApi(page);
  472 | 
  473 |     await test.step("Standard salon gets 402 or 403", async () => {
  474 |       const r = await context.request.post(`${API}/api/v1/auth/login`, {
  475 |         data: { email: "kadija@studiokadija.sn", password: "salon1234" }
  476 |       });
  477 |       const { accessToken } = await r.json() as { accessToken: string };
  478 |       const ar = await context.request.get(`${API}/api/v1/pro/analytics?period=30d`, {
  479 |         headers: { authorization: `Bearer ${accessToken}` }
  480 |       });
  481 |       expect([402, 403]).toContain(ar.status());
  482 |     });
  483 | 
  484 |     await test.step("Premium salon gets 200", async () => {
  485 |       const r = await context.request.post(`${API}/api/v1/auth/login`, {
  486 |         data: { email: "aida@dionesignature.sn", password: "salon1234" }
  487 |       });
  488 |       const { accessToken } = await r.json() as { accessToken: string };
  489 |       const ar = await context.request.get(`${API}/api/v1/pro/analytics?period=30d`, {
  490 |         headers: { authorization: `Bearer ${accessToken}` }
  491 |       });
  492 |       expect(ar.ok()).toBeTruthy();
  493 |     });
  494 | 
  495 |     await test.step("Premium analytics page renders in UI", async () => {
  496 |       await proLogin(page, context, "aida@dionesignature.sn", "salon1234");
  497 |       await page.goto("/pro/analytics");
  498 |       await expect(page.locator("body")).not.toContainText("Erreur interne");
  499 |     });
  500 |   });
  501 | 
  502 |   // ──────────────────────────────────────────────────────────────────────────
  503 |   // 11. ADMIN: subscription list and detail
  504 |   // ──────────────────────────────────────────────────────────────────────────
  505 |   test("11 · Admin subscriptions: list renders and detail opens", async ({
  506 |     page, context
  507 |   }) => {
  508 |     await waitForApi(page);
  509 |     await adminLogin(page, context);
  510 | 
  511 |     await page.goto("/admin/subscriptions");
  512 |     await expect(page.getByRole("heading", { name: "Abonnements" })).toBeVisible();
  513 |     await page.waitForTimeout(1_000);
  514 | 
  515 |     // Click first subscription detail link
  516 |     const link = page.getByRole("link").filter({ hasText: /Voir|Détail|Dione|Kadija/i }).first();
  517 |     if (await link.isVisible()) {
  518 |       await link.click();
  519 |       await expect(page).toHaveURL(/\/admin\/subscriptions\//);
  520 |       await expect(page.locator("body")).not.toContainText("Erreur interne");
  521 |     }
  522 |   });
  523 | 
  524 |   // ──────────────────────────────────────────────────────────────────────────
  525 |   // 12. PRO: approval-status page for pending salon
  526 |   // ──────────────────────────────────────────────────────────────────────────
  527 |   test("12 · Pro approval-status page: new pending salon is redirected", async ({
  528 |     page, context
  529 |   }) => {
  530 |     await waitForApi(page);
  531 | 
  532 |     const runId = Date.now();
  533 |     const email = `pending.${runId}@example.sn`;
  534 | 
  535 |     await test.step("Register pending salon", async () => {
  536 |       const r = await context.request.post(`${API}/api/v1/auth/register`, {
  537 |         data: {
  538 |           type: "salon_owner",
```