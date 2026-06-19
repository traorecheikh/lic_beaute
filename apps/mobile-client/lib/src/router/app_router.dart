import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../core/session/session_store.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/app_icon.dart';
import '../core/widgets/app_scaffold.dart';
import '../core/widgets/app_top_bar.dart';
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
import '../features/booking/pages/payment_callback_redirect_page.dart';
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
import '../features/profile/pages/memberships_page.dart';
import '../features/profile/pages/support_page.dart';
import '../features/profile/pages/legal_page.dart';
import '../features/profile/pages/about_page.dart';
import '../features/profile/pages/faq_page.dart';
import 'guards.dart';
import 'listenable.dart';
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
  static const paymentCallback = '/payment/callback';
  static const bookingsList = '/bookings';
  static const bookingDetail = '/bookings/:bookingId';
  static const bookingManage = '/bookings/:bookingId/manage';
  static const notifications = '/notifications';
  static const notificationPreferences = '/profile/notification-preferences';
  static const profile = '/profile';
  static const profileEdit = '/profile/edit';
  static const profilePayments = '/profile/payment-methods';
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
  static String paymentCallbackPath({
    String? bookingId,
    String? paymentId,
    String? token,
  }) {
    final query = <String, String>{
      if (bookingId != null && bookingId.isNotEmpty) 'bookingId': bookingId,
      if (paymentId != null && paymentId.isNotEmpty) 'paymentId': paymentId,
      if (token != null && token.isNotEmpty) 'token': token,
    };
    return Uri(path: paymentCallback, queryParameters: query).toString();
  }

  static String success(String bookingId) => '/booking/success/$bookingId';
  static String bookingDetailPath(String id) => '/bookings/$id';
  static String bookingManagePath(String id) => '/bookings/$id/manage';
  static String review(String bookingId) => '/reviews/new/$bookingId';
  static String profileBootstrapSetup({String next = home}) =>
      '$profileBootstrap?required=1&next=${Uri.encodeComponent(next)}';
  static String profilePaymentsSetup({String next = home}) =>
      '$profilePayments?required=1&next=${Uri.encodeComponent(next)}';
}

// ── Provider ──────────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final sessionListenable = SessionListenable(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: sessionListenable,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final location = state.matchedLocation;

      // Consume redirectTo before authGuardRedirect so authenticated users
      // on /auth?redirectTo=/bookings land at /bookings, not /home
      if (session.isAuthenticated) {
        final redirectTo = state.uri.queryParameters['redirectTo'];
        if (redirectTo != null && redirectTo.isNotEmpty) return redirectTo;
      }

      final redirect = authGuardRedirect(session: session, location: location);
      if (redirect != null) return redirect;

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
      GoRoute(
        path: AppRoutes.paymentCallback,
        builder: (_, state) => PaymentCallbackRedirectPage(
          bookingId: state.uri.queryParameters['bookingId'],
          paymentId: state.uri.queryParameters['paymentId'],
          token: state.uri.queryParameters['token'],
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
                  nextRoute:
                      state.uri.queryParameters['next'] ?? AppRoutes.home,
                ),
              ),
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

      // ── Salon list pages ──────────────────────────────────────────────────
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
        builder: (_, state) {
          final salonId = state.pathParameters['salonId']!;
          final heroTag = state.uri.queryParameters['heroTag'];
          return SalonDetailPage(salonId: salonId, heroTag: heroTag);
        },
      ),

      // ── Booking funnel (full-screen, no shell) ────────────────────────────
      GoRoute(
        path: AppRoutes.bookingService,
        builder: (_, state) {
          final salonId = state.uri.queryParameters['salonId'];
          if (salonId == null || salonId.isEmpty) {
            return const BookingRouteErrorPage(
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
            return const BookingRouteErrorPage(
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
            return const BookingRouteErrorPage(
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
        builder: (_, state) => PaymentHandoffPage(
          bookingId: state.pathParameters['bookingId']!,
          resumePaymentId: state.uri.queryParameters['paymentId'],
          openedFromCallback: state.uri.queryParameters['fromCallback'] == '1',
        ),
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

class BookingRouteErrorPage extends StatelessWidget {
  const BookingRouteErrorPage({
    required this.title,
    required this.message,
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppTopBar(
        showBackButton: true,
        onBack: () => GoRouter.of(context).go(AppRoutes.home),
      ),
      // no extra SafeArea top — AppScaffold/AppBar already handle the status bar inset
      body: Center(
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  "Retour à l'accueil",
                  style: AppTextStyles.labelLg.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
