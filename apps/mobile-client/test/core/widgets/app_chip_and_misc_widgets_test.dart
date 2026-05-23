import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'package:beauteavenue_mobile_client/src/core/widgets/app_chip.dart';
import 'package:beauteavenue_mobile_client/src/core/widgets/app_divider.dart';
import 'package:beauteavenue_mobile_client/src/core/widgets/app_section_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_harness.dart';

void main() {
  group('AppChip', () {
    testWidgets('applies selected colors and handles tap', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestableWidget(
          AppChip(
            label: 'Premium',
            selected: true,
            onTap: () => taps += 1,
          ),
        ),
      );

      final chipContainer = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppChip),
          matching: find.byType(Container),
        ),
      );
      final chipDecoration = chipContainer.decoration as BoxDecoration;
      final label = tester.widget<Text>(find.text('Premium'));

      expect(chipDecoration.color, AppColors.primary);
      expect(label.style?.color, AppColors.onPrimary);

      await tester.tap(find.text('Premium'));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('applies unselected colors and disables interactions when onTap is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const AppChip(
            label: 'Standard',
            selected: false,
          ),
        ),
      );

      final chipContainer = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppChip),
          matching: find.byType(Container),
        ),
      );
      final chipDecoration = chipContainer.decoration as BoxDecoration;
      final label = tester.widget<Text>(find.text('Standard'));

      expect(chipDecoration.color, AppColors.surfaceVariant);
      expect(label.style?.color, AppColors.onSurfaceVariant);

      await tester.tap(find.text('Standard'));
      await tester.pump();
    });
  });

  group('AppSectionLabel', () {
    testWidgets('uses default section style when style is omitted', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const AppSectionLabel('Informations')),
      );

      final text = tester.widget<Text>(find.text('Informations'));
      expect(text.style, AppTextStyles.headlineSm);
    });

    testWidgets('uses provided style override when set', (tester) async {
      const style = TextStyle(color: Colors.teal, fontSize: 18);

      await tester.pumpWidget(
        buildTestableWidget(const AppSectionLabel('Contact', style: style)),
      );

      final text = tester.widget<Text>(find.text('Contact'));
      expect(text.style, style);
    });
  });

  group('AppDivider', () {
    testWidgets('uses default outline variant color', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const AppDivider()));

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, AppColors.outlineVariant);
    });

    testWidgets('uses custom color when provided', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const AppDivider(color: Colors.black)),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, Colors.black);
    });
  });
}
