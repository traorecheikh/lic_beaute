import 'package:beauteavenue_mobile_client/src/core/widgets/app_pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_harness.dart';

void main() {
  group('AppPressable', () {
    testWidgets('invokes onTap when enabled', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestableWidget(
          AppPressable(
            onTap: () => taps += 1,
            child: const Text('Tap me'),
          ),
        ),
      );

      await tester.tap(find.text('Tap me'));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('changes opacity while pressed then restores it', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const AppPressable(
            opacity: 0.3,
            child: Text('Press and hold'),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Press and hold')),
      );
      await tester.pump();

      AnimatedOpacity animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(animatedOpacity.opacity, 0.3);

      await gesture.up();
      await tester.pump();

      animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(animatedOpacity.opacity, 1.0);
    });

    testWidgets('stays dim and ignores taps when disabled', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestableWidget(
          AppPressable(
            enabled: false,
            onTap: () => taps += 1,
            child: const Text('Disabled'),
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();

      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(animatedOpacity.opacity, 0.4);
      expect(taps, 0);
    });
  });
}
