import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_harness.dart';

void main() {
  group('AppTheme', () {
    testWidgets('light theme exposes expected base tokens', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const SizedBox.shrink()));

      final theme = AppTheme.light;

      expect(theme.useMaterial3, isTrue);
      expect(theme.scaffoldBackgroundColor, AppColors.neutral);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.secondary, AppColors.secondary);
      expect(theme.cardTheme.color, AppColors.surface);
      expect(theme.bottomNavigationBarTheme.backgroundColor, Colors.transparent);
    });

    testWidgets('dark theme overrides dark surfaces and app bar style', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(const SizedBox.shrink()));

      final theme = AppTheme.dark;

      expect(theme.scaffoldBackgroundColor, AppColors.darkBackground);
      expect(theme.colorScheme.surface, AppColors.darkSurface);
      expect(theme.colorScheme.onSurface, AppColors.darkOnSurface);
      expect(theme.appBarTheme.backgroundColor, AppColors.darkBackground);
      expect(theme.appBarTheme.systemOverlayStyle, SystemUiOverlayStyle.light);
    });

    testWidgets('stateButtonStyle resolves expected defaults', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const SizedBox.shrink()));
      final context = tester.element(find.byType(SizedBox));

      final style = AppTheme.stateButtonStyle(context);

      expect(style.backgroundColor?.resolve(<WidgetState>{}), AppColors.primary);
      expect(style.foregroundColor?.resolve(<WidgetState>{}), Colors.white);
      expect(style.shape?.resolve(<WidgetState>{}), isA<RoundedRectangleBorder>());
    });
  });
}
