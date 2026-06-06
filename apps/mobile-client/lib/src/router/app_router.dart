import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:hive_ce/hive_ce.dart';

import '../core/constants/storage_keys.dart';
import '../core/reactivity/app_reactivity.dart';
import '../core/session/session_store.dart';
import '../core/storage/app_model_cache.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/app_back_button.dart';
import '../core/widgets/app_icon.dart';
import '../features/appointments/pages/booking_detail_page.dart';
import '../features/appointments/pages/booking_manage_page.dart';
import '../features/appointments/pages/bookings_list_page.dart';
import '../features/appointments/pages/review_new_page.dart';
import '../features/auth/pages/auth_choice_page.dart';
import '../features/auth/pages/email_login_page.dart';
import '../features/auth/pages/onboarding/onboarding_page.dart';
import '../features/auth/pages/profile_bootstrap_page.dart';
import '../features/auth/pages/register_page.dart';
import '../features/booking/pages/booking_review_page.dart';
import '../features/booking/pages/booking_success_page.dart';
import '../features/booking/pages/payment_handoff_page.dart';
import '../features/booking/pages/service_selection_page.dart';
import '../features/booking/pages/slot_selection_page.dart';
import '../features/booking/pages/staff_selection_page.dart';
import '../core/location/location_permission_page.dart';
import '../features/discovery/pages/favorites_page.dart';
import '../features/discovery/pages/home_page.dart';
import '../features/discovery/pages/salon_detail_page.dart';
import '../features/discovery/pages/salons_list_page.dart';
import '../features/discovery/pages/search_page.dart';
import '../features/notifications/pages/notifications_page.dart';
import '../features/profile/pages/notification_preferences_page.dart';
import '../features/profile/pages/profile_page.dart';
import '../features/profile/pages/edit_profile_page.dart';
import '../features/profile/pages/payment_methods_page.dart';
// Promos hidden — import '../features/profile/pages/vouchers_page.dart';
import '../features/profile/pages/memberships_page.dart';
import '../features/profile/pages/support_page.dart';
import '../features/profile/pages/legal_page.dart';
import '../features/profile/pages/about_page.dart';
import '../features/profile/pages/faq_page.dart';
import '../features/profile/models/account_models.dart';
import 'shell_scaffold.dart';
import 'splash_page.dart';

// ── Route name constants (use these everywhere — no raw strings) ───────────

abstract final class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const auth = '/auth';
  static const emailLogin = '/auth/email-login';
  static const register = '/auth/register';
  static const profileBootstrap = '/profile/bootstrap';
  static const home = '/';
  static const search = '/search';
  static const salonsNearby = '/salons-nearby';
  static const salonsPrestige = '/salons-prestige';
  static const salonsTopRated = '/salons-top-rated';
  static const salonsTrending = '/salons-trending';
  static const locationPermission = '/location-permission';
  static const favorites = '/favorites';
  static const salonDetail = '/salons/:salonId';
  static const bookingService = '/booking/service';
  static const bookingStaff = '/booking/staff';
  static const bookingSlot = '/booking/slot';
  static const bookingReview = '/booking/review';
  static const bookingPayment = '/booking/payment-handoff/:bookingId';
  static const bookingSuccess = '/booking/success/:bookingId';
  static const bookingsList = '/bookings';
  static const bookingDetail = '/bookings/:bookingId';
  static const bookingManage = '/bookings/:bookingId/manage';
  static const notifications = '/notifications';
  static const notificationPreferences = '/profile/notification-preferences';
  static const profile = '/profile';
  static const profileEdit = '/profile/edit';
  static const profilePayments = '/profile/payment-methods';
  // Promos hidden — static const profileVouchers = '/profile/vouchers';
  static const profileMemberships = '/profile/memberships';
  static const profileSupport = '/profile/support';
  static const profileLegal = '/profile/legal';
  static const profileAbout = '/profile/about';
  static const profileFaq = '/profile/faq';
  static const reviewNew = '/reviews/new/:bookingId';

  // Helpers for routes with params
  static String salon(String id) => '/salons/$id';
  static String paymentHandoff(String bookingId) =>
      '/booking/payment-handoff/$bookingId';
  static String success(String bookingId) => '/booking/success/$bookingId';
  static String bookingDetailPath(String id) => '/bookings/$id';
  static String bookingManagePath(String id) => '/bookings/$id/manage';
  static String review(String bookingId) => '/reviews/new/$bookingId';
  static String profileBootstrapSetup({String next = home}) =>
      '$profileBootstrap?required=1&next=${Uri.encodeComponent(next)}';
  static String profilePaymentsSetup({String next = home}) =>
      '$profilePayments?required=1&next=${Uri.encodeComponent(next)}';
}

// ── Routes protected from unauthenticated access ──────────────────────────

const _publicRoutesWithoutAuth = {
  AppRoutes.splash,
  AppRoutes.onboarding,
  AppRoutes.auth,
  AppRoutes.emailLogin,
  AppRoutes.register,
  AppRoutes.home,
  AppRoutes.search,
};

