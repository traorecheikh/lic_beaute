import 'package:beauteavenue_mobile_client/src/core/utils/app_list_utils.dart';
import 'package:beauteavenue_mobile_client/src/features/discovery/widgets/stale_data_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_harness.dart';

void main() {
  group('AppListUtils.getItemCount', () {
    test('adds stale notice row when cache is stale and timestamp exists', () {
      final now = DateTime.now();
      expect(AppListUtils.getItemCount(3, true, now), 4);
    });

    test('keeps original count when not stale or timestamp is missing', () {
      expect(AppListUtils.getItemCount(3, false, DateTime.now()), 3);
      expect(AppListUtils.getItemCount(3, true, null), 3);
    });
  });

  group('AppListUtils.buildItem', () {
    testWidgets('returns stale notice at index 0 when stale mode is enabled', (
      tester,
    ) async {
      final cachedAt = DateTime.now().subtract(const Duration(minutes: 5));
      late Widget built;

      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) {
              built = AppListUtils.buildItem(
                context: context,
                index: 0,
                items: const <String>['A', 'B'],
                isStale: true,
                cachedAt: cachedAt,
                itemBuilder: (_, _, _) => const SizedBox.shrink(),
              );
              return built;
            },
          ),
        ),
      );

      expect(built, isA<StaleDataNotice>());
      expect(find.byType(StaleDataNotice), findsOneWidget);
    });

    testWidgets('passes shifted index to itemBuilder when stale notice is used', (
      tester,
    ) async {
      int? receivedIndex;
      String? receivedItem;

      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) {
              return AppListUtils.buildItem(
                context: context,
                index: 2,
                items: const <String>['A', 'B', 'C'],
                isStale: true,
                cachedAt: DateTime.now(),
                itemBuilder: (_, index, item) {
                  receivedIndex = index;
                  receivedItem = item as String;
                  return Text('Item $item');
                },
              );
            },
          ),
        ),
      );

      expect(receivedIndex, 1);
      expect(receivedItem, 'B');
      expect(find.text('Item B'), findsOneWidget);
    });

    testWidgets('uses direct index when stale notice is not active', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) {
              return AppListUtils.buildItem(
                context: context,
                index: 1,
                items: const <String>['A', 'B'],
                isStale: false,
                cachedAt: null,
                itemBuilder: (_, index, item) => Text('$index:$item'),
              );
            },
          ),
        ),
      );

      expect(find.text('1:B'), findsOneWidget);
    });
  });
}
