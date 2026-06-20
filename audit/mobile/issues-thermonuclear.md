# 🔥 Thermo-Nuclear Code Quality Review

Strict maintainability audit. Focus: abstraction quality, spaghetti, file size, code judo opportunities.

---

## 🔴 #1: `payment_handoff_page.dart` — 1663 LINES — CRITICAL FILE BLOAT

**Fichier**: `apps/mobile-client/lib/src/features/booking/pages/payment_handoff_page.dart`

**1663 lignes.** C'est le fichier le plus problématique du projet. Il viole TOUTES les règles de quality.

### Problèmes identifiés:

| Métrique | Valeur | Seuil acceptable |
|---|---|---|
| Lignes | 1663 | < 500 |
| Méthodes dans `_PaymentHandoffPageState` | ~25 | < 10 |
| Longueur de `_pay()` | ~300 lignes | < 50 |
| TextEditingController | 8 | < 3 |
| `if`/`else` imbriqués dans `_pay()` | 12+ niveaux | < 3 |
| Responsabilités | ~6 (form, launch, poll, OTP, error, navigation) | 1 |

### Ce fichier contient:
1. **3 formulaires différents** (carte bancaire, wallet, mobile money) — devraient être des widgets séparés
2. **Système de lancement URL** au complet (non-browser, external app, fallback, candidate iteration)
3. **2 systèmes de polling** (modal `PaymentWaitingSheet` + `BackgroundPollingService`)
4. **Constructeur de dialog OTP** inline (Pinput avec validation)
5. **Gestionnaire d'erreurs** avec 7 cas dans un switch
6. **Détection de channel payment** (`_channelFromMethod`)
7. **Inférence de pays Djamo** (`_inferDjamoCountryCode`, `_inferDjamoCountryCodeFromMethod`)
8. **Formatteur de numéro de carte** inline
9. **Barre de navigation** avec 3 états (loading, error, normal)

### Code judo move:

**Extraire `PaymentOrchestrator`**: Toute la logique `_pay()` (300 lignes) devrait être une machine à états :
```
Idle → Initiating → Executing → AwaitingProvider → Polling → Confirmed/Failed
```
Chaque transition est une méthode. Le widget `_pay()` devient `orchestrator.execute(channel, details)`.

**Extraire 4 composants**:
- `CardPaymentForm` (carte bancaire)
- `WalletPaymentForm` (paydunya wallet)
- `MobileMoneyForm` (wave, orange, etc.)
- `PaymentErrorHandler` (switch-case des codes erreur)

**Résultat**: 1663 → ~400 lignes. 6 responsabilités → 1.

---

## 🔴 #2: `booking_funnel_sheet.dart` — 1363 LINES — SECOND BLOCKBUSTER

**Fichier**: `apps/mobile-client/lib/src/features/booking/widgets/booking_funnel_sheet.dart`

### Problèmes:
- **1363 lignes** pour un widget "sheet" (feuille modale)
- Fichier gère: score d'employé, affichage temps réel des slots, sélection créneau, résumé réservation, navigation entre étapes
- Mélange présentation + logique métier + scoring algorithm

### Code judo move:
- Extraire `StaffScoreEngine` dans `booking/utils/staff_scorer.dart`
- Extraire chaque étape du funnel en widget indépendant: `FunnelServiceStep`, `FunnelStaffStep`, `FunnelSlotStep`, `FunnelReviewStep`
- Le fichier principal devient un orchestrateur qui compose les 4 étapes

---

## 🔴 #3: `_pay()` — 300 LIGNES DANS UNE SEULE MÉTHODE

**Fichier**: `payment_handoff_page.dart:1186-1480`

```dart
Future<void> _pay() async {
  // ~300 lignes avec:
  // - Validation inline (pci-dss, phone, carte, wallet)
  // - Initiation paiement
  // - Vérification status existing
  // - Construction details par méthode (4 branches)
  // - Execution paiement
  // - 3 stratégies de launch URL différentes
  // - Dialog OTP Wizall inline
  // - Polling
  // - 3 niveaux de try/catch imbriqués
  // - Gestion d'erreur par code
}
```

### Problème structurel:
Ce n'est pas une méthode, c'est un programme entier inline. Impossible de tester unitairement. Impossible de raisonner sur le flow. Le moindre changement casse tout.

### Code judo:
```dart
Future<void> _pay() async {
  if (!_validateInputs()) return;
  setState(() => _isProcessing = true);
  try {
    final paymentId = await _initiatePayment();
    await _executeAndHandle(paymentId);
  } catch (e) {
    await _handlePaymentError(e);
  } finally {
    if (mounted) setState(() => _isProcessing = false);
  }
}
```
~20 lignes au lieu de 300. Chaque sous-méthode (~30-50 lignes) est testable individuellement.

