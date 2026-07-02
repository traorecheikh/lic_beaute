import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../diagnostics/app_runtime_diagnostics.dart';
import '../../features/appointments/providers/bookings_list_provider.dart';
import '../../features/discovery/providers/favorites_provider.dart';
import '../../features/discovery/providers/salon_detail_provider.dart';
import '../../features/discovery/providers/salon_list_provider.dart';
import '../../features/notifications/providers/notifications_provider.dart';
import '../../features/profile/providers/benefits_provider.dart';
import '../../features/profile/providers/payment_methods_provider.dart';
import '../../features/profile/providers/profile_provider.dart';

final appReactivityProvider = Provider<AppReactivity>((ref) {
  return AppReactivity(ref);
});

class AppReactivity {
  AppReactivity(this._ref);

  final Ref _ref;

  static const _staleThreshold = Duration(seconds: 30);
  DateTime _lastRefreshAll = DateTime(2000);

  /// Invalidates all cached providers so they re-fetch on next watch.
  ///
  /// Skips invalidation if called more than once within [_staleThreshold]
  /// to avoid hammering the API on rapid tab switches / app resumes.
  void refreshAll({bool force = false}) {
    final now = DateTime.now();
    if (!force && now.difference(_lastRefreshAll) < _staleThreshold) {
      AppRuntimeDiagnostics.logLifecycle('refreshAll skipped force=$force');
      return;
    }
    _lastRefreshAll = now;
    AppRuntimeDiagnostics.logLifecycle('refreshAll force=$force');

    _ref.invalidate(salonListProvider);
    _ref.invalidate(nearbyProvider);
    _ref.invalidate(topRatedProvider);
    _ref.invalidate(trendingProvider);
    _ref.invalidate(prestigeProvider);
    _ref.invalidate(favoritesListProvider);
    _ref.invalidate(salonDetailProvider);
    _ref.invalidate(salonDetailResourceProvider);
    _ref.invalidate(salonAvailabilityProvider);
    _ref.invalidate(salonReviewsProvider);
    _ref.invalidate(bookingsListProvider);
    _ref.invalidate(bookingDetailProvider);
    _ref.invalidate(bookingDetailResourceProvider);
    _ref.invalidate(profileProvider);
    _ref.invalidate(paymentMethodsProvider);
    _ref.invalidate(benefitsProvider);
    _ref.invalidate(notificationsProvider);
  }
}
