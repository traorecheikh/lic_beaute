import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:built_value/serializer.dart';

import '../../../core/session/session_store.dart';
import 'cached_resource.dart';

final favoritesListProvider =
    FutureProvider<CachedResource<List<SalonSummary>>>((ref) async {
      final dio = ref.read(dioProvider);
      final response = await dio.get<Map<String, dynamic>>('/api/v1/favorites');
      final itemsJson = (response.data?['items'] as List<dynamic>?) ?? [];
      final items = itemsJson.map((json) {
        return standardSerializers.deserialize(
              json,
              specifiedType: const FullType(SalonSummary),
            )
            as SalonSummary;
      }).toList();
      return CachedResource(data: items, isStale: false);
    });

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

class FavoritesNotifier extends Notifier<FavoritesState> {
  @override
  FavoritesState build() {
    ref.listen(favoritesListProvider, (_, next) {
      final items = next.asData?.value.data;
      if (items != null) {
        final ids = items.map((s) => s.id).whereType<String>().toSet();
        Future.microtask(() => state = FavoritesState(salonIds: ids));
      }
    });
    return const FavoritesState();
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
      final dio = ref.read(dioProvider);
      if (isFav) {
        await dio.delete(
          '/api/v1/favorites/$salonId',
          data: const <String, dynamic>{},
        );
      } else {
        await dio.post(
          '/api/v1/favorites/$salonId',
          data: const <String, dynamic>{},
        );
      }
      ref.invalidate(favoritesListProvider);
    } catch (_) {
      // Roll back optimistic update on failure
      state = state.copyWith(
        salonIds: isFav ? {...updated, salonId} : (updated..remove(salonId)),
      );
    }
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, FavoritesState>(
  FavoritesNotifier.new,
);
