# 🔥 Thermo-Nuclear Code Quality Review — Part 3

---

## 🔴 #23: `payments/index.ts` — 1100 LIGNES, PAYMENT CONTROLLER MONOLITH

**Fichier**: `apps/api/src/modules/payments/index.ts`

### Ce fichier contient:
- **PaymentController** avec 10+ méthodes publiques
- `_handleWebhook` — **150 lignes** avec 3 fallbacks lookup, subscription charge fallback, amount guards, replay detection
- `_applyPaymentStatus` — **120 lignes** : transaction, auto-confirmation, rappels, email+PDF notification
- `_applySubscriptionChargeStatus` — **100 lignes** : transaction, invoice creation, subscription extension, email notification
- Fee calculation helpers `calcFee`, `getCommissionPercent`
- `WITHDRAW_MODE_MAP`, `requiresProviderCompletion`, `normalizePhoneNumber`

### Code judo move:
Split into domain files:
```
payments/
  index.ts                     ← PaymentController (orchestrateur ~100L)
  webhook.ts                   ← _handleWebhook (~150L → décomposé en handlers par type)
  payment-status.ts            ← _applyPaymentStatus + reconcile
  subscription-charge.ts       ← _applySubscriptionChargeStatus
  fee.ts                       ← calcFee, getCommissionPercent
```

---

## 🔴 #24: `_requiresProviderConfirmation` DUPLIQUÉ ×2

**Fichiers**:
- `payments/index.ts:33` — `requiresProviderCompletion()`
- `paydunya.ts:1030` — `_requiresProviderConfirmation()`

### Problème:
Ces deux fonctions font EXACTEMENT la même chose : décider si un paiement nécessite une confirmation du provider (async) ou est terminé immédiatement. Mais elles sont implémentées indépendamment :
- `requiresProviderCompletion`: check `url`, `other_url`, `pendingProviderConfirmation`, `status`, message matching, cid
- `_requiresProviderConfirmation`: check `url`, `other_url`, message matching, cid, **PLUS** hardcoded Set de méthodes async

La deuxième version a une logique en plus (le Set de méthodes async) qui n'existe pas dans la première. Si l'une des deux est modifiée sans l'autre, le comportement diverge et les paiements seront mal gérés.

### Code judo move:
**Supprimer `_requiresProviderConfirmation` de `paydunya.ts` et l'importer depuis `payments/index.ts`** (ou mieux, déplacer vers un fichier partagé). La méthode dans `paydunya.ts` devrait appeler celle de `payments/index.ts` ou vice versa. Dans tous les cas, une seule source de vérité.

---

## 🔴 #25: `paydunya.ts:normalizePhoneNumber` — 8× BRANCHES IDENTIQUES

**Fichier**: `apps/api/src/adapters/payment/paydunya.ts:14-22`

```typescript
function normalizePhoneNumber(phone: string, country: string): string {
  let cleaned = phone.replace(/[\s+\-()]/g, "");
  if (cleaned.startsWith("221") && cleaned.length > 9) cleaned = cleaned.substring(3);
  if (cleaned.startsWith("225") && cleaned.length > 10) cleaned = cleaned.substring(3);
  if (cleaned.startsWith("223") && cleaned.length > 8) cleaned = cleaned.substring(3);
  // ... 5 more identical patterns
  return cleaned;
}
```

8 branches identiques en structure, seule la longueur et le code pays changent. Si on ajoute un pays, on ajoute une 9ème branche. Si un code pays change, on modifie une ligne.

### Code judo move:
```typescript
const COUNTRY_CODE_LENGTHS: Record<string, number> = {
  "221": 9, "225": 10, "223": 8, "228": 8, 
  "229": 8, "226": 8, "237": 9
};
function normalizePhoneNumber(phone: string, country: string): string {
  let cleaned = phone.replace(/[\s+\-()]/g, "");
  for (const [code, length] of Object.entries(COUNTRY_CODE_LENGTHS)) {
    if (cleaned.startsWith(code) && cleaned.length > length) {
      cleaned = cleaned.substring(code.length);
      break;
    }
  }
  return cleaned;
}
```
8 branches → 0. Ajout d'un pays = 1 ligne dans la config.

---

## 🔴 #26: `normalizePhoneNumber` — COLLISION DE NOM ×2

**Fichiers**:
- `payments/index.ts:25` — `normalizePhoneNumber(phoneNumber: string)` → `.replace(/\s+/g, "").trim()`
- `paydunya.ts:14` — `normalizePhoneNumber(phone: string, country: string)` → supprime code pays + whitespace

Deux fonctions avec le même nom (`normalizePhoneNumber`) mais des signatures et comportements complètement différents :
1. `payments/index.ts`: 1 paramètre, enlève espaces, retourne tel quel
2. `paydunya.ts`: 2 paramètres, enlève espaces + code pays

Celui de `paydunya.ts` ne peut PAS être appelé accidentellement depuis `payments/index.ts` car les signatures diffèrent (1 param vs 2 params). Mais la collision rend le code confus : si on importe le mauvais, le comportement change radicalement.

