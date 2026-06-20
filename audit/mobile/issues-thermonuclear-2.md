# 🔥 Thermo-Nuclear Code Quality Review — Part 2

---

## 🔴 #13: `admin/data.ts` — 1547 LIGNES, 38 FONCTIONS EXPORTÉES, 7 DOMAINES

**Fichier**: `apps/api/src/modules/admin/data.ts`

Ce fichier est le plus gros du backend. Il viole SOLID (Single Responsibility) de façon spectaculaire.

### Ce fichier contient:
| Fonctions exportées | Domaine |
|---|---|
| `getAdminDashboard`, `listPendingSalons`, `listSalons`, `getPendingSalonDetail`, `approveSalon`, `rejectSalon`, `requestSalonInfo`, `createSalon` | **Salon management** (~500 lignes) |
| `listSubscriptions`, `getSubscriptionDetail`, `overrideSubscription`, `getCancellationStats`, `manualExtendSubscription` | **Subscription management** (~400 lignes) |
| `listAuditEvents`, `listEmailAuditEvents`, `getAuditDetail` | **Audit log** (~80 lignes) |
| `getPlatformSettings`, `updatePlatformSetting`, `listSalonCategories`, `upsertSalonCategory`, `deleteSalonCategory`, `listRequiredDocuments`, `upsertRequiredDocument`, `deleteRequiredDocument`, `listServiceSuggestions`, `upsertServiceSuggestion`, `deleteServiceSuggestion` | **Config/CRUD** (~200 lignes) |
| `sendMagicLink`, `sendPasswordReset` | **Admin communication** (~100 lignes) |
| `checkSalonUniqueness` | **Uniqueness** (~20 lignes) |
| `startOfToday`, `daysAgo`, `writeAuditLog`, `parseBooleanSetting`, `buildEntitlements`, `getSalonOwnerContact`, `normalizeSubscriptionAuditReference` | **Helpers** (~100 lignes) |

### Problème structurel:
L'implémentation de chaque domaine est entremêlée. `approveSalon` fait : fetch salon → update → upsert subscription → write audit log → send email. La même orchestration exacte se répète dans `rejectSalon`, `requestSalonInfo`, `createSalon`, `overrideSubscription`, `manualExtendSubscription`. Ce n'est pas de la logique métier, c'est une pipeline administrative qui devrait être factorisée.

### Code judo move:
**Split en 6 fichiers par domaine:**
```
admin/
  data.ts                          ← 1547L (supprimer, remplacer par imports)
  salon-admin.ts                   ← approve, reject, request info, create
  salon-queue.ts                   ← list, list pending, detail
  subscription-admin.ts            ← list, override, extend, stats
  audit.ts                         ← list events, list email events, detail
  config-admin.ts                  ← settings, categories, documents, suggestions
  communication.ts                 ← magic link, password reset
```

**Factoriser la pipeline de notification email**:
```typescript
async function notifySalonOwner(
  salonId: string,
  params: { subject: string; bodyLines: string[]; cta?: { url: string; label: string } }
) { ... }
```
Les 8 appels à `sendEmail` avec `buildEmailHtml` dans approveSalon, rejectSalon, requestSalonInfo, createSalon, overrideSubscription, manualExtendSubscription, sendMagicLink, sendPasswordReset deviennent une seule ligne:
```typescript
await notifySalonOwner(salonId, { subject: "...", bodyLines: [...], cta: {...} });
```

---

## 🔴 #14: `slot_variants.dart` — 1008 LIGNES, 10 WIDGETS, 1 FICHIER

**Fichier**: `apps/mobile-client/lib/src/features/booking/widgets/slot_variants.dart`

Ce fichier franchit le seuil des 1000 lignes. Il contient 10 variantes visuelles du sélecteur de créneaux (V1 à V10), toutes dans le même fichier. Chaque variante est un widget StatefulWidget ou StatelessWidget complet, avec son propre build method.

### Problème:
- `V1SlotBlockFilter` + `_V1State` = ~80 lignes
- `V2SlotPeriodSections` = ~50 lignes  
- `V3SlotPillTabs` + `_V3State` = ~90 lignes
- `V4SlotHourLanes` = ~55 lignes
- `V5SlotAccordion` + `_V5State` = ~90 lignes
- `V6SlotPageCards` + `_V6State` = ~120 lignes
- `V7SlotSwimlanes` = ~65 lignes
- `V8SlotClearList` = ~80 lignes
- `V9SlotColorChips` = ~50 lignes
- `V10SlotPureGrid` = ~30 lignes
- Helpers partagés (`_dt`, `_fmt`, `_chip`, `_period`, etc.) = ~60 lignes

