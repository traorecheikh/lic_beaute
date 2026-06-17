# Audit Mobile — Performance

> Généré le 17 juin 2026

## Score : **B (76/100)** 🟡

---

## 1. Analyse des rebuilds

### Patterns observés

| Pattern | Risque | Exemples |
|---|---|---|
| `ConsumerWidget` avec `ref.watch()` sur des providers qui changent souvent | ⚠️ Rebuilds excessifs | `SalonListPage` watch `nearbyProvider` qui change à chaque pull-to-refresh |
| `ConsumerStatefulWidget` avec `setState()` dans `build()` | ⚠️ Cascade de rebuilds | `SearchPage` utilise `setState` pour `_query`, `_results`, `_pageInfo` — chaque key déclenche un rebuild complet |
| `AnimatedContainer` dans des listes | ⚠️ Layout coûteux | `_DateStrip` dans `SlotSelectionPage` rebuild chaque container à chaque scroll |

### ✅ Bonnes pratiques identifiées

| Pratique | Où | Impact |
|---|---|---|
| `const` constructeurs sur les widgets | Partout dans le codebase | ✅ Élevé |
| `skipLoadingOnReload: true` dans `AppAsyncView` | `keepDataOnReload` param | ✅ Élevé |
| `separatorBuilder` au lieu de `SizedBox` entre items | Listes de salons, bookings | ✅ Moyen |
| `SliverList` / `SliverFillRemaining` | Pages avec scroll | ✅ Moyen |
| `ref.invalidate()` au lieu de `ref.refresh()` | Booking actions | ✅ Faible |

### ⚠️ Problèmes de performance

| # | Problème | Localisation | Sévérité |
|---|---|---|---|
| M1 | **`SalonListCard` n'est pas `const`** : construit avec des paramètres non-const (salon) | `salon_list_card.dart` | **Major** |
| M2 | **`_ModuleSalonCard`: `Image.network` sans cache** : utilise `Image.network` au lieu de `CachedNetworkImage` | `search_page.dart:893` | **Major** |
| M3 | **`_DateStrip` rebuild total** : 14 `AnimatedContainer` à chaque tap sur date | `slot_selection_page.dart` | **Major** |
| M4 | **`SearchPage._IdleState` rebuild total** : `Wrap` + `recentSearches` map — rebuild complet à chaque entrée/sortie de search | `search_page.dart:547-615` | **Minor** |
| M5 | **`PaymentHandoffPage` rebuild total** : `_schedulePendingInit()` appelé à chaque build | `payment_handoff_page.dart:158-177` | **Minor** |
| M6 | **`AppPressable` rebuild** : état `_pressed` en State — mais wrapper `GestureDetector` existe déjà | `app_pressable.dart` | **Minor** |
| M7 | **`BookingFunnelNotifier` pas d'optimistic UI** : `selectService` → `selectEmployee` → `selectSlot` chaque étape rebuild tout | `booking_funnel_provider.dart` | **Minor** |

---

## 2. Analyse des images

| # | Problème | Fichier | Sévérité |
|---|---|---|---|
| I1 | **`_ModuleSalonCard` : `Image.network`** (pas de cache, pas de resize) | `search_page.dart:893` | **Major** |
| I2 | **`CachedNetworkImage` sans `memCacheWidth`/`memCacheHeight`** dans `_SalonCard` | `salons_list_page.dart:130` | **Major** |
| I3 | **`SalonListCard` : `memCacheWidth`/`memCacheHeight` présents** ✅ mais seulement pour les dimensions explicites | `salon_list_card.dart:70-71` | **Minor** |
| I4 | **Logo salon en `memCacheWidth` 200px** : peut être amélioré avec `width: h` * 2 | `salon_list_card.dart` | **Info** |

✅ **Bon point** : `SalonListCard` a `memCacheWidth: (h * 2).toInt()` — bon ratio pour Retina.

---

## 3. Analyse du scrolling

| Page | Type | Performance |
|---|---|---|
| `SalonsListPage` | `ListView.separated` | ✅ Bon — items homogènes |
| `SearchPage` | `CustomScrollView` + `SliverList` | ✅ Bon — slivers optimisés |
| `BookingsListPage` | `NestedScrollView` + `TabBarView` | ⚠️ Lourd — 2 `TabBarView` avec refresh |
| `SalonDetailPage` | `SingleChildScrollView` | ✅ OK pour contenu court |
| `ProfilePage` | `CustomScrollView` + `SliverList` | ✅ Bon |
| `PaymentHandoffPage` | `AppBookingAsyncScaffold` + `SliverToBoxAdapter` | ✅ OK |

