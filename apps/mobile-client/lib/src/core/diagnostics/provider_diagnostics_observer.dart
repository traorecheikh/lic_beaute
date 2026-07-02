import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/appointments/providers/bookings_list_provider.dart';
import '../../features/discovery/providers/favorites_provider.dart';
import '../../features/discovery/providers/salon_list_provider.dart';
import '../../features/profile/providers/payment_methods_provider.dart';
import '../../features/profile/providers/profile_provider.dart';
import '../location/location_service.dart';
import '../network/connectivity_provider.dart';
import '../reactivity/app_reactivity.dart';
import '../session/session_store.dart';
import 'app_runtime_diagnostics.dart';

final class ProviderDiagnosticsObserver extends ProviderObserver {
  const ProviderDiagnosticsObserver();

  static String? _labelFor(Object provider) {
    if (provider == nearbyProvider) return 'nearbyProvider';
    if (provider == topRatedProvider) return 'topRatedProvider';
    if (provider == trendingProvider) return 'trendingProvider';
    if (provider == prestigeProvider) return 'prestigeProvider';
    if (provider == bookingsListProvider) return 'bookingsListProvider';
    if (provider == profileProvider) return 'profileProvider';
    if (provider == cityFromLocationProvider) return 'cityFromLocationProvider';
    if (provider == locationProvider) return 'locationProvider';
    if (provider == locationStatusProvider) return 'locationStatusProvider';
    if (provider == connectivityProvider) return 'connectivityProvider';
    if (provider == isOnlineProvider) return 'isOnlineProvider';
    if (provider == networkReachabilityProvider) {
      return 'networkReachabilityProvider';
    }
    if (provider == appReactivityProvider) return 'appReactivityProvider';
    if (provider == favoritesProvider) return 'favoritesProvider';
    if (provider == locationBannerDismissedProvider) {
      return 'locationBannerDismissedProvider';
    }
    if (provider == sessionProvider) return 'sessionProvider';
    if (provider == paymentMethodsProvider) return 'paymentMethodsProvider';
    return null;
  }

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    final label = _labelFor(context.provider);
    if (label == null) return;
    AppRuntimeDiagnostics.recordProviderEvent(label, 'added');
    _recordAsyncState(label, value);
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    final label = _labelFor(context.provider);
    if (label == null) return;
    AppRuntimeDiagnostics.recordProviderEvent(label, 'disposed');
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    final label = _labelFor(context.provider);
    if (label == null) return;
    AppRuntimeDiagnostics.recordProviderEvent(label, 'updated');
    _recordAsyncState(label, newValue);
  }

  void _recordAsyncState(String label, Object? value) {
    if (value is AsyncValue) {
      if (value.isLoading) {
        AppRuntimeDiagnostics.recordProviderEvent(label, 'loading');
      } else if (value.hasError) {
        AppRuntimeDiagnostics.recordProviderEvent(
          label,
          'error',
          detail: value.error.runtimeType.toString(),
        );
      } else {
        AppRuntimeDiagnostics.recordProviderEvent(label, 'data');
      }
    }
  }
}
