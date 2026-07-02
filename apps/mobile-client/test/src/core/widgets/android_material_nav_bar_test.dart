import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beauteavenue_mobile_client/src/core/constants/app_strings.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import 'package:beauteavenue_mobile_client/src/core/widgets/android_material_nav_bar.dart';

void main() {
  Widget buildHarness({
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          bottomNavigationBar: AndroidMaterialNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  testWidgets(
    'uses a Material 3 NavigationBar with exactly three destinations',
    (tester) async {
      await tester.pumpWidget(buildHarness(currentIndex: 0, onTap: (_) {}));

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationDestination), findsNWidgets(3));
      expect(find.text(AppStrings.discoverTab), findsOneWidget);
      expect(find.text(AppStrings.bookingsTab), findsOneWidget);
      expect(find.text(AppStrings.profileTab), findsOneWidget);
    },
  );

  testWidgets('respects the selected index from router state', (tester) async {
    await tester.pumpWidget(buildHarness(currentIndex: 2, onTap: (_) {}));

    final nav = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(nav.selectedIndex, 2);
  });

  testWidgets('invokes the selection callback once per tap', (tester) async {
    final tapped = <int>[];

    await tester.pumpWidget(buildHarness(currentIndex: 0, onTap: tapped.add));

    await tester.tap(find.text(AppStrings.bookingsTab));
    await tester.pumpAndSettle();

    expect(tapped, <int>[1]);
  });
}
