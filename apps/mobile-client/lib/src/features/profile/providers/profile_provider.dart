import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client_provider.dart';
import '../../../core/session/session_store.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileNotifier extends AsyncNotifier<CurrentUser?> {
  @override
  Future<CurrentUser?> build() async {
    final session = ref.watch(sessionProvider);
    if (!session.isAuthenticated) return null;
    final api = ref.read(apiClientProvider).getAuthApi();
    final response = await api.apiV1MeGet();
    return response.data;
  }

  Future<void> updateProfile({String? fullName, String? phone}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final dio = ref.read(dioProvider);
      await dio.patch<Map<String, dynamic>>(
        '/api/v1/me',
        data: {
          if (fullName != null) 'fullName': fullName,
          if (phone != null) 'phone': phone,
        },
      );
      final api = ref.read(apiClientProvider).getAuthApi();
      final meResponse = await api.apiV1MeGet();
      return meResponse.data;
    });
    ref.invalidate(currentUserProvider);
  }
}

final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, CurrentUser?>(ProfileNotifier.new);
