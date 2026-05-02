import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/session/session_store.dart';
import '../../../core/storage/cached_fetch.dart';
import '../models/account_models.dart';

class VouchersNotifier extends AsyncNotifier<List<VoucherRecord>> {
  @override
  Future<List<VoucherRecord>> build() async {
    final session = ref.watch(sessionProvider);
    if (!session.isAuthenticated) return const [];
    return _fetch();
  }

  Future<List<VoucherRecord>> _fetch() async {
    return fetchCachedItemList(
      dio: ref.read(dioProvider),
      path: '/api/v1/me/vouchers',
      boxName: StorageKeys.profileBox,
      cacheKey: StorageKeys.vouchersList,
      fromJson: VoucherRecord.fromJson,
    );
  }

  Future<void> redeem(String code) async {
    final dio = ref.read(dioProvider);
    await dio.post('/api/v1/me/vouchers/redeem', data: {'code': code});
    ref.invalidateSelf();
  }
}

final vouchersProvider =
    AsyncNotifierProvider<VouchersNotifier, List<VoucherRecord>>(
      VouchersNotifier.new,
    );
