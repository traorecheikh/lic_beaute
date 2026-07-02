import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:beauteavenue_mobile_client/src/core/constants/app_strings.dart';
import 'package:beauteavenue_mobile_client/src/features/appointments/pages/bookings_list_page.dart';
import 'package:beauteavenue_mobile_client/src/features/appointments/providers/bookings_list_provider.dart';
import 'package:beauteavenue_mobile_client/src/features/discovery/providers/cached_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_harness.dart';

void main() {
  testWidgets('bookings header lays out without sliver geometry errors', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookingsListProvider.overrideWith(
            (ref) async => const CachedResource<BookingSummaryListResponse>(
              data: null,
              isStale: false,
            ),
          ),
        ],
        child: buildTestableRouterWidget(
          (_) => const BookingsListPage(),
          path: '/bookings',
          initialLocation: '/bookings',
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.takeException(), isNull);
    expect(find.text(AppStrings.bookingsPageHeading), findsOneWidget);
    expect(find.text(AppStrings.bookingsTabUpcoming), findsOneWidget);
    expect(find.text(AppStrings.bookingsTabPast), findsOneWidget);
  });
}
