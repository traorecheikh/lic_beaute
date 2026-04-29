import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client_provider.dart';
import '../../../core/session/session_store.dart';

final salonDetailProvider =
    FutureProvider.family<SalonDetail?, String>((ref, salonId) async {
  final api = ref.read(apiClientProvider).getSalonsApi();
  final response = await api.apiV1SalonsIdGet(id: salonId);
  return response.data;
});

final salonAvailabilityProvider =
    FutureProvider.family<List<dynamic>, ({String salonId, String date})>(
        (ref, params) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get<List<dynamic>>(
    '/api/v1/salons/${params.salonId}/availability',
    queryParameters: {'date': params.date},
  );
  return response.data ?? [];
});

final salonReviewsProvider =
    FutureProvider.family<List<dynamic>, String>((ref, salonId) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    '/api/v1/salons/$salonId/reviews',
  );
  final items = (response.data?['items'] as List<dynamic>?) ?? [];
  return items;
});
