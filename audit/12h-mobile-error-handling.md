# Audit Mobile — Gestion d'Erreurs & Résilience

> Généré le 17 juin 2026

## Score : **B (80/100)** 🟢

---

## 1. Architecture de gestion d'erreurs

### Stack

| Technique | Usage |
|---|---|
| `dio_exception_utils.dart` | Détection erreurs connexion |
| `app_network_error.dart` | Typage des erreurs réseau (enum) |
| `retry_with_backoff.dart` | Retry exponentiel |
| `app_http_error_handler.dart` | Mapping erreurs HTTP → messages |
| `AppAsyncView` | UI loading/error générique |
| `AppErrorState` | Widget erreur stylé |
| `AppResourceView` | Vue données avec cache stale |
| `AppSnackbar` | Notifications succès/erreur |
| `app_connectivity_wrapper.dart` | Bannière hors-ligne |

### Hiérarchie des erreurs

```
DioException (Dio)
├── connectionError / connectionTimeout
│   └─→ isConnectionLikeDioException() → true → retryWithBackoff / cache fallback
├── sendTimeout / receiveTimeout
│   └─→ isConnectionLikeDioException() → true → retryWithBackoff / cache fallback
├── badResponse (HTTP 4xx/5xx)
│   ├── 401 → Auth interceptor → refresh token → retry
│   ├── 400/422 → AppHttpErrorHandler.handleHttpError() → message API
│   ├── 403 → Snackbar "Accès refusé"
│   └── 5xx → Snackbar "Erreur serveur"
├── cancel
│   └─→ Ignoré silencieusement
├── badCertificate
│   └─→ Snackbar "Connexion sécurisée impossible"
└── unknown
    └─→ Snackbar "Erreur inattendue"
```

---

## 2. ✅ Points forts

### Couche réseau