### Code judo move:
**Chaque variante dans son propre fichier**:
```
slot_variants/
  slot_variants.dart              ← factory + exports
  v1_block_filter.dart
  v2_period_sections.dart
  v3_pill_tabs.dart
  v4_hour_lanes.dart
  v5_accordion.dart
  v6_page_cards.dart
  v7_swimlanes.dart
  v8_clear_list.dart
  v9_color_chips.dart
  v10_pure_grid.dart
  slot_variant_helpers.dart       ← _dt, _fmt, _chip, _period etc. (peut être _private)
```

Le fichier principal devient ~30 lignes (uniquement la factory + exports), chaque variante ~50-120 lignes dans son propre fichier. Le fichier passe de 1008 à 30 lignes.

---

## 🔴 #15: `auth/index.ts` — 1391 LIGNES, TOUT L'AUTH DANS 1 FICHIER

**Fichier**: `apps/api/src/modules/auth/index.ts`

### Ce fichier contient:
1. Helpers: `normalizePhoneNumber`, `normalizeEmail`, `constantTimeEquals`, `hashValue`, `hashRefreshToken`, `isPlayReviewEnabled`, `readOtpChallenge`, `clearOtpChallenge`, `checkOtpRateLimit`
2. Session management: `signSession`, `verifyRefreshToken`, `pruneExcessSessions`
3. OTP flow: OTP request (phone + email), OTP verify (phone + email), OTP rate limiting
4. Auth flow: `register` (client + salon_owner), `login`, `refresh`, `logout`
5. User management: `me`, `updateMe`, `serializeCurrentUser`
6. Availability: `checkAvailability`
7. Play Store reviewer bypass

### Problème:
7 domaines différents dans un seul fichier. Les helpers sont définis puis utilisés 200 lignes plus bas. La navigation dans ce fichier est impossible sans IDE.

### Code judo move:
```
auth/
  index.ts                        ← AuthController class (orchestrateur, ~100 lignes)
  auth-helpers.ts                 ← normalize, hash, constantTimeEquals
  session.ts                      ← signSession, verifyRefreshToken, pruner
  otp.ts                          ← OTP request, verify, rate limit
  register.ts                     ← client + salon_owner registration
  login.ts                        ← email login + OTP login
  user.ts                         ← me, updateMe, serializeCurrentUser
```

---

## 🔴 #16: EMAIL HTML BUILDING DUPLIQUÉ 8× DANS ADMIN/DATA.TS

**Fichier**: `apps/api/src/modules/admin/data.ts`

### Problème:
Le pattern suivant est répété **8 fois** littéralement :
```typescript
const { buildEmailHtml } = await import("../../lib/email-html.js");
await sendEmail({
  to: owner.email,
  subject: "...",
  text: `Bonjour ${owner.fullName ?? ""},...`,
  html: buildEmailHtml({
    preheader: "...",
    greeting: `Bonjour ${owner.fullName ?? ""},`,
    bodyLines: [...],
    cta: { url: ..., label: ... },
    ...
  })
}).catch((err) => logger.error("...", { err: String(err), ownerEmail: owner.email, ... }));
```

Chaque appel fait un `await import("../../lib/email-html.js")` dynamique — 8 import dynamiques qui auraient dû être un import statique en haut du fichier.

### Code judo move:
```typescript
import { buildEmailHtml } from "../../lib/email-html.js";

async function notifySalonOwner(params: {
  salonId: string;
  to: string;
  ownerName: string;
  subject: string;
  bodyLines: string[];
  cta?: { url: string; label: string };
  salonName: string;
}) {
  await sendEmail({
    to: params.to,
    subject: params.subject,
    text: `Bonjour ${params.ownerName},...`,
    html: buildEmailHtml({ ... })
  }).catch((err) => logger.error("notification failed", { err, to: params.to }));
}
```
Supprime ~200 lignes du fichier. Les 8 appels deviennent 1 ligne chacun.

---

## 🔴 #17: `auth/index.ts` — LES 3 ENDPOINTS EMAIL SONT DANS L'OTP FLOW ALORS QU'ILS N'ONT RIEN À VOIR

