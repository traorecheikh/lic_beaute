import 'dart:async';

import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/network/api_client_provider.dart';
import '../../../core/network/retry_with_backoff.dart';

// ── Recent searches ─────────────────────────────────────────────────────────

final recentSearchesProvider =
    NotifierProvider<RecentSearchesNotifier, List<String>>(
  RecentSearchesNotifier.new,
);

class RecentSearchesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    _load();
    return [];
  }

  void _load() {
    try {
      final box = Hive.box<dynamic>(StorageKeys.settingsBox);
      final raw = box.get(StorageKeys.recentSearches);
      if (raw is List) state = List<String>.from(raw);
    } catch (_) {}
  }

  void add(String term) {
    final trimmed = term.trim();
    if (trimmed.length < 2) return;
    final updated = [
      trimmed,
      ...state.where((s) => s.toLowerCase() != trimmed.toLowerCase()),
    ].take(8).toList();
    state = updated;
    _persist(updated);
  }

  void remove(String term) {
    state = state.where((s) => s != term).toList();
    _persist(state);
  }

  void _persist(List<String> searches) {
    try {
      final box = Hive.box<dynamic>(StorageKeys.settingsBox);
      box.put(StorageKeys.recentSearches, searches);
    } catch (_) {}
  }
}

// ── Search suggestions ──────────────────────────────────────────────────────

final searchSuggestionsProvider = FutureProvider.family<
    SearchSuggestionsResponse?,
    ({String query, double? lat, double? lng, String? category, String? city})>(
  (ref, params) async {
    if (params.query.isEmpty) return null;
    final api = ref.read(apiClientProvider).getSearchApi();
    final response = await retryWithBackoff(
      () => api.apiV1SearchSuggestionsGet(
        q: params.query,
        lat: params.lat,
        lng: params.lng,
        category: params.category,
        city: params.city,
      ),
    );
    return response.data;
  },
);

// ── Search results ──────────────────────────────────────────────────────────

class SearchParams {
  final String query;
  final double? lat;
  final double? lng;
  final String? category;
  final String? city;
  final String? neighborhood;
  final int? minPrice;
  final int? maxPrice;
  final bool? openNow;
  final bool? bookableSoon;
  final String sort;
  final String? cursor;
  final int limit;

  const SearchParams({
    required this.query,
    this.lat,
    this.lng,
    this.category,
    this.city,
    this.neighborhood,
    this.minPrice,
    this.maxPrice,
    this.openNow,
    this.bookableSoon,
    this.sort = 'relevance',
    this.cursor,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchParams &&
          query == other.query &&
          lat == other.lat &&
          lng == other.lng &&
          category == other.category &&
          city == other.city &&
          neighborhood == other.neighborhood &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice &&
          openNow == other.openNow &&
          bookableSoon == other.bookableSoon &&
          sort == other.sort &&
          cursor == other.cursor &&
          limit == other.limit;

  @override
  int get hashCode => Object.hash(
        query, lat, lng, category, city, neighborhood,
        minPrice, maxPrice, openNow, bookableSoon, sort, cursor, limit,
      );
}

final searchResultsProvider = FutureProvider.family<
    SearchSalonsResponse?,
    SearchParams>(
  (ref, params) async {
    if (params.query.length < 2) return null;
    final api = ref.read(apiClientProvider).getSearchApi();
    final response = await retryWithBackoff(
      () => api.apiV1SearchSalonsGet(
        q: params.query,
        lat: params.lat,
        lng: params.lng,
        category: params.category,
        city: params.city,
        neighborhood: params.neighborhood,
        minPrice: params.minPrice,
        maxPrice: params.maxPrice,
        openNow: params.openNow,
        bookableSoon: params.bookableSoon,
        sort: params.sort,
        cursor: params.cursor,
        limit: params.limit,
      ),
    );
    return response.data;
  },
);

// ── Search event tracker ────────────────────────────────────────────────────

final searchEventTrackerProvider = Provider<SearchEventTracker>((ref) {
  final tracker = SearchEventTracker(ref);
  ref.onDispose(() => tracker.dispose());
  return tracker;
});

class SearchEventTracker {
  final Ref _ref;
  final List<SearchEventsRequestEventsInner> _buffer = [];
  Timer? _flushTimer;
  String? _sessionKey;

  SearchEventTracker(this._ref);

  void setSessionKey(String key) {
    _sessionKey = key;
  }

  void track({
    required SearchEventsRequestEventsInnerEventTypeEnum eventType,
    String? query,
    String? salonId,
    String? category,
    String? city,
    int? position,
  }) {
    if (_sessionKey == null) return;

    _buffer.add(SearchEventsRequestEventsInner((b) => b
      ..sessionKey = _sessionKey
      ..eventType = eventType
      ..query = query
      ..salonId = salonId
      ..category = category
      ..city = city
      ..position = position
    ));

    if (_buffer.length >= 5) {
      _flush();
    } else {
      _flushTimer?.cancel();
      _flushTimer = Timer(const Duration(seconds: 10), _flush);
    }
  }

  Future<void> _flush() async {
    if (_buffer.isEmpty) return;
    final events = List<SearchEventsRequestEventsInner>.from(_buffer);
    _buffer.clear();

    try {
      final api = _ref.read(apiClientProvider).getSearchApi();
      await api.apiV1SearchEventsPost(
        searchEventsRequest: SearchEventsRequest((b) => b
          ..events = ListBuilder<SearchEventsRequestEventsInner>(events)
        ),
      );
    } catch (_) {
      // Best-effort
    }
  }

  void dispose() {
    _flushTimer?.cancel();
    _flush();
  }
}

// ── Session key ─────────────────────────────────────────────────────────────

String generateSessionKey() {
  return 'mobile_${DateTime.now().millisecondsSinceEpoch}';
}
