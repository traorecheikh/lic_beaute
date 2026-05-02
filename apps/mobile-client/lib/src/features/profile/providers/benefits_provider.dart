import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/session/session_store.dart';
import '../../../core/storage/cached_fetch.dart';
import '../models/account_models.dart';

final benefitsProvider = FutureProvider<List<BenefitRecord>>((ref) async {
  final session = ref.watch(sessionProvider);
  if (!session.isAuthenticated) return const [];
  return fetchCachedItemList(
    dio: ref.read(dioProvider),
    path: '/api/v1/me/benefits',
    boxName: StorageKeys.profileBox,
    cacheKey: StorageKeys.benefitsList,
    fromJson: BenefitRecord.fromJson,
  );
});