`emailOtpRequest`, `emailOtpVerify`, `emailLogin` sont dans le même fichier que l'OTP SMS mais ils gèrent un flow email+password complètement différent. Les OTP SMS utilisent un challenge stocké, les OTP email sont validés côté serveur, le login email est un submit mot de passe + envoi OTP séparé. Le seul point commun est "c'est de l'auth".

---

## 🟡 #18: `booking_funnel_provider.dart` — `copyWith()` AVEC 15 PARAMÈTRES

**Fichier**: `apps/mobile-client/lib/src/features/booking/providers/booking_funnel_provider.dart`

Le `copyWith` a 15 paramètres optionnels + 2 flags booléens (`clearEmployee`, `clearSlot`). Chaque flag est un kludge ajouté parce que `null` signifie "ne pas changer" en Dart. Les flags `clearX` existent parce que la représentation ne permet pas de faire la différence entre "garder l'ancienne valeur" et "mettre à null".

### Code judo move:
Remplacer le `copyWith` par des méthodes `selectService()`, `selectEmployee()`, `selectSlot()` qui prennent uniquement ce qui est nécessaire et savent quoi réinitialiser. Le `copyWith` devient obsolète et peut être supprimé.

---

## 🟡 #19: `payment_handoff_page.dart` — 8 TextEditingControllers DÉCLARÉS `late final`

8 controllers créés dans un `initState()` de 22 lignes, puis disposés dans un `dispose()` de 11 lignes. Le pattern est purement cérémoniel. Si on extrait les sous-formulaires dans des widgets séparés, chaque widget gère son propre controller et le fichier principal n'en a aucun.

---

## 🟡 #20: `admin/data.ts` — LES 2 FONCTIONS `listPendingSalons` ET `listSalons` SONT PRESQUE IDENTIQUES

`listPendingSalons` et `listSalons` ont ~85% de code en commun : même pagination, mêmes includes, même transformation `AdminSalonQueueItem`. La seule différence est le filtre par défaut (`pending_review/needs_info` vs `approved`). C'est une duplication flagrante.

---

## 🟢 #21: `admin/data.ts` — HIDDEN_SETTING_KEYS EST UN SET MAIS N'EST JAMAIS UTILISÉ COMME TEL

```typescript
const HIDDEN_SETTING_KEYS = new Set([...]);
return rows.filter((s) => !HIDDEN_SETTING_KEYS.has(s.key));
```
Ce n'est pas un bug, mais le set est utilisé comme un `string[]` avec `.has()`. Le Set est la collection correcte ici, donc correct. Mais le nommage `HIDDEN_SETTING_KEYS` avec UPPER_CASE devrait inclure `platform_name` dans le Set.

---

## 🟢 #22: `staff_selection_page.dart` — `_resolveBestStaffId()` LANCE `Future.wait` SANS MONTORING D'ANNULATION

La méthode `_resolveBestStaffId` boucle sur 2 jours × N employés (chaque appel `salonAvailabilityProvider(params).future`). Si l'utilisateur pop la page pendant l'exécution, ces appels réseau continuent. Le résultat est ignoré mais la bande passante est gaspillée. Devrait utiliser un `AbortController` ou au moins vérifier `mounted` après chaque await dans la boucle.

---

## 📊 BARÈME DE QUALITÉ — V2

| Critère | Score | Pire offensant |
|---------|-------|---------------|
| Taille des fichiers (>1000L) | ❌ 0/10 | **5 fichiers**: payment_handoff (1663), admin/data (1547), auth/index (1391), booking_funnel_sheet (1363), slot_variants (1008) |
| Duplication | ❌ 1/10 | Email build 8×, salon list 2× quasi-identiques, approve/reject/requestInfo pattern 3× |
| Abstractions | ❌ 2/10 | Aucune séparation domaine dans admin/data.ts (38 exports) |
| Testabilité | ❌ 1/10 | Email builders utilisent `await import()` dynamique, pas d'injection |
| **Global** | **❌ 1.5/10** | **Refonte architecturale nécessaire** |

---

## 🎯 TOP 5 PRIORITÉS — ADDITIONNEL

1. **🔥 Split `admin/data.ts`** (1547L → 6 fichiers)
2. **🔥 Factoriser `notifySalonOwner()`** (supprime 200 lignes, 8 imports dynamiques)
3. **🔥 Split `auth/index.ts`** (1391L → 6 fichiers)
4. **🔥 Split `slot_variants.dart`** (1008L → 1 factory + 10 fichiers)
5. **🔥 Supprimer `copyWith()` du funnel** → remplacer par méthodes intentionnelles