const _publicRoutePrefixesWithoutAuth = {'/salons/'};

const _authEntryRoutes = {
  AppRoutes.auth,
  AppRoutes.emailLogin,
  AppRoutes.register,
};

bool _isPublicRouteWithoutAuth(String location) {
  if (_publicRoutesWithoutAuth.contains(location)) return true;
  for (final prefix in _publicRoutePrefixesWithoutAuth) {
    if (location.startsWith(prefix)) return true;
  }
  return false;
}

bool _isSetupRoute(String location) {
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
      if (_isSetupRoute(location)) return null;
      return AppRoutes.profileBootstrapSetup(next: location);
    }
  }

  if (cachedPaymentMethods != null) {
    final items = (cachedPaymentMethods['items'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>()
        .map(PaymentMethodRecord.fromJson)
        .toList();
    if (items.isEmpty) {
      if (location == AppRoutes.profilePayments) return null;
      return AppRoutes.profilePaymentsSetup(next: location);
    }
  }

  return null;
}

String? _requiredSetupRedirect(String location) {
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

// ── Provider ──────────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final sessionListenable = _SessionListenable(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: sessionListenable,
    observers: [_AppRouteRefreshObserver(ref)],
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final location = state.matchedLocation;

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

      final isAllowedWithoutAuth = _isPublicRouteWithoutAuth(location);

      if (!session.isAuthenticated && !isAllowedWithoutAuth) {
        final current = Uri.encodeComponent(state.uri.toString());
        return '${AppRoutes.auth}?redirectTo=$current';
      }

      if (session.isAuthenticated) {
        final setupRedirect = _requiredSetupRedirect(location);
        if (setupRedirect != null) {
          return setupRedirect;
        }
      }

      // If onboarding just completed and user is redirected to /auth,
      // or if they are authenticated and try to go to auth pages, redirect to home.
      if (session.isAuthenticated && _authEntryRoutes.contains(location)) {
        final redirect = state.uri.queryParameters['redirectTo'];
        if (redirect != null && redirect.isNotEmpty) return redirect;
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      // ── Pre-auth ──────────────────────────────────────────────────────────
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (_, _) => const AuthChoicePage(),
        routes: [
          GoRoute(
            path: 'email-login',
            builder: (_, _) => const EmailLoginPage(),
          ),
          GoRoute(path: 'register', builder: (_, _) => const RegisterPage()),
        ],
      ),
      GoRoute(
        path: AppRoutes.profileBootstrap,
        builder: (_, state) => ProfileBootstrapPage(
          requiredSetup: state.uri.queryParameters['required'] == '1',
          nextRoute: state.uri.queryParameters['next'] ?? AppRoutes.home,
        ),
      ),

      // ── Main shell (bottom nav) ───────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (_, _) => const HomePage(),
            routes: [
              GoRoute(path: 'search', builder: (_, _) => const SearchPage()),
              GoRoute(
                path: 'favorites',
                builder: (_, _) => const FavoritesPage(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.bookingsList,
            builder: (_, _) => const BookingsListPage(),
            routes: [
              GoRoute(
                path: ':bookingId',
                builder: (_, state) => BookingDetailPage(
                  bookingId: state.pathParameters['bookingId']!,
                  isPast: state.uri.queryParameters['past'] == 'true',
                ),
                routes: [
                  GoRoute(
                    path: 'manage',
                    builder: (_, state) => BookingManagePage(
                      bookingId: state.pathParameters['bookingId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, _) => const ProfilePage(),
            routes: [
              GoRoute(path: 'edit', builder: (_, _) => const EditProfilePage()),
              GoRoute(
                path: 'notification-preferences',
                builder: (_, _) => const NotificationPreferencesPage(),
              ),
              GoRoute(
                path: 'payment-methods',
                builder: (_, state) => PaymentMethodsPage(
                  requiredSetup: state.uri.queryParameters['required'] == '1',
                  nextRoute: state.uri.queryParameters['next'] ?? AppRoutes.home,
                ),
              ),
              // Promos hidden —
              // GoRoute(
              //   path: 'vouchers',
              //   builder: (_, __) => const VouchersPage(),
              // ),
              GoRoute(
                path: 'memberships',
                builder: (_, _) => const MembershipsPage(),
              ),
              GoRoute(path: 'support', builder: (_, _) => const SupportPage()),
              GoRoute(path: 'legal', builder: (_, _) => const LegalPage()),
              GoRoute(path: 'about', builder: (_, _) => const AboutPage()),
              GoRoute(path: 'faq', builder: (_, _) => const FaqPage()),
            ],
          ),
        ],
      ),

      // ── Salon list pages ──────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.salonsNearby,
        builder: (_, _) => const SalonsListPage(filter: SalonListFilter.nearby),
      ),
      GoRoute(
        path: AppRoutes.salonsPrestige,
        builder: (_, _) =>
            const SalonsListPage(filter: SalonListFilter.prestige),
      ),
      GoRoute(
        path: AppRoutes.salonsTopRated,
        builder: (_, _) =>
            const SalonsListPage(filter: SalonListFilter.topRated),
      ),
      GoRoute(
        path: AppRoutes.salonsTrending,
        builder: (_, _) =>
            const SalonsListPage(filter: SalonListFilter.trending),
      ),
      GoRoute(
        path: AppRoutes.locationPermission,
        builder: (_, _) => const LocationPermissionPage(),
      ),

      // ── Salon detail (outside shell so it can be reached from booking funnel)
      GoRoute(
        path: '/salons/:salonId',
        builder: (_, state) =>
            SalonDetailPage(salonId: state.pathParameters['salonId']!),
      ),

      // ── Booking funnel (full-screen, no shell) ────────────────────────────
      GoRoute(
        path: AppRoutes.bookingService,
        builder: (_, state) {
          final salonId = state.uri.queryParameters['salonId'];
          if (salonId == null || salonId.isEmpty) {
            return const _BookingRouteErrorPage(
              title: 'Réservation indisponible',
              message:
                  'Le salon est manquant. Revenez à la fiche salon puis relancez la réservation.',
            );
          }
          return ServiceSelectionPage(salonId: salonId);
        },
      ),
      GoRoute(
        path: AppRoutes.bookingStaff,
        builder: (_, state) {
          final salonId = state.uri.queryParameters['salonId'];
          final serviceId = state.uri.queryParameters['serviceId'];
          if (salonId == null ||
              salonId.isEmpty ||
              serviceId == null ||
              serviceId.isEmpty) {
            return const _BookingRouteErrorPage(
              title: 'Réservation incomplète',
              message:
                  'La prestation ou le salon est manquant. Reprenez la réservation depuis la fiche salon.',
            );
          }
          return StaffSelectionPage(salonId: salonId, serviceId: serviceId);
        },
      ),
      GoRoute(
        path: AppRoutes.bookingSlot,
        builder: (_, state) {
          final salonId = state.uri.queryParameters['salonId'];
          final serviceId = state.uri.queryParameters['serviceId'];
          if (salonId == null ||
              salonId.isEmpty ||
              serviceId == null ||
              serviceId.isEmpty) {
            return const _BookingRouteErrorPage(
              title: 'Créneau indisponible',
              message:
                  'Le créneau ne peut pas être chargé sans salon et prestation. Reprenez la réservation.',
            );
          }
          return SlotSelectionPage(
            serviceId: serviceId,
            salonId: salonId,
            employeeId: state.uri.queryParameters['employeeId'],
            rescheduleBookingId:
                state.uri.queryParameters['rescheduleBookingId'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.bookingReview,
        builder: (_, _) => const BookingReviewPage(),
      ),
      GoRoute(
        path: '/booking/payment-handoff/:bookingId',
        builder: (_, state) =>
            PaymentHandoffPage(bookingId: state.pathParameters['bookingId']!),
      ),
      GoRoute(
        path: '/booking/success/:bookingId',
        builder: (_, state) =>
            BookingSuccessPage(bookingId: state.pathParameters['bookingId']!),
      ),

      // ── Notifications (reachable from any tab) ────────────────────────────
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, _) => const NotificationsPage(),
      ),

      // ── Post-visit review ─────────────────────────────────────────────────
      GoRoute(
        path: '/reviews/new/:bookingId',
        builder: (_, state) =>
            ReviewNewPage(bookingId: state.pathParameters['bookingId']!),
      ),
    ],
  );
});

// ── Listenable that bridges Riverpod state to GoRouter ───────────────────

class _SessionListenable extends ChangeNotifier {
  _SessionListenable(this._ref) {
    _ref.listen<SessionState>(sessionProvider, (_, _) => notifyListeners());
  }
  final Ref _ref;
}

class _AppRouteRefreshObserver extends NavigatorObserver {
  _AppRouteRefreshObserver(this._ref);

  final Ref _ref;
  DateTime _lastRefresh = DateTime.fromMillisecondsSinceEpoch(0);

  void _refresh() {
    final now = DateTime.now();
    if (now.difference(_lastRefresh) < const Duration(milliseconds: 350)) {
      return;
    }
    _lastRefresh = now;
    _ref.read(appReactivityProvider).refreshAll();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _refresh();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _refresh();
    super.didPop(route, previousRoute);
  }
}

class _BookingRouteErrorPage extends StatelessWidget {
  const _BookingRouteErrorPage({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.neutral,
        elevation: 0,
        leading: AppBackButton(
          onPressed: () => GoRouter.of(context).go(AppRoutes.home),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon('alert-circle', size: 48, color: AppColors.error),
                SizedBox(height: 20.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.displaySm,
                ),
                SizedBox(height: 12.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 24.h),
                FilledButton(
                  onPressed: () => GoRouter.of(context).go(AppRoutes.home),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    "Retour à l'accueil",
                    style: AppTextStyles.labelLg.copyWith(color: AppColors.onPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
