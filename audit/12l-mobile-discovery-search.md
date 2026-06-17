# Audit Mobile — Feature Discovery & Search

> Généré le 17 juin 2026

## Score : **B (78/100)** 🟡

---

## 1. Architecture de la feature Discovery

### Fichiers

| Fichier | Lignes | Rôle |
|---|---|---|
| `home_page.dart` | **1 592** | Page d'accueil — 4 sections + top salons |
| `search_page.dart` | **1 172** | Page de recherche — suggestions + résultats + filtres |
| `search_provider.dart` | 237 | State recherche : recentSearches, suggestions, results, event tracking |
| `salon_list_provider.dart` | 139 | 5 providers : list, nearby, topRated, trending, prestige |
| `salon_detail_provider.dart` | ~120 | Detail salon, availability, reviews |
| `categories_provider.dart` | 20 | Catégories de salons |
| `favorites_provider.dart` | ~100 | Favoris (add, remove, list) |
| `salon_list_card.dart` | ~180 | Carte salon réutilisable |
| **Total** | **~3 560** | |

### Providers

```
SalonListProvider (notifier)
├── salonListProvider        → Liste paginée
├── nearbyProvider           → Proximité (lat/lng)
├── topRatedProvider         → Meilleurs notes
├── trendingProvider         → Tendance
└── prestigeProvider         → Salons prestige

SearchProvider (family)
├── recentSearchesProvider   → Historique (Notifier + Hive)
├── searchSuggestionsProvider → Suggestions live (FutureProvider.family)
├── searchResultsProvider    → Résultats (FutureProvider.family)
└── searchEventTracker       → Analytics events

SalonDetailProvider (family)
├── salonDetailResourceProvider → Détail (CachedResource)
├── salonAvailabilityProvider   → Créneaux dispo
└── salonReviewsProvider        → Avis

FavoritesProvider (notifier)
├── favoritesListProvider    → Liste favoris
├── isFavoriteProvider       → Check salon favori (family)
└── toggleFavorite           → Add/remove

CategoriesProvider
└── categoriesProvider       → Liste catégories (FutureProvider)
```

---

## 2. ✅ Points forts

### Architecture

| # | Force | Détail |
|---|---|---|
| D1 | **Séparation claire providers/pages** : logique métier dans les providers, UI dans les pages | ✅ |
| D2 | **Cache + offline** : `fetchCachedItemList`, `CachedResource` avec cache stale et fallback | ✅ |
| D3 | **Recherche typée** : `SearchParams` class avec tous les filtres (lat, lng, category, city, neighborhood, minPrice, maxPrice, openNow, bookableSoon, sort, cursor, limit) | ✅ |
| D4 | **Recherche suggestions live** : `searchSuggestionsProvider` appelle API à chaque frappe (debounce implicite via Riverpod) | ✅ |
| D5 | **Recent searches persistants** : stockés dans Hive, limités à 8 | ✅ |
| D6 | **Home page riche** : 5 sections (nearby, topRated, trending, prestige, categories) | ✅ |
| D7 | **Salon detail avec availability + reviews** : 3 providers distincts | ✅ |

### UI

| # | Force | Détail |
|---|---|---|
| U1 | **`EmptySearchState` dédié** : illustration + texte + suggestion | ✅ |
| U2 | **`StaleDataNotice`** : indicateur de cache périmé | ✅ |
| U3 | **`AppSalonListView` + `AppSliverSalonList`** : listes réutilisables | ✅ |
| U4 | **Catégories avec icônes** : visuelles + textuelles | ✅ |
| U5 | **Distance badge** : `_DistanceBadge` / `_DistancePill` sur les cartes | ✅ |
| U6 | **Pull-to-refresh** : sur toutes les listes | ✅ |

---

## 3. ⚠️ Problèmes identifiés

### Taille des fichiers

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| S1 | **`home_page.dart`: 1 592 lignes** — le plus gros fichier de l'app. Mélange : 4 sections (nearby, topRated, trending, prestige) + header + search bar + catégories | **Critical** |
| S2 | **`search_page.dart`: 1 172 lignes** — trop gros. Mélange : idle state, suggestions, résultats, filtres, sort options, map | **Critical** |
| S3 | **`salon_list_provider.dart`: 139 lignes** — 5 providers dans un seul fichier, approche en cascade (`apiV1SalonsGet` déprécié) | **Major** |

### Problèmes de home_page.dart (1 592 lignes)

```dart
class HomePage extends ConsumerWidget {
  // 1 section = ~300 lignes × 4 sections = ~1 200 lignes
  // + header = 200 lignes
  // + search bar = 200 lignes
  // Total : ~1 600 lignes
}
```

Le fichier contient :
- `_NearbySection` (widget inline)
- `_TopRatedSection` (widget inline)
- `_TrendingSection` (widget inline)
- `_PrestigeSection` (widget inline)
- `_CategoryGrid` (widget inline)
- `_HomeHeader` (widget inline)
- `_SearchBar` (widget inline)
- `_DistancePill` (widget inline)

**Tous ces widgets devraient être extraits dans `widgets/home_sections/`**

### Problèmes de search_page.dart (1 172 lignes)

```dart
class SearchPage extends ConsumerStatefulWidget {
  // Idle state (recent searches + suggestions)
  // Results state (liste + map toggle)
  // Filters bottom sheet
  // Sort options
  // Module salon card (Image.network sans cache!)
}
```

Le fichier contient :
- `_IdleState` (recent searches + suggestions)
- `_ResultsState` (liste résultats)
- `_FiltersSheet` (bottom sheet filtres)
- `_SortOption` (inline)
- `_ModuleSalonCard` (⚠️ **utilise `Image.network` sans cache !**)

