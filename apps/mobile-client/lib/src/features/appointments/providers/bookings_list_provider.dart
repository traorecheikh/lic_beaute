import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client_provider.dart';
import '../../../core/session/session_store.dart';

final bookingsListProvider =
    FutureProvider<BookingSummaryListResponse?>((ref) async {
  final session = ref.watch(sessionProvider);
  if (!session.isAuthenticated) return null;
  final api = ref.read(apiClientProvider).getBookingsApi();
  final response = await api.apiV1BookingsGet();
  return response.data;
});

final bookingDetailProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, bookingId) async {
  final dio = ref.read(dioProvider);
  final response =
      await dio.get<Map<String, dynamic>>('/api/v1/bookings/$bookingId');
  return response.data;
});