### Problèmes

| # | Problème | Sévérité |
|---|---|---|
| S1 | **`BookingsListPage` : `NestedScrollView` + 2 `TabBarView`** : chaque tab a son propre `RefreshIndicator` + `Listener.separated` — 3 scrollables imbriqués | **Major** |
| S2 | **`staleAt != null` check dans `itemBuilder`** : décale l'index pour chaque item — complexité inutile | `bookings_list_page.dart:157-162` | **Minor** |
| S3 | **Pas de `SliverAnimatedList`** pour les animations d'entrée/sortie d'items | Général | **Minor** |

---

## 4. Analyse mémoire

### Surfaces potentiellement problématiques

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| L1 | **`_PaymentWaitingSheet` polling toutes les 6s** : si la bottom sheet n'est pas fermée, le polling continue pendant 5 minutes | `payment_handoff_page.dart:1099-1115` | **Major** |
| L2 | **`ForegroundNotificationService._handleMessage`** : si beaucoup de notifications en background, toutes les données sont chargées en RAM | `foreground_notification_service.dart` | **Minor** |
| L3 | **`Hive` boxes chargés en RAM** : 6 boxes ouverts au démarrage — acceptable pour des volumes modestes | `app_cache.dart` | **Info** |
| L4 | **`SearchEventTracker._buffer`** : accumulation d'événements jusqu'à 5 ou 10s de flush | `search_provider.dart:121-122` | **Info** |

### ✅ Bon points mémoire
- `RepaintBoundary` pour le partage d'image (évite de re-rendre)
- `CachedNetworkImage` avec cache disque
- Images redimensionnées via `memCacheWidth/Height`

---

## 5. Analyse des animations

| Animation | Type | Performance |
|---|---|---|
| **Onboarding dots** | `AnimatedContainer` width 6↔20 | ✅ Légère |
| **Booking success** | `ScaleTransition` + `FadeTransition` | ✅ Légère (curves elasticOut) |
| **Bottom nav indicator** | `AnimatedContainer` circle | ✅ Légère |
| **Date strip selection** | `AnimatedContainer` 14 items | ⚠️ Lourd — pourrait utiliser `AnimatedScale` ou couleur seule |
| **Star rating** | `AnimatedScale` + `MouseRegion` | ⚠️ `MouseRegion` inutile sur mobile |

### Problèmes

| # | Problème | Sévérité |
|---|---|---|
| A1 | **`MouseRegion` dans `_RatingPromptCard`** : inutile sur mobile — gère hover avec `onEnter`/`onExit` jamais déclenché | **Minor** |
| A2 | **Pas de `prefers-reduced-motion`** : toutes les animations custom ignorent les préférences système | **Minor** |
| A3 | **`AnimatedSwitcher` sur Onboarding** : bon mais pourrait être optimisé avec `FadeTransition` direct | **Info** |

---

## 6. Recommandations Performances

### 🔴 Haute priorité
1. **Remplacer `Image.network` par `CachedNetworkImage`** dans `_ModuleSalonCard` (search_page.dart)
2. **Ajouter `memCacheWidth`/`memCacheHeight`** sur les images `CachedNetworkImage` qui en manquent
3. **Optimiser `_DateStrip`** : utiliser `ListView.builder` avec `itemExtent` fixe au lieu de `AnimatedContainer` sur 14 items
4. **Éviter le rebuild total de `SearchPage`** : utiliser `ref.watch` sélectifs ou extraire en sous-widgets

### 🟡 Moyenne priorité
5. **Extraire `_staleAt` du `itemBuilder`** dans `bookings_list_page.dart`
6. **Remplacer `_PaymentWaitingSheet`** par un listener FCM push (évite le polling 6s)
7. **Supprimer `MouseRegion`** du code mobile (inutile)

### 🟢 Basse priorité
8. Ajouter `const` sur `SalonListCard` et ses paramètres
9. Ajouter `prefers-reduced-motion` support global
10. Ajouter des skeleton screens dédiés pour les pages lentes (bookings, search)