| # | Force | Détail |
|---|---|---|
| E1 | **Intercepteur auth robuste** : refresh token automatique (file d'attente, pas de requêtes concurrentes) | `dio_client.dart` |
| E2 | **Retry avec backoff exponentiel** : 0.9s → 1.8s → 3.6s, 3 tentatives max | `retry_with_backoff.dart` |
| E3 | **Classification clean** : `AppNetworkErrorType` enum — offline, timeout, server, unauthorized, unknown | `app_network_error.dart` |
| E4 | **Cache fallback automatique** : `fetchCachedItemList` + `CachedResource` retournent cache stale si erreur réseau | `cached_fetch.dart` |
| E5 | **Bannière connectivité** : `AppConnectivityBanner` + `AppConnectivityRecovery` — UX visible | `app_connectivity_wrapper.dart` |

### UI

| # | Force | Détail |
|---|---|---|
| E6 | **`AppAsyncView` générique** : pattern loading + error + data partout | `app_async_view.dart` |
| E7 | **`AppErrorState` avec retry** : bouton "Réessayer" intégré | `app_error_state.dart` |
| E8 | **`StaleDataNotice`** : indicateur visuel de cache périmé | `stale_data_notice.dart` |
| E9 | **Snackbar unifié** : `AppSnackbar` avec variants success/error | `app_snackbar.dart` |
| E10 | **Messages en français** : pas de textes techniques, `ConfigurationService indisponible` au lieu de `500 Internal Server Error` | Partout |

### Offline

| # | Force | Détail |
|---|---|---|
| E11 | **Outbox offline** : 7 types d'opérations mises en file d'attente | `app_outbox.dart` |
| E12 | **Bannière offline visible** : `AppConnectivityWrapper` avec message + animation | `app_connectivity_wrapper.dart` |
| E13 | **`fallbackOnAnyError` param** : cache sert de fallback même sur 5xx | `cached_fetch.dart` |

---

## 3. ⚠️ Problèmes identifiés

### Gestion d'erreurs réseau

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| H1 | **`retryWithBackoff` ne retry pas les 5xx** : seules les erreurs de connexion (timeout, DNS) sont retryées — un 503 temporaire est perdu | **Major** |
| H2 | **Pas de fallback pour les mutations (POST/PUT/DELETE)** : l'outbox ne gère que certaines mutations (profile, paiement) — pas de fallback pour les mutations génériques | **Major** |
| H3 | **Pas de retry avec backoff sur l'outbox** : outbox tenté une seule fois, pas de file d'attente persistante avec retry | **Major** |
| H4 | **`connectivity_plus` non fiable** : dépend de l'état réseau Android/iOS — parfois rapporte "online" quand le réseau est dégradé | **Major** |
| H5 | **Pas de délai minimum avant affichage du loading** : pas de `Future.delayed` pour éviter le flash loading (< 300ms) | **Minor** |

### Auth & Session

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| H6 | **Pas de vérification token au restore** : le splash appelle `session.restore()` mais ne valide pas le token via `/me` — si token expiré, la première vraie requête échoue avec 401 | **Major** |
| H7 | **`ClientOnlyAuthException` catchée** : l'erreur de rôle pro est catchée et snackbar affichée, mais la session n'est pas nettoyée | **Minor** |
| H8 | **Pas de support `BadCertificateCallback` custom** : Dio utilise les certificats système — pas de cert pinning | **Minor** |

### Payment handoff

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| H9 | **Polling sans timeout maximum** : `_PaymentWaitingSheet` poll toutes les 6s jusqu'à 5 minutes — si l'utilisateur quitte la page, le polling continue en arrière-plan | **Major** |
| H10 | **`use_build_context_synchronously`** : `payment_handoff_page.dart:1144` — utilisation de BuildContext après async gap | **Minor** |
| H11 | **Pas de fallback 3DS** : si le paiement 3DS échoue, pas d'état de récupération clair | **Minor** |

### Outbox & Offline

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| H12 | **Outbox jamais flushé automatiquement** : pas de `Timer.periodic` ou listener connectivité pour flush automatique | **Critical** |
| H13 | **Pas de conflit détection** : si 2 mutations offline (ex: 2 edits profile), la dernière gagne — pas de versioning | **Minor** |
| H14 | **Pas de cache update pour les mutations offline** : `profile_patch` hors-ligne → cache pas mis à jour localement | **Minor** |

### UI & Feedback

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| H15 | **Pas de skeleton screens** : les spinners `CircularProgressIndicator.adaptive()` sont utilisés partout — pas de preview du contenu | **Major** |
| H16 | **Pas de retry automatique** : l'utilisateur doit taper "Réessayer" manuellement — pas de politique de reconnexion automatique | **Minor** |
| H17 | **`AppErrorState` pas de secondary action** : seulement "Réessayer", pas de "Retour à l'accueil" ou "Contacter le support" | **Minor** |
| H18 | **Pas de logging errors** : aucune intégration crash reporter (Sentry, Firebase Crashlytics) — les erreurs passent inaperçues | **Critical** |

---

## 4. Analyse des patterns catch/try

L'app utilise **158 expressions `catch`/`try`** dans le code source (`lib/src/`). Analyse :

### Répartition

| Pattern | Usage | Qualité |
|---|---|---|
| `try { ... } on DioException catch (e) { ... }` | Appels API dans les providers | ✅ Correct |
| `try { ... } catch (e) { ... }` | Fallback générique | ⚠️ Parfois trop large |
| `try { ... } catch (e, st) { ... }` | Avec stack trace | ✅ Minorité |
| `try { ... } finally { ... }` | Cleanup | ✅ Rare |

### Patterns problématiques

```dart
// ⚠️ Catch trop large sans rethrow
try {
  final result = await someApiCall();
} catch (e) {
  // e non typé, message générique
  state = AsyncError('Erreur', StackTrace.current);
}

// ⚠️ Catch muet (silent catch)
try {
  await doSomething();
} catch (_) {
  // Ignoré silencieusement — mauvais pour le debugging
}

// ✅ Bon pattern
try {
  final result = await dio.get(...);
} on DioException catch (e) {
  final error = AppNetworkError.fromDioException(e, fallback: 'Message FR');
  state = AsyncError(error, StackTrace.current);
}
```

---

## 5. Analyse des messages d'erreur

### Messages utilisateur (français)

| Contexte | Message | Qualité |
|---|---|---|
| Connexion perdue | "Connexion indisponible. Vérifiez votre réseau puis réessayez." | ✅ Clair |
| Timeout | "Le serveur met trop de temps à répondre." | ✅ Simple |
| 401 | "Votre session a expiré." | ✅ Blâme système |
| 500 | "Erreur serveur." | ✅ Simple |
| Paiement échoué | "Le paiement a échoué." | ❌ Pas de guidance |
| Booking échoué | "Impossible de créer la réservation." | ✅ OK |
| OTP invalide | "Code invalide." | ❌ Pas de guidance |

### Recommandations microcopy erreur

| Actuel | Suggestion |
|---|---|
| "Le paiement a échoué." | → "Le paiement n'a pas abouti. Vérifiez votre solde ou utilisez un autre moyen." |
| "Code invalide." | → "Code incorrect. Vérifiez le message reçu par SMS et réessayez." |
| "Erreur serveur." | → "Nos services sont momentanément indisponibles. Veuillez réessayer dans quelques instants." |

---

## 6. Recommandations

### 🔴 Priorité haute — Résilience

1. **Ajouter un crash reporter** : Sentry ou Firebase Crashlytics — aucune visibilité sur les erreurs en production
2. **Ajouter le retry des 5xx** dans `retryWithBackoff` (503 Service Unavailable notamment)
3. **Flusher l'outbox automatiquement** via listener de connectivité ou `Timer.periodic`

### 🟡 Priorité moyenne — UX erreur

4. **Valider le token au restore** : appeler `/me` au démarrage pour vérifier la session avant la première action
5. **Remplacer les spinners par des skeleton screens** : `shimmer` package déjà présent
6. **Ajouter un timeout de polling au paiement** : arrêter après 3 minutes max avec message clair

### 🟢 Priorité basse — Polish

7. **Ajouter un délai de 300ms avant affichage du loading** : éviter le flash loading
8. **Auditer les `catch (_)` silencieux** : remplacer par `catch (e, st) { debugPrint(...) }`
9. **Améliorer les messages d'erreur paiement et OTP**
10. **Ajouter une `SecondaryAction` sur `AppErrorState`** : "Contacter le support"

---

## 7. Résumé

La gestion d'erreurs est **solide sur le plan architectural** (classification, retry, cache fallback, UI unifiée) mais **manque de résilience en production** :

- 🔴 **Aucun crash reporter** — pas de visibilité sur les erreurs réelles
- 🔴 **Outbox jamais flushé automatiquement**
- 🔴 **Pas de retry des 5xx** dans le mécanisme de retry
- 🟡 **Pas de skeleton screens** (spinners génériques partout)
- 🟡 **Pas de validation token au démarrage**

Score : **B (80/100)** — solide mais nécessite un investissement en observabilité.