**Fix**: Renommer en `normalizeLocalPhoneNumber` et `normalizeInternationalPhoneNumber`, ou utiliser un namespace.

---

## 🔴 #27: `SOFTPAY_METHOD_MAP` — 40 LIGNES DE MAPPING REDONDANT

**Fichier**: `apps/api/src/adapters/payment/paydunya.ts:142-183`

```typescript
const SOFTPAY_METHOD_MAP: Record<string, string> = {
  paydunya_card: "carte_bancaire",
  paydunya_wave_sn: "wave_senegal",
  paydunya_orange_sn: "orange_senegal",
  // ... 37 more entries
};
```

Plus de la moitié des entrées ont le pattern `paydunya_*` → enlever le préfixe et remplacer `_sn` → `_senegal`, etc. 

### Code judo move:
```typescript
function resolveSoftpayMethod(channel: string): string {
  if (PAYDUNYA_METHODS[channel]) return channel;  // already canonical
  const stripped = channel.replace(/^paydunya_/, "");
  return ALIAS_MAP[stripped] ?? "wave_senegal";
}
```
40 lignes → ~10 lignes. Zéro maintenance pour ajouter une méthode.

---

## 🔴 #28: `executePayment` — 15+ CONDITIONNELS AD-HOC PAR MÉTHODE

**Fichier**: `paydunya.ts:252-320`

La méthode `executePayment` a un bloc conditionnel pour chaque méthode de paiement :
```typescript
if (mappedMethod === "carte_bancaire") { body.card_number = ... }
if (mappedMethod === "om_ci") { body.otp = ... }
if (mappedMethod === "mtn_ci") { body.provider = ... }
// ... 12 more if-blocks
```

Chaque conditionnel ajoute des champs spécifiques à une méthode dans le body. C'est **15 ad-hoc conditionals dans la même méthode**.

### Code judo move:
```typescript
const METHOD_SPECIFIC_FIELDS: Record<string, (details: any) => Record<string, unknown>> = {
  carte_bancaire: (d) => ({ card_number: d.cardNumber, card_cvv: d.cardCvv, ... }),
  om_ci: (d) => ({ orange_money_ci_otp: d.otp }),
  mtn_ci: (d) => ({ mtn_ci_wallet_provider: d.provider }),
  // ...
};

const mapper = METHOD_SPECIFIC_FIELDS[mappedMethod];
if (mapper) Object.assign(body, mapper(details));
```
15 if-blocks → 1 ligne + 1 map configurable.

---

## 🟡 #29: `payments/index.ts:` — `_handleWebhook` 150 LIGNES AVEC 3 FALLBACK STRATÉGIES

**Fichier**: `payments/index.ts:500-650`

`_handleWebhook` contient :
1. Vérification signature + parsing + replay protection
2. **3 stratégies de lookup** pour trouver le payment:
   - Par `paymentId` dans metadata (prioritaire)
   - Par `OR` fallback sur `providerTxId` / `webhookSignature`
   - Par `subscriptionCharge` (fallback final)
3. Vérification que `providerRef` match (anti-spoof)
4. Amount guard ±1 XOF
5. Duplicate webhook guard
6. `_applyPaymentStatus` appel

Ce webhook unique gère à la fois les paiements de dépôt, les abonnements, ET les deux types de lookup. C'est une surcharge de responsabilité phénoménale.

---

## 🟡 #30: `pro/index.ts:updateSalon` — 150 LIGNES DE RÉPONSE DUPLIQUÉE

**Fichier**: `apps/api/src/modules/pro/index.ts`

La méthode `updateSalon` se termine par **la même réponse de 20 lignes** que `getSalon` :
```typescript
ok(reply, {
  id: salon.id, name: salon.name, ...  // ~20 lignes
  hours: salon.salonHours.map(...)     // ~5 lignes
});
```

Cette réponse sérialisée est dupliquée dans `getSalon` et `updateSalon`. Si un champ est ajouté au modèle salon, il faut le modifier dans les DEUX endroits.

**Fix**: Extraire `serializeSalon(salonId, salon, settings)` et l'utiliser dans les deux méthodes.

---

## 🟡 #31: `pro/index.ts` — `listServices` → `deleteService` 4× CRUD PATTERN BOILERPLATE

**Fichier**: `apps/api/src/modules/pro/index.ts`

Toutes les paires CRUD (services, staff, blocked slots, hours) suivent exactement le même pattern:
```typescript
async listXxx(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId } = await ensurePro(request);
    const items = await prisma.xxx.findMany({ where: { salonId } });
    ok(reply, items.map(s => serializeXxx(s)));
  } catch (e) { handleError(e, reply); }
}

async createXxx(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, role } = await ensurePro(request);
    if (!ownerOnly(role, reply)) return;
    if (!(await ensureProWriteAccess(salonId, reply))) return;
    const body = xxxSchema.parse(request.body);
    const item = await prisma.xxx.create({ data: { salonId, ...body } });
    ok(reply, serializeXxx(item), 201);
  } catch (e) { handleError(e, reply); }
}
```

