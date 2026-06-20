# 🔥 Thermo-Nuclear Code Quality Review — Part 5

---

## 🔴 #48: `payment_methods_provider.dart` — OFFLINE-OPTIMISTIC MERGE PRODUIT DES DOUBLONS

**Fichier**: `apps/mobile-client/lib/src/features/profile/providers/payment_methods_provider.dart`

### Problème:

La méthode `_mergePending` fusionne les entrées de l'outbox avec les données serveur :

```dart
case 'payment_method_create':
  items = [
    PaymentMethodRecord(
      id: 'pending-${entry.id}',  // ← prefix "pending-"
      ...
    ),
    ...items,                       // ← items from server
  ];
```

**Scénario de bug #1 — Doublon garanti :**
1. L'utilisateur ajoute une méthode de paiement hors ligne → `_mergePending` ajoute un item avec `id: 'pending-xxx'`
2. L'outbox flush s'exécute → la méthode est créée sur le serveur → `refresh()` est appelée
3. Le refresh fetch la liste du serveur → l'item a un `id` réel (ex: `abc123`)
4. `_mergePending` voit la liste serveur (avec `abc123`) + l'entrée outbox (avec `pending-xxx`)
5. **L'utilisateur voit 2 entrées** pour le même moyen de paiement jusqu'à ce que l'entrée outbox soit retirée

**Scénario de bug #2 — Phantom entry :**
1. L'utilisateur crée une méthode hors ligne → outbox entry créée
2. L'outbox flush échoue (400 car doublon détecté)
3. L'outbox entry reste avec `error` mais n'est PAS retirée
4. `_mergePending` continue d'ajouter le phantom
5. L'utilisateur voit une méthode de paiement qui n'existe pas

**Scénario de bug #3 — Delete non retiré :**
1. L'utilisateur supprime une méthode hors ligne → outbox entry créée
2. Avant que l'outbox flush ait lieu, l'utilisateur refresh la page
3. Le serveur retourne la liste SANS l'item supprimé (car supprimé hors ligne et pas encore sync)
4. `_mergePending` ne voit PAS l'item dans `items` (il a déjà été retiré par le `where`)
5. Mais l'outbox entry `payment_method_delete` est toujours là → rien à merger
6. L'utilisateur ne voit pas la méthode → cohérent
7. MAIS si l'outbox flush échoue, la méthode n'est pas supprimée sur le serveur
8. Au prochain refresh, la méthode réapparaît → l'utilisateur pensait l'avoir supprimée

### Fix :
- **Ajouter un `id` réel à l'outbox entry** pour pouvoir faire le cleanup
- **Dans `_mergePending`, exclure les entrées outbox qui ont déjà été traitées** via une map `serverId ↔ outboxId`
- **Marquer les entrées échouées comme `failed`** et les montrer dans l'UI avec un badge d'erreur

---

## 🔴 #49: `app_outbox.dart` — `_generateId()` DUPLIQUÉ AVEC `_idempotencyKey()`

**Fichiers**:
- `app_outbox.dart:244-247` — `_generateId()` : `'${DateTime.now().microsecondsSinceEpoch}-${random.nextInt(1 << 32)}'`
- `payment_methods_provider.dart:183-186` — `_idempotencyKey()` : `'${DateTime.now().microsecondsSinceEpoch}-${random.nextInt(1 << 32)}'`

**Deux fonctions IDENTIQUES** dans deux fichiers différents. Même algorithme, même format, même usage.

