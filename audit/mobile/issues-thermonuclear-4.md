# 🔥 Thermo-Nuclear Code Quality Review — Part 4

---

## 🔴 #35: `search/index.ts` × `catalog/index.ts` — 4 HELPERS DUPLIQUÉS (2 000 LIGNES DE RECHERCHE PARALLÈLE)

**Fichiers**:
- `apps/api/src/modules/search/index.ts` (822 lignes)
- `apps/api/src/modules/catalog/index.ts` (628 lignes)

### Problème:

**QUATRE** (4!) helpers de recherche sont copiés-collés dans les deux fichiers :

| Helper | `search/index.ts` | `catalog/index.ts` |
|--------|-------------------|--------------------|
| `buildPrefixQuery` | Lignes 16-25 | Lignes 52-60 |
| `buildSearchVecAndQuery` | Lignes 27-40 | Lignes 63-74 |
| `searchFilterWhere` / `searchFilter` | Lignes 42-72 | Lignes 77-97 |
| `searchRankExpr` / `searchRank` | Lignes 74-82 | Lignes 100-104 |

Chaque copie est IDENTIQUE à l'exception :
- `searchFilterWhere` utilise un `tableAlias` paramétrable ; `searchFilter` non.
- `searchFilterWhere` utilise `similarity > 0.2` ; `searchFilter` utilise `similarity > 0.25`.

**Bug potentiel**: Si un helper est modifié dans un fichier mais pas dans l'autre (ex: ajuster le seuil de similarité), les résultats de recherche divergent sans aucun avertissement.

### Impact:
Le `CatalogController.list` est marqué `@deprecated` (sunset: 2026-09-01) — c'est **628 lignes de code en production** qui existent uniquement pour la rétrocompatibilité. Le fichier `search/index.ts` est la version active. Mais le catalogue tourne toujours avec sa propre copie + ses propres helpers.

### Code judo move:
1. **Extraire les 4 helpers** dans un fichier partagé : `apps/api/src/lib/search-helpers.ts`
2. **Supprimer les doublons** dans `catalog/index.ts` et `search/index.ts`
3. **Importer depuis le fichier partagé**
4. Si `catalog/list` est deprecated, envisager de supprimer carrément la branche `list` entière plutôt que de maintenir le code mort.

**Résultat**: −200 lignes de duplication, 1 source de vérité pour les helpers FTS.

---

## 🔴 #36: `catalog/index.ts:list` — 4× CACHE RESPONSES DUPLIQUÉES

**Fichier**: `apps/api/src/modules/catalog/index.ts`

Chacune des 4 branches de `CatalogController.list` (nearby, trending, prestige, rating) se termine PAR LES MÊMES 3 LIGNES :

```typescript
await setCachedJsonWithTags({ key: cacheKey, value: payload, ttlSeconds: config.cacheTtlCatalogSeconds, tags: ["catalog:list"] });
reply.header("x-cache", "MISS");
return ok(reply, payload);
```

C'est **4× 3 lignes = 12 lignes** de duplication. Si le format de cache change, il faut modifier 4 endroits. Si un nouveau sort est ajouté, le pattern est recopié une 5ème fois.

### Code judo move:
```typescript
private async cachedResponse<T>(cacheKey: string, payload: T, reply: FastifyReply) {
  await setCachedJsonWithTags({ key: cacheKey, value: payload, ttlSeconds: config.cacheTtlCatalogSeconds, tags: ["catalog:list"] });
  reply.header("x-cache", "MISS");
  return ok(reply, payload);
}
```

**Résultat**: 12 lignes → 1 appel de méthode par branche.

---

## 🔴 #37: `catalog/index.ts:list` — 4× SÉLECTIONS DE CHAMPS DUPLIQUÉES

Chacune des 4 branches dans `list` mappe les résultats avec exactement les mêmes champs :

