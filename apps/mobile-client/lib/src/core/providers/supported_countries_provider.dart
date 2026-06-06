import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/booking/providers/payment_methods_provider.dart';
import '../session/session_store.dart';
import '../widgets/app_phone_field.dart';

/// Derives supported countries from the payment methods API.
/// Each payment method has a `country` field that we extract and map
/// to the full PhoneCountry data from kPhoneCountries.
final supportedCountriesProvider = FutureProvider<List<PhoneCountry>>((ref) async {
  final session = ref.watch(sessionProvider);
  if (!session.isAuthenticated) return kPhoneCountries;

  try {
    final methods = await ref.watch(availablePaydunyaMethodsProvider.future);
    final countryCodes = methods
        .map((m) => m.country.trim().toUpperCase())
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();

    if (countryCodes.isEmpty) return kPhoneCountries;

    final supported = kPhoneCountries
        .where((c) => countryCodes.contains(c.code))
        .toList();

    // Always include Senegal as default fallback
    if (!supported.any((c) => c.code == 'SN')) {
      final sn = kPhoneCountries.firstWhere((c) => c.code == 'SN');
      supported.insert(0, sn);
    }

    return supported;
  } catch (_) {
    return kPhoneCountries;
  }
});
