import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/session/session_store.dart';
import '../features/appointments/pages/booking_detail_page.dart';
import '../features/appointments/pages/booking_manage_page.dart';
import '../features/appointments/pages/bookings_list_page.dart';
import '../features/appointments/pages/review_new_page.dart';
import '../features/auth/pages/auth_choice_page.dart';
import '../features/auth/pages/email_login_page.dart';
import '../features/auth/pages/otp_login_page.dart';
import '../features/auth/pages/profile_bootstrap_page.dart';
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
import 'shell_scaffold.dart';
import 'splash_page.dart';

// ── Route name constants (use these everywhere — no raw strings) ───────────

abstract final class AppRoutes {
  static const splash = '/splash';
  static const auth = '/auth';
  static const emailLogin = '/auth/email-login';
  static const otpLogin = '/auth/otp';
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
}

// ── Routes protected from unauthenticated access ──────────────────────────

const _routesAllowedWithoutAuth = {
  AppRoutes.splash,
  AppRoutes.auth,
  AppRoutes.emailLogin,
  AppRoutes.otpLogin,
  AppRoutes.home,
  AppRoutes.search,
  AppRoutes.salonDetail,
};

const _authEntryRoutes = {
  AppRoutes.auth,
  AppRoutes.emailLogin,
  AppRoutes.otpLogin,
};

// ── Provider ──────────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final sessionListenable = _SessionListenable(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: sessionListenable,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final location = state.matchedLocation;

      if (session.isRestoring) return null;

      final isAllowedWithoutAuth = _routesAllowedWithoutAuth.contains(location);

      if (!session.isAuthenticated && !isAllowedWithoutAuth) {
        final current = Uri.encodeComponent(state.uri.toString());
        return '${AppRoutes.auth}?redirectTo=$current';
      }
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
        path: AppRoutes.auth,
        builder: (_, _) => const AuthChoicePage(),
        routes: [
          GoRoute(
            path: 'email-login',
            builder: (_, _) => const EmailLoginPage(),
          ),
          GoRoute(path: 'otp', builder: (_, _) => const OtpLoginPage()),
        ],
      ),
      GoRoute(
        path: AppRoutes.profileBootstrap,
        builder: (_, _) => const ProfileBootstrapPage(),
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
              GoRoute(
                path: 'edit',
                builder: (_, _) => const EditProfilePage(),
              ),
              GoRoute(
                path: 'notification-preferences',
                builder: (_, _) => const NotificationPreferencesPage(),
              ),
              GoRoute(
                path: 'payment-methods',
                builder: (_, _) => const PaymentMethodsPage(),
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
        builder: (_, _) =>
            const SalonsListPage(filter: SalonListFilter.nearby),
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
        builder: (_, state) => ServiceSelectionPage(
          salonId: state.uri.queryParameters['salonId'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.bookingStaff,
        builder: (_, state) => StaffSelectionPage(
          salonId: state.uri.queryParameters['salonId'] ?? '',
          serviceId: state.uri.queryParameters['serviceId'],
        ),
      ),
      GoRoute(
        path: AppRoutes.bookingSlot,
        builder: (_, state) => SlotSelectionPage(
          serviceId: state.uri.queryParameters['serviceId'] ?? '',
          salonId: state.uri.queryParameters['salonId'] ?? '',
          employeeId: state.uri.queryParameters['employeeId'],
          rescheduleBookingId: state.uri.queryParameters['rescheduleBookingId'],
        ),
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
