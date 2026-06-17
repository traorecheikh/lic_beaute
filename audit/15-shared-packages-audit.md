# Audit Packages Partagés — Beauté Avenue

> Généré le 17 juin 2026

## Score global : **A- (88/100)** 🟢

---

## 1. `@beauteavenue/shared-ts`

### Emplacement : `packages/shared-ts/`

### Contenu
| Fichier | Lignes | Description |
|---|---|---|
| `src/index.ts` | ~20 | Barrel exports + `formatMoneyXof` + constantes |
| `src/services.ts` | ~140 | `SERVICE_CATEGORY_MAP` — 140 entrées de mapping service→catégorie |
| `src/validate-form.ts` | ~30 | Wrapper Zod `safeParse` avec typage générique |
| `src/legal-config.ts` | ~30 | Config légale (RCCM, NINEA, adresse) |

### ✅ Points forts
- **`formatMoneyXof()`** : utilise `Intl.NumberFormat("fr-SN", ...)` — correctement localisé
- **`validateForm()`** : wrapper générique typé pour Zod — propre et réutilisable
- **`SERVICE_CATEGORY_MAP`** : 140+ entrées couvrant coiffure, barbershop, ongles, esthétique, spa, maquillage, épilation — très complet
- **Documentation des constantes** : chaque catégorie est commentée

### ⚠️ Problèmes

| # | Problème | Sévérité |
|---|---|---|
| S1 | **Zod v4 vs v3** : `shared-ts` utilise `zod@^4.4.3`, `contracts` utilise `zod@^3.24.1` | **Major** |
| S2 | **`legal-config.ts` : champs vides** : `numeroRccm: ""`, `ninea: ""`, `responsableLegal: ""`, `referenceCdp: ""` — risque d'être livré en l'état | **Major** |
| S3 | **Pas de tests** : `node -e "console.log('no shared-ts tests yet')"` dans `package.json` | **Minor** |
| S4 | **`SERVICE_CATEGORY_MAP` : pas de catégories "Soins visage" validées** : certaines catégories dans le map (`"Soins visage"`) n'ont pas de salon réel avec cette catégorie en base | **Minor** |
| S5 | **Dépendance `@types/node`** : inutile pour un package purement algorithmique (pas de Node.js API) | **Minor** |

---

## 2. `@beauteavenue/contracts`

### Emplacement : `packages/contracts/`

### Contenu
| Module | Description |
|---|---|
| `domain/*.ts` | 13 fichiers domain : admin, auth, booking, config, enums, favorite, notification, payment, profile, pro, review, media, salon, search |
| `http/common.ts` | Types HTTP partagés |
| `openapi/spec.ts` | Logique de génération OpenAPI |

### ✅ Points forts
- **Typage strict** : domaines partagés entre client et serveur
- **Génération OpenAPI** : spé automatisée via `zod-to-json-schema` + `tsx`
- **Vitest configuré** : tests présents dans `src/index.test.ts`
- **Workspace bien intégré** : utilisé par `apps/api`, `apps/web`, et `apps/mobile-client` (via spec OpenAPI)

### ⚠️ Problèmes

| # | Problème | Sévérité |
|---|---|---|
| C1 | **Zod v3** : `zod@^3.24.1` — alors que `shared-ts` est en v4. Les deux packages devraient être alignés | **Major** |
| C2 | **Pas de CI/CD pour les packages** : pas de build/test automatique sur PR modifiant `packages/` | **Minor** |
| C3 | **`openapi.json` non versionné proprement** : stocké dans `apps/api/openapi/openapi.json` — pas de versioning | **Minor** |

---

## 3. Problèmes cross-packages

| # | Problème | Sévérité |
|---|---|---|
| X1 | **Zod version mismatch** : `shared-ts` (v4.4.3) vs `contracts` (v3.24.1) — pourrait causer des incohérences | **Major** |
| X2 | **Pas de barrel unifié** : les deux packages exportent indépendamment, aucun package "umbrella" | **Minor** |
| X3 | **`package.json` scripts incohérents** : `contracts` a `test: vitest run`, `shared-ts` a `test: node -e "..."` | **Minor** |

---

## 4. Recommandations

### 🔴 Priorités
1. **Aligner Zod versions** : migrer `contracts` vers Zod v4 ou `shared-ts` vers Zod v3 — unifier
2. **Remplir les champs légaux** : RCCM, NINEA, responsable légal dans `legal-config.ts`
3. **Ajouter des tests** à `shared-ts` (au moins pour `formatMoneyXof` et `validateForm`)

### 🟡 Améliorations
4. Supprimer `@types/node` de `shared-ts`
5. Ajouter un workflow CI pour builder + tester les packages sur PR
6. Unifier les scripts de test entre les deux packages

### 🟢 Polish
7. Envisager un package `@beauteavenue/types` umbrella si la séparation devient trop fine