```typescript
items: rows.map((r) => ({
  id: r.id, name: r.name, category: r.category, logoUrl: r.logoUrl,
  city: r.city, neighborhood: r.neighborhood, averageRating: Number(r.averageRating),
  reviewCount: Number(r.reviewCount),
  latitude: r.latitude, longitude: r.longitude,
  subscriptionTier: r.subscriptionTier,
  featured: r.subscriptionTier === "premium",     // ← transform
  isPrestige: r.isPrestige,
  prestigeScore: r.prestigeScore != null ? Number(r.prestigeScore) : null,
  distanceKm: ...                                   // ← varies per branch
}))
```

Ce bloc de ~15 lignes est dupliqué 4× avec une seule variation (`distanceKm` et parfois `trending_score`). Le `filter(Boolean)` implicite via l'expression ternaire est fragile.

### Code judo move:
```typescript
private mapSalonRow(r: any, extra: { distanceKm?: number | null } = {}) {
  return {
    id: r.id, name: r.name, category: r.category, logoUrl: r.logoUrl,
    city: r.city, neighborhood: r.neighborhood, averageRating: Number(r.averageRating),
    reviewCount: Number(r.reviewCount), latitude: r.latitude, longitude: r.longitude,
    subscriptionTier: r.subscriptionTier, featured: r.subscriptionTier === "premium",
    isPrestige: r.isPrestige, prestigeScore: r.prestigeScore != null ? Number(r.prestigeScore) : null,
    distanceKm: extra.distanceKm ?? null
  };
}
```

**Résultat**: 60 lignes → 1 fonction + 4 appels.

---

## 🔴 #38: `client/index.ts` — `normalizePhoneNumber` 3ÈME DUPLICATION

**Fichier**: `apps/api/src/modules/client/index.ts:37-39`

```typescript
function normalizePhoneNumber(phoneNumber: string) {
  return phoneNumber.replace(/\s+/g, "").trim();
}
```

C'est la **3ème implémentation** du `normalizePhoneNumber` dans le backend :
1. `payments/index.ts:25` → `.replace(/\s+/g, "").trim()` ✓ identique
2. `paydunya.ts:14` → supprime code pays + whitespace (différent)
3. `client/index.ts:37` → `.replace(/\s+/g, "").trim()` ✓ identique à #1

**#1 et #3 sont des copies conformes** — même nom, même comportement, écrites indépendamment.

Le `normalizePhoneNumber` est utilisé dans `createPaymentMethod` pour normaliser les numéros de téléphone des moyens de paiement. Si le comportement change dans un fichier mais pas dans l'autre, les paiements peuvent être créés avec des numéros non normalisés.

**Code judo move**: Exporter depuis un fichier partagé (`lib/phone.ts` ou utiliser celui de `payments/index.ts`).

---

## 🔴 #39: `client/index.ts:createPaymentMethod` — IDEMPOTENCY HEADER FRAGILE + DANGEREUX

**Fichier**: `apps/api/src/modules/client/index.ts:107-112`

```typescript
const headerBag = ((request as unknown as { headers?: Record<string, unknown>; raw?: { headers?: Record<string, unknown> } }).headers
  ?? (request as unknown as { raw?: { headers?: Record<string, unknown> } }).raw?.headers
  ?? {}) as Record<string, unknown>;
const idempotencyKey = typeof idempotencyHeader === "string" ? idempotencyHeader : idempotencyHeader?.toString();
```

Ce code tente d'extraire un header `x-idempotency-key` avec 3 niveaux de fallback sur `request.headers`, `request.raw?.headers`, et des types assertions dangereuses (`as unknown as`). En Fastify, `request.headers` retourne `FastifyRequest['headers']` qui est déjà un objet `IncomingHttpHeaders` — ce code est inutilement compliqué.

Si Fastify change le comportement de `request.headers`, ce code casse silencieusement.

### Code judo move:
```typescript
const idempotencyKey = typeof request.headers["x-idempotency-key"] === "string"
  ? (request.headers["x-idempotency-key"] as string)
  : null;
```

**Résultat**: 6 lignes → 2 lignes, zéro type assertion.

---

## 🔴 #40: `client/index.ts:createPaymentMethod` — RACE CONDITION SUR `hasDefault`

**Fichier**: `apps/api/src/modules/client/index.ts:124-138`

