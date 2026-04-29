import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client_provider.dart';

final salonListProvider = FutureProvider<SalonSummaryListResponse?>((ref) async {
  final api = ref.read(apiClientProvider).getSalonsApi();
  final response = await api.apiV1SalonsGet();
  return response.data;
});