---

## 🟡 #4: `BookingFunnelState` — OBJET D'ÉTAT SUR-DÉCOMPOSÉ

**Fichier**: `apps/mobile-client/lib/src/features/booking/providers/booking_funnel_provider.dart`

### Problèmes:
- **13 champs nullables** → 13 `??` à chaque consommation
- **`copyWith` avec 15 paramètres + 2 flags** (`clearEmployee`, `clearSlot`)
- **Aucun invariant enforce** : on peut avoir `servicePrice` sans `serviceName`
- **`canReview`** check salonId, serviceId, slotStartsAtIso MAIS PAS servicePrice, serviceDurationMinutes

### Code judo move:
```dart
class BookingFunnelState {
  final String? salonId;
  final ServiceInfo? service;   // ← groupé : name + price + duration
  final EmployeeInfo? employee; // ← groupé : id + name  
  final SlotInfo? slot;         // ← groupé : date + time + iso + deposit
  // 3 champs au lieu de 13
}
```
Plus besoin de `copyWith(clearEmployee: true, clearSlot: true)` — sélectionner un nouveau service reset `this.service`, ce qui cascade `employee` et `slot` à null automatiquement.

---

## 🟡 #5: `EngagementNotificationService` — SERVICE STATIQUE COUPLÉ À HIVE

**Fichier**: `apps/mobile-client/lib/src/core/services/engagement_notification_service.dart` (~454 lignes)

### Problèmes:
- **100% statique** → impossible à mocker/tester
- **Lit Hive directement** via `AppModelCache.getMap()` → crash si box pas ouverte
- **Méthode `handleAppResumed()`** : lit/écrit `AppCache.settings` (singleton global)
- **`_readProfile()`** : accès statique qui peut lever `HiveError` non rattrapé
- **`syncPrestigeCandidate(WidgetRef ref)`** : prend un Riverpod ref en paramètre → mélange les couches

### Code judo move:
```dart
// Avant : 100% static
EngagementNotificationService.handleAppResumed();

// Après : injecté via Riverpod
class EngagementNotificationService {
  EngagementNotificationService(this._cache, this._api);
  final AppCache _cache;
  final SearchApi _api;
  void handleAppResumed() { ... }
}
final engagementServiceProvider = Provider((ref) => EngagementNotificationService(
  ref.read(appCacheProvider),
  ref.read(apiClientProvider).getSearchApi(),
));
```

---

## 🟡 #6: AUTH OTP FLOW — 3× DUPLICATION DE TIMER LOGIC

**Fichiers**:
- `email_login_page.dart` (~40 lignes de timer)
- `register_page.dart` (~40 lignes)
- `otp_login_page.dart` (~40 lignes)

### Problème:
Chaque page réimplémente le pattern:
```dart
Timer? _timer;
int _remainingSeconds = 120;
void _startTimer() {
  _timer?.cancel();
  _timer = Timer.periodic(...) { ... };
}
void dispose() { _timer?.cancel(); super.dispose(); }
```
120 lignes de code dupliqué.

### Code judo move:
```dart
// mixin réutilisable
mixin OtpTimerState on State {
  Timer? _timer;
  int remainingSeconds = 0;
  bool get isExpired => remainingSeconds <= 0;
  void startOtpTimer(int seconds) { ... }
  @override void dispose() { _timer?.cancel(); super.dispose(); }
}
```
3 fichiers × 40 lignes → 0. 120 lignes supprimées.

---

## 🟡 #7: `_hydrateSessionFromRaw` — NON-ATOMIC STATE UPDATE

**Fichier**: `apps/mobile-client/lib/src/features/auth/providers/auth_provider.dart:112-130`

### Problème:
```dart
await notifier.login(accessToken, refreshToken, userId: ''); // 1. Stocke tokens avec userId vide
final user = await api.apiV1MeGet();                          // 2. Fetch /me (PEUT ÉCHOUER)
await notifier.login(accessToken, refreshToken, userId: user.id, role: user.role.name); // 3. Re-login
```

Si `/me` échoue à l'étape 2 :
- Les tokens sont stockés
- `userId` est `''`
- `isAuthenticated` retourne `false` (car `userId?.trim().isEmpty`)
- L'utilisateur est orphelin : tokens persistés mais page d'accueil = non connecté

### Code judo move:
```dart
// Atomic : tout fetch /me d'abord, puis stocker
final meResponse = await api.apiV1MeGet();
final user = meResponse.data;
// Vérifier role AVANT de stocker
if (user.role.name != 'client') throw ClientOnlyAuthException(...);
// TOUT stocker en une seule fois
await notifier.login(accessToken, refreshToken, userId: user.id, role: user.role.name);
```