```typescript
const hasDefault = await prisma.clientPaymentMethod.count({ where: { userId: session.sub, isDefault: true } });
// ... idempotency check ...
created = await prisma.$transaction(async (tx) => {
  if (!hasDefault) {
    await tx.clientPaymentMethod.updateMany({ where: { userId: session.sub }, data: { isDefault: false } });
  }
  return tx.clientPaymentMethod.create({ ... });
});
```

Le `hasDefault` est lu **en dehors de la transaction**. Si deux requêtes arrivent en même temps pour le même utilisateur sans méthode par défaut :
1. Requête A lit `hasDefault = 0`
2. Requête B lit `hasDefault = 0` 
3. Requête A crée la méthode avec `isDefault: true`
4. Requête B crée aussi la méthode avec `isDefault: true`
5. → 2 méthodes par défaut pour le même utilisateur !

### Code judo move:
Le `updateMany({ isDefault: false })` dans la transaction n'est pas conditionnel au `hasDefault` vu hors transaction. Déplacer TOUTE la logique dans la transaction et utiliser un comptage atomique :

```typescript
await prisma.$transaction(async (tx) => {
  const existingDefault = await tx.clientPaymentMethod.count({ where: { userId: session.sub, isDefault: true } });
  if (!existingDefault) {
    // pas besoin de updateMany — aucune méthode par défaut n'existe
  } else if (body.isDefault !== false) {
    // only clear defaults if the new method should be default
    await tx.clientPaymentMethod.updateMany({ ... });
  }
  return tx.clientPaymentMethod.create({ ... });
});
```

---

## 🔴 #41: `salon_detail_page.dart` — 875 LIGNES POUR UNE SEULE PAGE AVEC 6 WIDGETS PRIVÉS

**Fichier**: `apps/mobile-client/lib/src/features/discovery/pages/salon_detail_page.dart`

### Problèmes :

**1. 5 widgets privés** qui devraient être réutilisés :
- `_CircleBtn` — bouton circulaire avec icône (utilisé 3× dans le SliverAppBar)
- `_SectionLabel` — simple `Text` avec `headlineSm` style (utilisé 5×)
- `_InlineStats` — 2 statuts avec icônes (utilisé 1× — spécifique)
- `_ServiceRow` — nom + durée + prix (utilisé 1× — pourrait être partagé avec d'autres listes de services)
- `_BottomCta` — CTA en bas d'écran (utilisé dans d'autres pages de booking)

`_CircleBtn` est particulièrement flagrant : c'est un composant extrêmement commun (bouton icône rond avec fond blanc et ombre) qui est probablement recréé dans d'autres pages.

**2. `_GalleryViewer`** — 100+ lignes de code pour un viewer d'images en plein écran. Si une autre page veut afficher des images en plein écran (ex: photos de profil), elle doit recréer ce widget.

