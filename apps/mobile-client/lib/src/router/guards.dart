import 'package:hive_ce/hive_ce.dart';

import '../core/constants/storage_keys.dart';
import '../core/session/session_store.dart';
import '../core/storage/app_model_cache.dart';
import '../features/profile/models/account_models.dart';
import 'app_router.dart';

// ── Routes protected from unauthenticated access ──────────────────────────

const _publicRoutesWithoutAuth = {
  AppRoutes.splash,
  AppRoutes.onboarding,
  AppRoutes.auth,
  AppRoutes.emailLogin,
  AppRoutes.register,
  AppRoutes.home,
  AppRoutes.search,
  AppRoutes.locationPermission,
  AppRoutes.paymentCallback,
};

const _publicRoutePrefixesWithoutAuth = {'/salons/'};

const _authEntryRoutes = {
  AppRoutes.auth,
  AppRoutes.emailLogin,
  AppRoutes.register,
};

bool isPublicRouteWithoutAuth(String location) {
  if (_publicRoutesWithoutAuth.contains(location)) return true;
  for (final prefix in _publicRoutePrefixesWithoutAuth) {
    if (location.startsWith(prefix)) return true;
  }
  return false;
}

bool isSetupRoute(String location) {
  return location == AppRoutes.profileBootstrap ||
      location == AppRoutes.profilePayments;
}

String? resolveRequiredSetupRedirect({
  required String location,
  Map<String, dynamic>? cachedProfile,
  Map<String, dynamic>? cachedPaymentMethods,
}) {
  if (cachedProfile != null) {
    final profile = ClientAccountProfile.fromJson(cachedProfile);
    if (profile.fullName.trim().isEmpty) {
      if (isSetupRoute(location)) return null;
      return AppRoutes.profileBootstrapSetup(next: location);
    }
  }

  if (cachedPaymentMethods != null) {
    final items = AppModelCache.normalizeMapList(
      (cachedPaymentMethods['items'] as List<dynamic>? ?? const []),
    ).map(PaymentMethodRecord.fromJson).toList();
    if (items.isEmpty) {
      if (location == AppRoutes.profilePayments) return null;
      return AppRoutes.profilePaymentsSetup(next: location);
    }
  }

  return null;
}

String? requiredSetupRedirect(String location) {
  return resolveRequiredSetupRedirect(
    location: location,
    cachedProfile: AppModelCache.getMap(
      StorageKeys.profileBox,
      StorageKeys.currentUser,
    ),
    cachedPaymentMethods: AppModelCache.getMap(
      StorageKeys.profileBox,
      StorageKeys.paymentMethods,
    ),
  );
}

String? authGuardRedirect({
  required SessionState session,
  required String location,
}) {
  if (session.isRestoring) return null;

  // Check for first-time onboarding
  final settingsBox = Hive.box<dynamic>(StorageKeys.settingsBox);
  final onboardingCompleted =
      settingsBox.get(StorageKeys.onboardingCompleted, defaultValue: false)
          as bool;

  if (!onboardingCompleted &&
      location != AppRoutes.onboarding &&
      location != AppRoutes.splash) {
    return AppRoutes.onboarding;
  }

  final isAllowedWithoutAuth = isPublicRouteWithoutAuth(location);

  if (!session.isAuthenticated && !isAllowedWithoutAuth) {
    final current = Uri.encodeComponent(location);
    return '${AppRoutes.auth}?redirectTo=$current';
  }

  if (session.isAuthenticated) {
    final setupRedirect = requiredSetupRedirect(location);
    if (setupRedirect != null) {
      return setupRedirect;
    }
  }

  // If onboarding just completed and user is redirected to /auth,
  // or if they are authenticated and try to go to auth pages, redirect to home.
  if (session.isAuthenticated && _authEntryRoutes.contains(location)) {
    return AppRoutes.home;
  }

  return null;
}