---

## 🟡 #8: `ProfileProvider` — PATCH DUPLICATED ROLLBACK LOGIC

**Fichier**: `apps/mobile-client/lib/src/features/profile/providers/profile_provider.dart`

### Problème:
La logique de rollback est dupliquée dans:
1. `_updateAndSync` rollback on server error
2. `uploadAvatar` rollback via `_updateAndSync`
3. `updateProfile` optimistic update before calling `_updateAndSync`

### Code judo move:
La méthode `_updateAndSync` gère déjà le rollback. `updateProfile` et `uploadAvatar` devraient juste:
1. Faire l'optimistic update
2. Appeler `_updateAndSync`
Le `try/catch` dans `updateProfile` peut être simplifié.

---

## 🟢 #9: `...?(condition ? {k: v} : null)` — IDIOM CONTROVERSÉ

**Fichier**: `profile_provider.dart:77`

```dart
final payload = <String, dynamic>{
  ...?(fullName != null ? {'fullName': fullName} : null),
  ...?(phone != null ? {'phone': phone} : null),
  ...
};
```

Problème: Crée un Map temporaire pour chaque condition juste pour le spread `...?`. Consomme de la mémoire et confus pour les développeurs qui ne connaissent pas ce pattern.

**Fix**: 
```dart
final payload = <String, dynamic>{};
if (fullName != null) payload['fullName'] = fullName;
if (phone != null) payload['phone'] = phone;
```

---

## 🟢 #10: `app_outbox.dart` — FLUSH STOP-ON-FAILURE

**Fichier**: `apps/mobile-client/lib/src/core/sync/app_outbox.dart`

### Problème:
La méthode `flush()` traite les entrées séquentiellement. Si la 3ème entrée sur 5 échoue avec une erreur réseau, `break` stoppe tout le flush. Les entrées 4-5 ne sont jamais tentées.

**Impact**: En pratique, si l'utilisateur fait 3 modifications hors-ligne et que la 3ème échoue (ex: réseau perdu), les entrées 4+ restent bloquées jusqu'au prochain appel de `flush()`.

**Fix**: `continue` au lieu de `break` pour les erreurs réseau. Uniquement `break` pour les 500/erreurs critiques.

---

## #11: `refreshAll()` — INVALIDE 18 PROVIDERS À CHAQUE NAVIGATION

**Fichier**: `apps/mobile-client/lib/src/core/reactivity/app_reactivity.dart`

### Problème:
Chaque push/pop sur le router invalide 18 providers, ce qui déclenche 18 requêtes API. Sur un téléphone en 4G, l'utilisateur attend 5-10 secondes à chaque changement d'onglet.

### Code judo move:
Remplacer l'invalidation massive par un `stale-while-revalidate` pattern:
- Ne pas invalider les providers qui sont déjà frais (< 60 secondes)
- Invalider uniquement les providers pertinents pour la page de destination
- Utiliser un cache time-to-live au lieu d'invalidation systématique

---

## #12: `Backend app.ts` — ERROR HANDLER GLOBAL QUI LEAK

**Fichier**: `apps/api/src/app.ts:66`

**Problème**: `reply.send(error)` dans le `setErrorHandler` Fastify. En mode dev, Fastify sérialise l'erreur complète (stack trace inclus). Les erreurs Prisma avec noms de champs sensibles (email, phone) peuvent fuiter.

**Fix**: Logger l'erreur avec `request.id` et répondre un message générique.

---

## 📊 BARÈME DE QUALITÉ

| Critère | Score | Commentaire |
|---------|-------|-------------|
| Taille des fichiers | ❌ 0/10 | 2 fichiers > 1000 lignes |
| Abstractions | ❌ 2/10 | Services statiques, pas d'injection |
| Spaghetti | ❌ 1/10 | `_pay()` 300 lignes, conditions imbriquées |
| Duplication | ⚠️ 4/10 | OTP timer 3×, rollback 3× |
| Testabilité | ❌ 1/10 | Statique + Hive + pas d'injection |
| Atomicité | ⚠️ 5/10 | Auth state, outbox flush |
| **Global** | **❌ 2/10** | **Restructuration majeure requise** |

## 🎯 TOP 3 PRIORITÉS

1. **🔥 Découper `payment_handoff_page.dart`** (1663 → ~400 lignes)
2. **🔥 Dé-statifier `EngagementNotificationService`** (statique → injecté)
3. **🔥 Atomiciser `_hydrateSessionFromRaw`** (fetch /me avant de stocker)
