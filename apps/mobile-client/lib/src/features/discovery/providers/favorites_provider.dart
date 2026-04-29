import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_store.dart';

@immutable
class FavoritesState {
  const FavoritesState({this.salonIds = const {}, this.loading = false});

  final Set<String> salonIds;
  final bool loading;

  bool contains(String salonId) => salonIds.contains(salonId);

  FavoritesState copyWith({Set<String>? salonIds, bool? loading}) {
    return FavoritesState(
      salonIds: salonIds ?? this.salonIds,
      loading: loading ?? this.loading,
    );
  }
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  FavoritesNotifier(this._ref) : super(const FavoritesState()) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    state = state.copyWith(loading: true);
    try {
      final dio = _ref.read(dioProvider);
      final response = await dio.get<Map<String, dynamic>>('/api/v1/favorites');
      final items = (response.data?['items'] as List<dynamic>?) ?? [];
      final ids = items
          .map((e) => (e as Map<String, dynamic>)['id'] as String?)
          .whereType<String>()
          .toSet();
      state = FavoritesState(salonIds: ids);
    } catch (_) {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> toggle(String salonId) async {
    final isFav = state.contains(salonId);
    final updated = Set<String>.from(state.salonIds);
    if (isFav) {
      updated.remove(salonId);
    } else {
      updated.add(salonId);
    }
    state = state.copyWith(salonIds: updated);

    try {
      final dio = _ref.read(dioProvider);
      if (isFav) {
        await dio.delete('/api/v1/favorites/$salonId');
      } else {
        await dio.post('/api/v1/favorites/$salonId');
      }
    } catch (_) {
      // Roll back optimistic update on failure
      state = state.copyWith(salonIds: isFav ? {...updated, salonId} : (updated..remove(salonId)));
    }
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier(ref);
});
