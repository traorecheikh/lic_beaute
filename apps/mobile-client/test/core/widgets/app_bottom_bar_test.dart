import 'package:beauteavenue_mobile_client/src/core/widgets/app_bottom_bar.dart';
import 'package:beauteavenue_mobile_client/src/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('bottom action bar shrink-wraps instead of filling the screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, _) => MaterialApp(
          home: Scaffold(
            body: const SizedBox.expand(),
            bottomNavigationBar: AppBottomBar(
              child: AppButton.primary(
                label: 'Continuer',
                onPressed: () {},
                height: 58,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final barHeight = tester.getSize(find.byType(AppBottomBar)).height;
    expect(barHeight, greaterThanOrEqualTo(58));
    expect(barHeight, lessThan(140));
  });
}