Chaque CRUD ajoute ~30 lignes de cérémonial. Pour 4 entités (services, staff, blocked slots, hours) = ~480 lignes de boilerplate. C'est 40% du fichier.

**Code judo move**: Factory de CRUD :
```typescript
function crudEndpoints<T, C, U>(opts: {
  name: string;
  prismaModel: PrismaDelegate;
  createSchema: ZodSchema<C>;
  updateSchema: ZodSchema<U>;
  writeAccess?: boolean;
}) {
  return {
    list: asyncHandler(async (req, reply) => {
      const { salonId } = await ensurePro(req);
      ok(reply, await opts.prismaModel.findMany({ where: { salonId } }));
    }),
    create: asyncHandler(async (req, reply) => { ... }),
    update: asyncHandler(async (req, reply) => { ... }),
    delete: asyncHandler(async (req, reply) => { ... }),
  };
}
```
480 lignes → ~30 lignes. -450 lignes.

---

## 🟡 #32: `paydunya.ts` — 23× METHOD ENTRIES EN HARDCODÉ

**Fichier**: `apps/api/src/adapters/payment/paydunya.ts:81-140`

Le Record `PAYDUNYA_METHODS` contient 23 entrées de méthode de paiement, chaque entrée ayant 6 champs. Les `bodyKeys` suivent un schéma cohérent : `tokenKey` = méthode + `_payment_token`, `phoneKey` = méthode + `_phone`, etc.

```typescript
om_bf: { country: "bf", label: "Orange Money Burkina Faso",
  endpoint: "orange-money-burkina",
  bodyKeys: { tokenKey: "payment_token", phoneKey: "phone_bf", nameKey: "name_bf", emailKey: "email_bf" }
},
```

Mais certaines dévient : `carte_bancaire` a des noms différents, `djamo` utilise d'autres patterns.

**Code judo move**: 
- 80% des méthodes peuvent être générées par pattern : `{method}_payment_token`, `{method}_phone`, `{method}_fullName`, `{method}_email`.
- 20% qui dévient peuvent être des overrides.
- 23 × 6 = 138 lignes → ~20 lignes de pattern + 4 lignes d'override.

---

## 🟢 #33: `paydunya.ts` — `SECURE_COMPARE` REDONDANT AVEC crypto.TIMINGSAFEEQUAL

```typescript
private _secureCompare(expected: string, actual: string): boolean {
  if (expected.length !== actual.length) return false;
  return crypto.timingSafeEqual(Buffer.from(expected, "utf8"), Buffer.from(actual, "utf8"));
}
```

Et dans `auth/index.ts` :
```typescript
function constantTimeEquals(a: string, b: string): boolean {
  const left = Buffer.from(a, "utf8");
  const right = Buffer.from(b, "utf8");
  if (left.length !== right.length) return false;
  return timingSafeEqual(left, right);
}
```

Deux implémentations de la même fonction. L'une importe `timingSafeEqual` depuis `node:crypto`, l'autre utilise `crypto.timingSafeEqual`. Devrait être une seule fonction partagée.

---

## 🟢 #34: `paydunya.ts:PAYDUNYA_METHODS` — UN `Record` COMME UNIQUE SOURCE DE VÉRITÉ

Le Record est utilisé pour:
1. `getAvailableMethods` — les méthodes disponibles
2. `executePayment` — construction des bodyKeys
3. Résolution des méthodes (SOFTPAY_METHOD_MAP)

Les méthodes apparaissent aussi dans `WITHDRAW_MODE_MAP` dans `payments/index.ts`. Il y a 4 endroits différents qui doivent connaître la liste des méthodes. Si on en ajoute une, on la modifie à 4 endroits.

---

## 📊 BARÈME DE QUALITÉ — V3

| Critère | Score | Pire offensant |
|---------|-------|---------------|
| Duplication logique | ❌ 0/10 | `_requiresProviderConfirmation` ×2, `normalizePhoneNumber` ×2, `constantTimeEquals` ×2, secureCompare ×2 |
| Taille des fichiers (>1000L) | ❌ 0/10 | **7 fichiers** maintenant (payments 1100, pro 1189, paydunya 1075, + les 4 déjà identifiés) |
| Conditionnels ad-hoc | ❌ 1/10 | `executePayment` 15 if-blocks identiques, `normalizePhoneNumber` 8 if-blocks identiques |
| DRY violation | ❌ 1/10 | CRUD boilerplate ×4, salon response ×2, SOFTPAY_METHOD_MAP 40 entries |
| **Global** | **❌ 1/10** | **Collision de nom + duplication logique = bugs garantis** |

## 🎯 TOP 5 PRIORITÉS — PART 3

1. **🔥 Fusionner `_requiresProviderConfirmation` ×2** — source unique
2. **🔥 Remplacer `normalizePhoneNumber` ×2** — renommer + dédupliquer
3. **🔥 Remplacer les 15 if-blocks de `executePayment`** par data-driven mapping
4. **🔥 Factoriser CRUD boilerplate dans `pro/index.ts`** (−450 lignes)
5. **🔥 Générer SOFTPAY_METHOD_MAP** au lieu de 40 lignes hardcodées