**3. La méthode `build` fait ~400 lignes** avec un arbre de widget extrêmement profond (10+ niveaux d'imbrication). C'est presque impossible à lire sans IDE.

### Code judo move:
```dart
// Extraire les widgets génériques:
// 1. CircleIconButton → core/widgets/app_circle_icon_button.dart
// 2. SectionLabel → core/widgets/app_section_label.dart
// 3. GalleryViewer → core/widgets/app_gallery_viewer.dart (props: images, initialIndex)
// 4. ServiceRow → core/widgets/app_service_row.dart (props: name, duration, price)
// 5. BottomCta → core/widgets/app_sticky_cta.dart (props: price, onBook)

// Résultat: salon_detail_page.dart ~400 lignes, 5 widgets réutilisables extraits
```

---

## 🟡 #42: `pro/subscription.ts` — `subscriptionCheckout` 130 LIGNES MONOLITHES

**Fichier**: `apps/api/src/modules/pro/subscription.ts`

La méthode `subscriptionCheckout` fait TOUT dans une seule fonction de 130 lignes :
1. Auth (ensurePro)
2. Guard checks (5 if-blocks pour les validations d'état)
3. Pricing (4-level ternary pour priceKey)
4. Free tier bypass (idempotency + charge création)
5. Existing charge resumption
6. Charge creation/update
7. Payment initiation
8. Pending tier update

Ceci devrait être **au moins 3 méthodes** :
```
_subscriptionCheckout(params) → guard()
_validTransition(sub, action) → state machine
_calculatePrice(action, tier, cycle) → price calculator
_initiateCharge(charge, owner) → payment handler
```

---

## 🟡 #43: `pro/subscription.ts` — `priceKey` 4-LEVEL TERNARY

```typescript
const priceKey = body.action === "upgrade"
  ? "subscription_premium_price_xof"
  : body.action === "activate" && body.tier === "premium"
    ? "subscription_premium_price_xof"
    : body.action === "renewal" && sub.tier === "premium"
      ? "subscription_premium_price_xof"
      : "subscription_standard_price_xof";
```

3 branches sur 4 retournent `"subscription_premium_price_xof"`. Réécriture possible :

```typescript
const isPremiumAction = body.action === "upgrade" 
  || body.tier === "premium" 
  || (body.action === "renewal" && sub.tier === "premium");
const priceKey = isPremiumAction 
  ? "subscription_premium_price_xof" 
  : "subscription_standard_price_xof";
```

**Résultat**: 9 lignes → 3 lignes.

---

## 🟡 #44: `pro/subscription.ts:subscriptionCheckout` — 6 GUARD IF-BLOCKS AU LIEU D'UNE STATE MACHINE

```typescript
if (body.action === "activate" && sub.status === "active") { ... }
if (body.action === "upgrade" && sub.tier === "premium") { ... }
if (body.action === "upgrade" && sub.tier === "standard" && sub.pendingTier === "premium") { ... }
if (body.action === "renewal" && sub.isComplimentary) { ... }
if (body.action === "downgrade") { ... }
```

Chaque nouvel `action` ajoute un if-block supplémentaire. Les transitions possibles sont implicites — personne ne peut savoir quelles transitions sont valides sans lire les 50 lignes de guards.

### Code judo move:
```typescript
const VALID_TRANSITIONS: Record<string, string[]> = {
  activate: ["inactive", "cancelled", "expired"],
  upgrade: ["active"],
  downgrade: ["active"],
  renewal: ["active"],
};

const allowed = VALID_TRANSITIONS[body.action];
if (!allowed || !allowed.includes(sub.status)) {
  fail(reply, 409, "invalid_transition", `Impossible de ${body.action} depuis le statut ${sub.status}.`);
  return;
}
```

---

## 🟡 #45: `pro/subscription.ts:downloadInvoicePdf` — PDF GÉNÉRÉ À CHAQUE REQUÊTE

```typescript
const pdf = await buildInvoicePdf({ ... });
```

Aucun cache. Si un salon propriétaire télécharge la même facture 10 fois, le PDF est régénéré 10 fois. Avec `buildInvoicePdf` qui pourrait prendre 100-500ms, c'est un gouffre de performance inutile.

### Code judo move:
```typescript
const pdfCacheKey = `invoice:pdf:${params.invoiceId}`;
const { value: pdfBuffer, cacheStatus } = await getOrSetCachedJson({
  key: pdfCacheKey,
  ttlSeconds: 86400, // 24h
  tags: [`invoice:${params.invoiceId}`],
  load: () => buildInvoicePdf({ ... })
});
// Store as Buffer, not JSON — or use Redis binary cache
```

---

## 🟢 #46: `client/index.ts` — `deletePaymentMethod` ET `deleteAddress` SHARED DEFAULT PROMOTION PATTERN

**Fichier**: `apps/api/src/modules/client/index.ts`

Les deux méthodes `deletePaymentMethod` et `deleteAddress` partagent exactement la même logique transactionnelle :

```typescript
await prisma.$transaction(async (tx) => {
  await tx.xxx.delete({ where: { id: params.xxxId } });
  if (existing.isDefault) {
    const next = await tx.xxx.findFirst({
      where: { userId: session.sub },
      orderBy: { createdAt: "asc" }
    });
    if (next) {
      await tx.xxx.update({ where: { id: next.id }, data: { isDefault: true } });
    }
  }
});
```

Même structure, seuls `xxx` change. Ceci devrait être une fonction générique :

```typescript
async function deleteWithDefaultPromotion<T extends { id: string; isDefault: boolean }>(
  model: { delete: (args: any) => Promise<any>; findFirst: (args: any) => Promise<T | null>; update: (args: any) => Promise<any> },
  id: string, 
  userId: string,
  orderField: "createdAt"
) { ... }
```

**Résultat**: 30 lignes dupliquées → 1 fonction + 2 appels.

---

## 🟢 #47: `client/index.ts:deleteAccount` — HARDCODED PII ANONYMIZATION PATTERN

```typescript
await prisma.$transaction([
  prisma.user.update({
    where: { id: session.sub },
    data: { fullName: "Deleted User", email: `deleted+${session.sub}@beauteavenue.local`, phone: null }
  }),
  prisma.clientProfile.deleteMany({ where: { userId: session.sub } }),
  prisma.session.deleteMany({ where: { userId: session.sub } }),
  prisma.pushToken.deleteMany({ where: { userId: session.sub } }),
  prisma.clientAddress.deleteMany({ where: { userId: session.sub } }),
  prisma.clientBenefit.deleteMany({ where: { userId: session.sub } }),
  prisma.booking.updateMany({ where: { clientId: session.sub }, data: { clientNote: null } })
]);
```

C'est une liste de 7 opérations. Chaque fois qu'on ajoute une nouvelle table avec des données PII, cette méthode doit être mise à jour. Et il n'y a AUCUNE vérification que les review, favorite, ou booking records ont été traités.

**Code judo move**: Utiliser une approche data-driven basée sur les relations Prisma :
```typescript
const DELETION_POLICY: Array<{ table: string; action: 'delete' | 'anonymize'; fields?: string[] }> = [
  { table: 'user', action: 'anonymize', fields: ['fullName', 'email', 'phone'] },
  { table: 'clientProfile', action: 'delete' },
  { table: 'session', action: 'delete' },
  // ...
];
```
Ou au moins documenter que cette liste doit être maintenue avec le schéma.

---

## 📊 BARÈME DE QUALITÉ — V4

| Critère | Score | Pire offensant |
|---------|-------|---------------|
| Duplication de code | ❌ 0/10 | **4 helpers FTS ×2** (search + catalog), `normalizePhoneNumber` ×3, default promotion ×2, cache response ×4, salon mapper ×4 |
| Taille des fichiers (>800L) | ❌ 0/10 | **10 fichiers**: admin/data 1547, auth/index 1391, pro/index 1189, payments/index 1100, paydunya 1075, search/index 822, salons+pro/subscription 835/834, salon_detail 875, catalog 628 |
| Conditionnels ad-hoc | ❌ 1/10 | `subscriptionCheckout` 6 guards, `list` 4 branches, `createPaymentMethod` idempotency handling |
| Conception monolithe | ❌ 0/10 | `CatalogController.list` 4 branches parallèles, `subscriptionCheckout` 130 lignes |
| **Global** | **❌ 1/10** | **Parallélisme de code mort + race condition garantie** |

## 🎯 TOP 5 PRIORITÉS — PART 4

1. **🔥 Extraire les 4 helpers FTS** (`buildPrefixQuery`, `buildSearchVecAndQuery`, `searchFilter`, `searchRank`) dans `apps/api/src/lib/search-helpers.ts` et supprimer les doublons dans `catalog/index.ts` et `search/index.ts`
2. **🔥 Extraire `normalizePhoneNumber`** dans `lib/phone.ts` — éliminer la 3ème duplication
3. **🔥 Extraire les widgets réutilisables** de `salon_detail_page.dart` — `_CircleBtn`, `_SectionLabel`, `_GalleryViewer`, `_ServiceRow`, `_BottomCta`
4. **🔥 Remplacer `hasDefault` race condition** dans `createPaymentMethod` — déplacer la vérification dans la transaction
5. **🔥 Extraire `cachedResponse` et `mapSalonRow`** de `catalog/index.ts` — éliminer 4× duplication
