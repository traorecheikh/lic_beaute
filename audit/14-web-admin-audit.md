# Audit Web Admin (Vue.js) — Beauté Avenue

> Généré le 17 juin 2026

## Score global : **B (78/100)** 🟡

---

## Stack technique
- **Framework :** Vue 3.5 + Composition API (`<script setup>`)
- **Build tool :** Vite 8 + Tailwind 4
- **State management :** Pinia + TanStack Vue Query
- **Routing :** Vue Router 5
- **Form validation :** VeeValidate + Zod
- **Tests :** Vitest (unit) + Playwright (e2e)
- **Types :** TypeScript 6

---

## 1. Architecture & Organisation

### Structure
```
apps/web/src/
├── components/        # 14 composants réutilisables
├── layouts/           # 3 layouts (Admin, Pro, Legal)
├── lib/
│   ├── generated/     # ~250 modèles API générés (OpenAPI)
│   ├── api.ts         # Admin API client (raw fetch)
│   ├── pro-api.ts     # Pro API client (wraps generated client)
│   ├── session.ts     # localStorage session
│   └── ...
├── router/            # Vue Router config (~300 lignes)
├── stores/            # Pinia stores (adminAuth, proAuth)
├── views/             # ~35 pages/views
├── App.vue
├── main.ts
└── styles.css         # Tailwind v4 avec @theme
```

### ✅ Points forts
- **Deux clients API distincts** : `api.ts` (admin, raw fetch) + `pro-api.ts` (wraps generated client) — bonne séparation
- **Code généré OpenAPI** : ~250 modèles TypeScript dans `lib/generated/` — sécurité de type maximale
- **TanStack Vue Query** : gestion du cache, retry, staleTime, refetch — professionnel
- **Guard navigation** : beforeEach avec restore session, redirect avec `expired=1`, guards par rôle (admin, pro, owner)
- **Lazy loading** : toutes les pages importées dynamiquement (`() => import(...)`)
- **Pinia persisted state** : session tokens persistés en localStorage
- **Tailwind v4** avec `@theme` inline pour les tokens de design

### ⚠️ Problèmes

| # | Problème | Sévérité | Fichier |
|---|---|---|---|
| W1 | **`_BookingRouteErrorPage` dans le router** : composant UI défini dans `app_router.dart` (mobile) — mélange concern | **Major** | (déjà couvert par audit mobile) |
| W2 | **Vars Intech résiduelles** : référence à `IntechPaymentsPost200Response` dans les modèles générés | **Minor** | Modèles générés |
| W3 | **`pro-api.ts` : 700+ lignes** — monolithique, mélange auth, bookings, salon, staff, subscription, analytics | **Major** | `src/lib/pro-api.ts` |
| W4 | **`api.ts` : 400+ lignes** — similaire, monolithique | **Major** | `src/lib/api.ts` |
| W5 | **2 systèmes d'erreur** : `ApiError` dans `api.ts` + `ResponseError` du generated client dans `pro-api.ts` — inconsistants | **Minor** | Multiples fichiers |
| W6 | **`pro-api.ts` : retry pattern dupliqué** : `withApiError` + `fetchProAuthResponse` + refresh — deux mécanismes pour la même chose | **Major** | `pro-api.ts` |
| W7 | **Pas de tests sur les composants** : `src/components/` n'a pas de tests unitaires | **Minor** | — |
| W8 | **Pas de validation Zod** côté front-end pour les formulaires admin | **Minor** | — |

---

## 2. Routing & Guards

### Routes
- **Publiques :** `/` (landing), `/privacy`, `/terms`, `/pro`, `/pro/register`, `/pro/login`, `/pro/setup-account`, etc.
- **Pro protégées :** `/pro/calendar`, `/pro/dashboard`, `/pro/bookings/inbox`, `/pro/clients`, etc.
- **Admin protégées :** `/admin/dashboard`, `/admin/salons`, `/admin/subscriptions`, `/admin/payouts`, `/admin/audit`, `/admin/config`, etc.
- **Catch-all 404**

| # | Problème | Sévérité |
|---|---|---|
| R1 | **Pas de lazy loading pour les layouts** : `AdminLayout` et `ProLayout` importés statiquement | **Minor** |
| R2 | **Vouchers route commentée** : `// VOUCHERS / PROMOS — DISABLED` avec docstring de 10 lignes — bruyant | **Minor** |
| R3 | **Pas de guard pour Pro Subscription callback** : la route callback /pro/subscription/callback n'a pas de meta guard clair | **Minor** |