### Problèmes de performances

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| P1 | **`_ModuleSalonCard` utilise `Image.network`** au lieu de `CachedNetworkImage` — pas de cache disque, pas de resize | **Critical** |
| P2 | **5 appels API au chargement de HomePage** : nearby, topRated, trending, prestige, categories — même si l'utilisateur ne scroll pas | **Major** |
| P3 | **`salonListProvider` utilise `apiV1SalonsGet` déprécié** (5 occurrences) — doit être migré | **Major** |
| P4 | **`resolveBestStaffId()` dans le funnel** : 2 × N appels API séquentiels pour N employés | **Major** |
| P5 | **`SalonListCard` pas entièrement `const`** : des paramètres non-const empêchent l'optimisation | **Minor** |

### Problèmes Discovery spécifiques

| # | Problème | Détail | Sévérité |
|---|---|---|---|
| X1 | **HomePage requiert location** : si l'utilisateur refuse la location, les sections nearby/trending sont vides sans fallback | **Major** |
| X2 | **CategoriesProvider (20 lignes) trop simple** : fetch unique, pas de cache, pas de fallback offline | **Minor** |
| X3 | **`favoritesProvider` sans cache Hive** : les favoris sont re-fetchés à chaque ouverture de l'app — pas de cache local | **Major** |
| X4 | **SalonDetailProvider sans prefetch** : le détail est chargé au moment du tap, pas de prefetch quand l'utilisateur scroll | **Minor** |
| X5 | **SearchEventTracker flush buffer** : envoie les events de recherche par lots de 5 ou toutes les 10s — pas de persistance | **Info** |

---

## 4. Analyse du flux HomePage

```
HomePage.build()
  ├─ AppBar search bar (tap → /search)
  ├─ _NearbySection (si location OK)
  │   └─ watch(nearbyProvider)
  │       └─ apiV1SalonsGet(nearby, lat, lng, limit=6)
  ├─ _TopRatedSection
  │   └─ watch(topRatedProvider)
  │       └─ apiV1SalonsGet(topRated, limit=6)
  ├─ _TrendingSection
  │   └─ watch(trendingProvider)
  │       └─ apiV1SalonsGet(trending, limit=6)
  ├─ _PrestigeSection
  │   └─ watch(prestigeProvider)
  │       └─ apiV1SalonsGet(prestige, limit=6)
  └─ _CategoryGrid
      └─ watch(categoriesProvider)
          └─ /api/v1/config/categories
```

**Problème** : 5 appels API parallèles au premier render. Si l'utilisateur a un réseau lent, la page met 3-5s à se charger complètement.

---

## 5. Analyse du flux Search

```
SearchPage
├─ Idle state (query == "")
│   ├─ Recent searches (Hive) + suggestions
│   └─ watch(recentSearchesProvider)
├─ Typing (query.length >= 1)
│   └─ watch(searchSuggestionsProvider(query, lat, lng, ...))
│       └─ /api/v1/search/suggestions
└─ Submit (query.length >= 2)
    └─ watch(searchResultsProvider(SearchParams(...)))
        └─ /api/v1/search/salons
            ├─ Facets : categories, priceRange
            ├─ Modules : map, promo banner
            └─ Pagination : cursor-based
```

**Forces** :
- ✅ Suggestions live avec paramètres complets (query, lat, lng, category, city)
- ✅ Résultats avec facets + pagination cursor
- ✅ Event tracking (searchEventTracker)

**Faiblesses** :
- ❌ Pas de debounce explicite sur les suggestions (appel API à chaque `setState` de `_query`)
- ❌ `_ModuleSalonCard` avec `Image.network` sans cache
- ❌ `SearchPage` rebuild total à chaque changement de `_query`

---

## 6. Recommandations

### 🔴 Priorité haute

1. **Extraire `home_page.dart`** : créer `widgets/home_sections/nearby_section.dart`, `top_rated_section.dart`, `trending_section.dart`, `prestige_section.dart`
2. **Remplacer `Image.network` par `CachedNetworkImage`** dans `_ModuleSalonCard` (search_page.dart:893)
3. **Migrer `apiV1SalonsGet` déprécié** dans `salon_list_provider.dart`
4. **Extraire `search_page.dart`** : séparer idle state, results state, filters sheet en fichiers distincts

### 🟡 Priorité moyenne

5. **Ajouter cache Hive aux favoris** : `favoritesProvider` devrait utiliser `fetchCachedItemList`
6. **Lazy load des sections HomePage** : charger nearby + topRated d'abord, puis trending + prestige en différé (après 500ms)
7. **Ajouter un debounce de 300ms aux suggestions de recherche**

### 🟢 Priorité basse

8. **Ajouter `const` sur `SalonListCard`** : optimiser les rebuilds
9. **Ajouter un fallback "Tous les salons"** si l'utilisateur refuse la location
10. **Cacher `CategoriesProvider`** avec TTL de 1h (rarement modifié)
11. **Améliorer `resolveBestStaffId()`** : utiliser `Future.wait` pour paralléliser les appels

---

## 7. Résumé

La feature Discovery est **riche et bien architecturée** (5 sections, recherche typée, cache, suggestions live) mais souffre de **problèmes de taille et de performance** :

- 🔴 **`home_page.dart`: 1 592 lignes** et **`search_page.dart`: 1 172 lignes** — les 2 plus gros fichiers de l'app
- 🔴 **`Image.network` sans cache** dans la search page
- 🔴 **`apiV1SalonsGet` déprécié** dans `salon_list_provider.dart`
- 🔴 **Aucun test** sur toute la feature Discovery (0 test)
- 🟡 **5 appels API simultanés** au chargement de HomePage
- 🟡 **Favoris sans cache local**

Score : **B (78/100)** — feature riche mais à refactorer et tester.
