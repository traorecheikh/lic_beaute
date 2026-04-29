import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../session/session_store.dart';

final apiClientProvider = Provider<BeauteavenueApi>((ref) {
  final dio = ref.watch(dioProvider);
  return BeauteavenueApi(dio: dio, interceptors: []);
});
