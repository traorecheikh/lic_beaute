import 'package:beauteavenue_mobile_client/src/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_harness.dart';

void main() {
  group('AppButton', () {
    testWidgets('primary button fires onPressed callback', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        buildTestableWidget(
          AppButton.primary(
            label: 'Continuer',
            onPressed: () => taps += 1,
          ),
        ),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(taps, 1);
      expect(find.text('Continuer'), findsOneWidget);
    });

    testWidgets('loading state shows indicator and hides text label', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton.primary(
            label: 'Envoyer',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Envoyer'), findsNothing);
    });

    testWidgets('outline variant renders optional icon', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton.outline(
            label: 'Add',
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('text variant remains tappable without fixed size', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton.text(
            label: 'Annuler',
            onPressed: () => taps += 1,
          ),
        ),
      );

      await tester.tap(find.text('Annuler'));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('disabled state removes tap handlers', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AppButton.primary(
            label: 'Désactivé',
            onPressed: null,
          ),
        ),
      );

      final detector = tester.widget<GestureDetector>(
        find.descendant(
          of: find.byType(AppButton),
          matching: find.byType(GestureDetector),
        ),
      );
      expect(detector.onTap, isNull);
      expect(detector.onTapDown, isNull);
      expect(detector.onTapCancel, isNull);
    });

    testWidgets('transitioning to loading state is stable', (tester) async {
      const key = ValueKey('button-under-test');

      await tester.pumpWidget(
        buildTestableWidget(
          AppButton.primary(
            key: key,
            label: 'Valider',
            onPressed: () {},
          ),
        ),
      );

      await tester.pumpWidget(
        buildTestableWidget(
          AppButton.primary(
            key: key,
            label: 'Valider',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('long labels wrap instead of being replaced by an ellipsis', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          SizedBox(
            width: 250,
            child: AppButton.primary(
              label: 'Continuer la vérification en arrière-plan',
              onPressed: () {},
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(
        find.text('Continuer la vérification en arrière-plan'),
      );
      expect(text.maxLines, 2);
      expect(text.overflow, TextOverflow.visible);
      expect(tester.getSize(find.byType(AppButton)).height, greaterThanOrEqualTo(56));
    });
  });
}