De plus, cette méthode a des collisions potentielles :
- `microsecondsSinceEpoch` a une résolution de 1 microseconde
- `random.nextInt(1 << 32)` = 32 bits de hasard
- Si deux appels arrivent dans la même microseconde → **collision garantie** (cas fréquent si l'utilisateur ajoute 2 méthodes rapidement)

### Fix :
```dart
String _generateUuid() {
  // Utiliser un vrai UUID v4
  return '${_random.nextInt(0xffff)}${_random.nextInt(0xffff)}'
      '-${_random.nextInt(0xffff)}-4${_random.nextInt(0xfff)}'
      '-${_random.nextInt(0x3fff) | 0x8000}${_random.nextInt(0xffff)}'
      '-${_random.nextInt(0xffff)}${_random.nextInt(0xffff)}${_random.nextInt(0xffff)}';
}
```
Ou mieux : utiliser `package:uuid`.

---

## 🔴 #50: `app_outbox.dart:flush` — PAS DE MAX RETRY, FLUSH PEUT TOURNER INDÉFINIMENT

**Fichier**: `apps/mobile-client/lib/src/core/sync/app_outbox.dart:91-120`

```dart
Future<void> flush() async {
  if (_isFlushing || state.isEmpty) return;
  _isFlushing = true;
  try {
    final current = [...state];
    for (final entry in current) {
      try {
        await _dispatch(dio, entry);
        await remove(entry.id);
      } on DioException catch (error) {
        final status = error.response?.statusCode ?? 0;
        if (status >= 400 && status < 500 && status != 408 && status != 429) {
          // Client errors (except timeout/rate-limit) → mark with error, continue
          state = [...];
          await _persist();
          continue;  // ← continue = skip and retry next time
        }
        break;  // ← network/server errors → stop and retry next time
      }
    }
  } finally {
    _isFlushing = false;
  }
}
```

**Problème**: Il n'y a AUCUNE limite de tentatives. Une entrée outbox peut être retryée indéfiniment :
- `profile_avatar_upload` avec fichier supprimé → `StateError` → `catch` → `break` → retry au prochain flush
- `payment_method_create` avec 409 → `continue` → retry au prochain flush
- Si l'API est down → `break` → retry au prochain flush

**Résultat**: Une entrée peut rester dans l'outbox pendant des SEMAINES, continuant de consommer du stockage et de la batterie à chaque flush.

### Fix :
```dart
const MAX_RETRIES = 10;
// ...
for (final entry in current) {
  if ((entry.retryCount ?? 0) >= MAX_RETRIES) {
    state = [for (final item in state) if (item.id != entry.id) item];
    await _persist();
    continue; // drop permanently
  }
  // ... retry logic
}
```

---

## 🔴 #51: `app_outbox.dart:_dispatch` — `profile_avatar_upload` AVEC `salonId: ''`

```dart
case 'profile_avatar_upload':
  final mediaId = await MediaUploadService(dio).uploadSalonImage(
    salonId: '',  // ← BUG ! salonId vide
    file: XFile(path),
    purpose: 'avatar',
  );
```

`MediaUploadService.uploadSalonImage` avec `salonId: ''` va soit :
1. Échouer (si le backend valide que l'ID est un UUID valide)
2. Uploader l'image dans "aucun salon" (données orphelines)
3. Crash avec une erreur de base de données

**Fix**: Stocker le `salonId` dans le payload de l'outbox entry :
```dart
case 'profile_avatar_upload':
  final salonId = entry.payload['salonId'] as String? ?? '';
  // ...
```

---

## 🔴 #52: `payment_methods_page.dart` — 618 LIGNES POUR UNE PAGE DE LISTE

**Fichier**: `apps/mobile-client/lib/src/features/profile/pages/payment_methods_page.dart`

### Problèmes :

**1. 2× bottom sheet quasi-identiques** (`_showAddSheet` + `_showEditSheet`) :
Chacun fait ~150 lignes avec la même structure :
```
SafeArea → SingleChildScrollView → Form → Column( Dropdown, PhoneField, Button )
```
**300 lignes de formulaire dupliquées** pour add et edit.

**2. `_addMethod` fait tout** : validation, appel API, snackbar, navigation, goBack, returnTo — 50 lignes dans une closure.

**3. `_resolveChannelLabel`, `_resolveChannelCountry`, `_resolveExistingChannel`, `_resolveChannelCountryForCode`** :
**4 helpers** qui font tous des `firstWhere`/`orElse` sur `channelItems`. `_resolveChannelLabel` et `_resolveChannelCountry` créent même un faux `PaydunyaMethodRecord` par défaut avec la même syntaxe.

**4. `WidgetsBinding.instance.addPostFrameCallback` dans `build()`** pour mettre à jour `_channel` :
```dart
if (channelItems.isNotEmpty && !channelItems.any((item) => item.code == _channel)) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) setState(() => _channel = channelItems.first.code);
  });
}
```
Mutating state pendant un build → risque de boucle infinie.

### Fix :
- Extraire `_BasePaymentFormSheet` réutilisable pour add/edit
- Fusionner les 4 `_resolve*` helpers en 1 helper générique
- Remplacer `WidgetsBinding.instance.addPostFrameCallback` dans build par un `didUpdateWidget` ou `Future.microtask`

---

## 🔴 #53: `booking_actions_provider.dart` — PROVIDER INUTILE + ZERO ERROR HANDLING

**Fichier**: `apps/mobile-client/lib/src/features/appointments/providers/booking_actions_provider.dart`

### Problèmes :

**1. Provider inutile :**
```dart
final bookingActionsProvider = Provider<BookingActions>(
  (ref) => BookingActions(ref),
);
```
`BookingActions` n'a AUCUN état — c'est juste une collection de 3 méthodes. Pourquoi est-ce un Provider Riverpod ? Chaque fois qu'on veut appeler `cancel`, on doit faire :
```dart
ref.read(bookingActionsProvider).cancel(id);
```
Ceci crée une instance inutile + overhead de Provider. Les méthodes devraient être des fonctions standalone ou un simple helper :

```dart
Future<void> cancelBooking(Ref ref, String bookingId) async {
  final dio = ref.read(dioProvider);
  await dio.post('/api/v1/bookings/$bookingId/cancel');
  ref.invalidate(bookingsListProvider);
  ref.invalidate(bookingDetailProvider(bookingId));
}
```

**2. Zero error handling :**
```dart
Future<void> cancel(String bookingId) async {
    final dio = _ref.read(dioProvider);
    await dio.post('/api/v1/bookings/$bookingId/cancel');
    // if this throws, the widget crashes
}
```

Aucun `try/catch`, aucun `handleHttpError`, aucun fallback. Si l'API est down, l'utilisateur voit un écran rouge.

**3. Pas d'optimistic update :**
Après chaque action, TOUS les providers sont invalidés → **rechargement complet depuis le serveur**. Sur réseau lent (3G au Sénégal), l'utilisateur voit un spinner pendant 5-10 secondes.

### Fix :
```dart
Future<void> cancelBooking(Ref ref, String bookingId) async {
  try {
    final dio = ref.read(dioProvider);
    await dio.post('/api/v1/bookings/$bookingId/cancel');
    // Optimistic update
    ref.read(bookingsListProvider.notifier).removeOptimistic(bookingId);
    ref.invalidate(bookingDetailProvider(bookingId));
  } on DioException catch (e) {
    // Rollback
    ref.invalidate(bookingsListProvider);
    rethrow;
  }
}
```

---

## 🔴 #54: `booking_create_provider.dart:BackgroundPollingService` — TIMER PERDU, 45 MIN DE FAUX NÉGATIFS

**Fichier**: `apps/mobile-client/lib/src/features/booking/providers/booking_create_provider.dart:123-215`

### Problèmes :

**1. Le Notifier peut être disposé :**
```dart
class BackgroundPollingService extends Notifier<BackgroundPollingStatus> {
  Timer? _timer;
  // ...
  Future<void> _runCheck() async {
    final status = await ref.read(paymentInitiateProvider.notifier).reconcile(paymentId);
    // ref might be disposed → throws StateError
  }
}
```
Si aucun widget ne regarde `backgroundPollingProvider`, le `Notifier` est disposé. Le `Timer` continue mais la callback utilise `ref.read()` qui jette une erreur. Le timer devient un leak mémoire.

**2. `_exhausted` après 45 min seulement :**
3 tentatives × 15 min = 45 min max. Si le paiement réussit à la minute 46, l'utilisateur reçoit un "Paiement échoué" indû et voit l'écran "Vérifiez votre paiement" alors que tout va bien.

**3. `ForegroundNotificationService.plugin.show` sans vérification :**
```dart
ForegroundNotificationService.plugin.show(id: ..., ...);
```
Si `plugin` est `null` (pas initialisé), ceci jette une exception non catchée dans `_runCheck` → le timer s'arrête prématurément.

**4. `reconcile` non idempotent :**
```dart
Future<String?> reconcile(String paymentId) async {
  final response = await dio.post('/api/v1/payments/$paymentId/reconcile');
  return response.data?['status'] as String?;
}
```
`reconcile` POST est censé être un GET. Si le réseau est lent, POST peut créer des side effects indésirables (double reconciliation).

### Fix :
- Utiliser `ref.onDispose(() => _timer?.cancel())` dans `build()` pour cleanup propre
- `reconcile` → `GET` au lieu de `POST` (requête idempotente)
- Augmenter `_maxAttempts` à 10+ ou utiliser un backoff exponentiel
- Vérifier `ForegroundNotificationService.plugin != null` avant d'appeler `show`
- Ajouter un polling côté serveur pour les cas d'échec

---

## 🔴 #55: `pro/bookings.ts:createManualBooking` — 130 LIGNES MONOLITHES

**Fichier**: `apps/api/src/modules/pro/bookings.ts:209-329`

### Problème :

La méthode `createManualBooking` fait TOUT en 130 lignes :
1. **Validation**: service, employee + specialties, slot availability
2. **Résolution client**: recherche par phone → création si inexistant → validation rôle
3. **Calcul deposit**: `calcDepositAmount(service)`
4. **Création booking**: transaction avec dates, status, notes
5. **Création payment manuel**: si deposit > 0
6. **Création booking event**

C'est **6 responsabilités dans une seule fonction**.

### Code judo move :
```typescript
private async _resolveClient(
  tx: PrismaTx, body: { clientId?: string; clientPhone?: string; clientName?: string }
): Promise<string> { ... }

private async _validateSlot(
  salonId: string, service: Service, employeeId?: string, startsAt: Date
): Promise<void> { ... }

private async _createBookingWithDeposit(
  tx: PrismaTx, params: CreateBookingParams
): Promise<Booking> { ... }

async createManualBooking(request, reply) {
  // ~20 lines of orchestration
}
```

---

## 🟡 #56: `pro/bookings.ts:listBookings` — `where.id = "none"` MAGIC STRING

```typescript
if (role === "salon_staff") {
  const employee = await prisma.employee.findFirst({ where: { userId, salonId } });
  if (employee) {
    where.employeeId = employee.id;
  } else {
    where.id = "none";  // ← magic string
  }
}
```

Si un salon_employee avec userId non lié à un employee existe, `where.id = "none"` est défini. Si un salon avec `id: "none"` existe dans la DB, ces réservations sont retournées par erreur.

### Fix :
```typescript
where.id = "00000000-0000-0000-0000-000000000000"; // UUID impossible
// Ou mieux:
where.employeeId = "__none__"; // ne match jamais
```

---

## 🟡 #57: `pro/bookings.ts:transitionBooking` — `afterHook` FERMETURE DANGEREUSE

```typescript
async function transitionBooking(
  request, reply,
  allowedFrom: string[], toStatus: string, eventType: string,
  afterHook?: (bookingId, tx) => Promise<void>
) { ... }
```

La fonction `afterHook` accède à `booking.id` qui a été lu **hors de la transaction**. Ce pattern est correct parce que `updateMany` avec `where: { status: { in: allowedFrom } }` garantit le verrouillage optimiste. Mais si l'`afterHook` fait des lectures qui dépendent de l'état PRÉ-transition, il lit des données obsolètes.

Dans `acceptBooking` :
```typescript
afterHook: async (bookingId, tx) => {
  const b = await tx.booking.findUnique({ where: { id: bookingId } });
  // b.startsAt est lu DANS la transaction → OK
}
```
C'est correct ici car la relest dans la transaction. Mais c'est un pattern dangereux à maintenir.

---

## 🟢 #58: `api_client_provider.dart` — 10 LIGNES INUTILES

**Fichier**: `apps/mobile-client/lib/src/core/network/api_client_provider.dart`

```dart
final apiClientProvider = Provider<BeauteavenueApi>((ref) {
  final dio = ref.watch(dioProvider);
  return BeauteavenueApi(dio: dio, interceptors: []);
});
```

Ce provider est une thin wrapper qui ne fait QUE créer `BeauteavenueApi`. L'appelé peut aussi bien le créer directement :
```dart
final api = BeauteavenueApi(dio: ref.read(dioProvider));
```

C'est utilisé dans :
- `booking_create_provider.dart:33` — `ref.read(apiClientProvider).getBookingsApi()`
- Probablement ailleurs

Si `BeauteavenueApi` est juste un wrapper autour de Dio, ce provider ajoute de l'indirection sans bénéfice.

---

## 🟢 #59: `booking_create_provider.dart:execute` — SYNTAXE DART 3 NON STANDARD

```dart
data: {
  'paymentId': paymentId,
  'method': method,
  'details': ?details,  // ← Dart 3 null-aware syntax ?
},
```

Et dans `booking_actions_provider.dart` :
```dart
data: {'rating': rating, 'comment': ?comment},
```

Le `?value` en position de valeur de map n'est PAS du Dart standard valide. Dart 3 a la syntaxe `?element` pour les **éléments** de collection (null-aware elements), pas pour les **valeurs** de map. Le compilateur va interpréter `?details` comme une expression ternaire, ce qui est une erreur de syntaxe.

**Ces fichiers ne compilent PAS** si cette syntaxe est invalide. Ou alors ce code utilise une feature Dart expérimentale non documentée.

---

## 📊 BARÈME DE QUALITÉ — V5 (FINAL)

| Critère | Score | Pire offensant |
|---------|-------|---------------|
| Bugs garantis | ❌ 0/10 | Doublon outbox merge, `salonId: ''`, `?details` syntax error, `where.id = "none"` |
| Fuites mémoire | ❌ 2/10 | `BackgroundPollingService` timer jamais disposé, controllers non disposés dans `_showAddSheet` |
| Crash potentiels | ❌ 2/10 | `plugin.show` sans null-check, `ref.read` après dispose, zero error handling ×3 |
| Duplication | ❌ 0/10 | `_generateId()` ×2, bottom sheets ×2, `_resolve*` helpers ×4 |
| **Global** | **❌ 0/10** | **Produit en production avec 6+ bugs garantis** |

## 🎯 TOP 5 PRIORITÉS — PART 5

1. **🔥🔥🔥 `app_outbox.dart:profile_avatar_upload` avec `salonId: ''`** — Bug garanti, upload vers nulle part
2. **🔥🔥🔥 `payment_methods_provider.dart` doublon merge** — L'utilisateur peut voir 2× le même moyen de paiement
3. **🔥🔥🔥 `booking_actions_provider.dart` zero error handling** — 3 endpoints sans protection, crash garanti
4. **🔥🔥 `BackgroundPollingService` dispose leak** — Timer continue après dispose du Notifier
5. **🔥🔥 `?details` syntax non standard** — Peut ne pas compiler selon la version de Dart
