import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../../lib/src/features/appointments/providers/bookings_list_provider.dart'
    show bookingDetailResourceProvider;
import '../../../../lib/src/features/booking/pages/booking_review_page.dart';
import '../../../../lib/src/features/booking/pages/booking_success_page.dart';
import '../../../../lib/src/features/booking/providers/booking_create_provider.dart';
import '../../../../lib/src/features/booking/providers/booking_funnel_provider.dart';
import '../../../../lib/src/features/discovery/providers/cached_resource.dart';
import '../../../test_harness.dart' show buildTestableRouterWidget;

// ── Mock notifier for BookingFunnelState ──────────────────────────────────

class _MockBookingFunnelNotifier extends BookingFunnelNotifier {
  @override
  BookingFunnelState build() => BookingFunnelState(
        salonId: 'salon-1',
        serviceId: 'service-1',
        serviceName: 'Coupe Homme',
        servicePrice: 5000,
        serviceDurationMinutes: 30,
        employeeId: 'emp-1',
        employeeName: 'Fatou',
        slotDate: '2026-06-10',
        slotTime: '14:30',
        slotStartsAtIso: '2026-06-10T14:30:00.000',
        depositAmount: 1000,
      );
}

Widget _wrapBookingReviewPage() {
  return ProviderScope(
    overrides: [
      bookingFunnelProvider.overrideWith(() => _MockBookingFunnelNotifier()),
      bookingCreateProvider.overrideWith(() => BookingCreateNotifier()),
    ],
    child: buildTestableRouterWidget(
      (_) => const BookingReviewPage(),
      path: '/booking/review',
      initialLocation: '/booking/review',
    ),
  );
}

// ── Mock resource provider for BookingSuccessPage ─────────────────────────

Widget _wrapBookingSuccessPage({String bookingId = 'booking-1'}) {
  return ProviderScope(
    overrides: [
      bookingDetailResourceProvider.overrideWith(
        (ref, String id) async => CachedResource<Map<String, dynamic>>(
          data: {
            'salonName': 'Salon Test',
            'serviceName': 'Coupe Homme',
            'startsAt': '2026-06-10T14:30:00.000',
            'status': 'confirmed',
            'totalAmountXof': 5000,
            'depositAmountXof': 1000,
            'depositPaidXof': 1000,
            'salonId': 'salon-1',
            'serviceId': 'service-1',
            'employeeName': 'Fatou',
          },
          isStale: false,
        ),
      ),
    ],
    child: buildTestableRouterWidget(
      (_) => BookingSuccessPage(bookingId: bookingId),
      path: '/booking/success/:bookingId',
      initialLocation: '/booking/success/$bookingId',
    ),
  );
}

void main() {
  group('BookingReviewPage', () {
    testWidgets('renders summary card with service name', (tester) async {
      await tester.pumpWidget(_wrapBookingReviewPage());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Résumé'), findsOneWidget);
      expect(find.text('Coupe Homme'), findsOneWidget);
    });

    testWidgets('renders price card with deposit and remaining', (tester) async {
      await tester.pumpWidget(_wrapBookingReviewPage());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Détails du paiement'), findsOneWidget);
      // xof() uses NumberFormat.decimalPattern('fr_FR') which formats
      // with a narrow no-break space (\u202f), e.g. '5\u202f000 XOF'.
      // Check for the XOF suffix instead of relying on exact space matching.
      expect(find.textContaining('XOF'), findsNWidgets(3));
      expect(find.textContaining('Prestation'), findsOneWidget);
      expect(find.textContaining('Acompte'), findsOneWidget);
      expect(find.textContaining('Reste à payer'), findsOneWidget);
    });

    testWidgets('renders cancellation policy', (tester) async {
      await tester.pumpWidget(_wrapBookingReviewPage());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.textContaining('Annulation gratuite'), findsOneWidget);
    });

    testWidgets('confirms with deposit label when deposit > 0', (tester) async {
      await tester.pumpWidget(_wrapBookingReviewPage());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text("Payer l'acompte"), findsOneWidget);
    });
  });

  group('BookingSuccessPage', () {
    testWidgets('renders success confirmation message', (tester) async {
      await tester.pumpWidget(_wrapBookingSuccessPage());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Réservation confirmée !'), findsOneWidget);
    });

    testWidgets('renders booking summary with salon and service', (tester) async {
      await tester.pumpWidget(_wrapBookingSuccessPage());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Salon Test'), findsOneWidget);
      expect(find.text('Coupe Homme'), findsOneWidget);
    });

    testWidgets('renders action buttons', (tester) async {
      await tester.pumpWidget(_wrapBookingSuccessPage());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Voir mon rendez-vous'), findsOneWidget);
      expect(find.text("Retour à l'accueil"), findsOneWidget);
    });
  });
}