---

## 3. Design & CSS

### ✅ Points forts
- **Tailwind v4** avec `@theme` — design tokens centralisés (couleurs, radius, fonts)
- **Utilities Tailwind personnalisées** : `@utility page-title`, `@utility panel-clean`, `@utility btn-primary`, `@utility input-shell`
- **Palette élégante** : espresso, cocoa, sand, blush — en accord avec la marque
- **Radius scales** : xs=4, sm=6, md=8, lg=12, xl=16, 2xl=24, 3xl=32 — cohérent

### ⚠️ Problèmes

| # | Problème | Sévérité |
|---|---|---|
| D1 | **Dark mode désactivé avec commentaire** : `main.ts` — "DARK MODE DISABLED — LIGHT MODE ONLY" — pas de support | **Minor** |
| D2 | **TT Commons Pro font non livrée** : déclarée dans `--font-display` en fallback après Inter | **Minor** |
| D3 | **Pas de test visuel / Percy** : pas de snapshot visuel dans les tests e2e | **Minor** |

---

## 4. Stores & State

### `adminAuth.ts` (Pinia)
- ✅ `restoreSession()` vérifie si le token est valide via `/api/v1/me`
- ✅ `tokens` stockés dans `localStorage` via plugin persistedstate
- ✅ `refreshSession()` avec single-flight pattern
- ✅ Tests unitaires présents (`adminAuth.test.ts`)

### `proAuth.ts` (Pinia)
- ✅ Similaire à adminAuth
- ✅ Gère `salonApprovalStatus`, `isOwner` pour les guards

### Problèmes
| # | Problème | Sévérité |
|---|---|---|
| S1 | **Admin store pas de refresh automatique** : le refresh n'est pas déclenché par un intercepteur — seulement dans `fetchWithAuth` | **Minor** |
| S2 | **Pas de test proAuth** : alors que `adminAuth.test.ts` existe, `proAuth.test.ts` n'existe pas | **Minor** |

---

## 5. Tests

| Type | Status |
|---|---|
| **Unitaires (Vitest)** | ✅ Tests sur `adminAuth`, `api`, `query`, `router`, `legal` — couverture basique |
| **E2E (Playwright)** | ✅ 6 specs : pro-login, admin-login, subscription, panel smoke, sprint demo, full flow admin→pro |
| **Composants** | ❌ Aucun test sur les 14 composants |

### Forces
- ✅ Tests e2e avec `slowMo` et `headed` mode pour debug
- ✅ Playwright config avec serveurs intégrés (API + Vite)
- ✅ Test de flux complet (admin → pro) en e2e

### Faiblesses
| # | Problème |
|---|---|
| T1 | **E2E timeout long** (180s) — signe de tests instables |
| T2 | **Pas de test des composants UI** (StatusBadge, PieChart, etc.) |
| T3 | **`PanoramicScreenshotTesting` absent** — pas de tests visuels |

---

## 6. Sécurité

| # | Problème | Sévérité |
|---|---|---|
| X1 | **Token stocké en localStorage** : pas de httpOnly cookies — vulnérable au XSS | **Info** (acceptable pour SPA) |
| X2 | **`VITE_API_URL` build-time** : doit être injectée au build — pas de fallback runtime clair | **Minor** |
| X3 | **`COOLIFY_TOKEN` dans URL GET** : visible dans les logs du serveur | **Minor** |

---

## 7. Résumé

### 🔴 Priorités
1. **Extraire `pro-api.ts`** en modules séparés (auth, bookings, salon, staff, subscription, payments)
2. **Extraire `api.ts`** en modules séparés
3. **Unifier le refresh token** : `withApiError` et `fetchProAuthResponse` font la même chose — fusionner

### 🟡 Améliorations
4. Ajouter des tests unitaires pour les composants UI
5. Ajouter des tests unitaires pour `proAuth` store
6. Ajouter Zod validation côté frontend pour les formulaires admin

### 🟢 Polish
7. Réduire le timeout e2e (180s → 60s) en améliorant la stabilité des tests
8. Ajouter support dark mode (ou supprimer proprement le code commenté)
9. Nettoyer les modèles générés résiduels (Intech)
