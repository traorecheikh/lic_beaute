import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void refreshAll() {
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
