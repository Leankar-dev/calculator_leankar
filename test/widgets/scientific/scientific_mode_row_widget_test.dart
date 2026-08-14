import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/widgets/scientific/scientific_mode_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/l10n_test_app.dart';

void main() {
  Widget createTestWidget({
    AngleMode angleMode = AngleMode.deg,
    bool isShiftActive = false,
    VoidCallback? onToggleAngleMode,
    VoidCallback? onToggleShift,
    VoidCallback? onLockShift,
    VoidCallback? onPi,
    VoidCallback? onEuler,
  }) {
    return L10nTestApp(
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: ScientificModeRowWidget(
                angleMode: angleMode,
                isShiftActive: isShiftActive,
                onToggleAngleMode: onToggleAngleMode ?? () {},
                onToggleShift: onToggleShift ?? () {},
                onLockShift: onLockShift ?? () {},
                onPi: onPi ?? () {},
                onEuler: onEuler ?? () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  group('ScientificModeRowWidget', () {
    testWidgets('mostra DEG quando angleMode é deg', (tester) async {
      await tester.pumpWidget(createTestWidget(angleMode: AngleMode.deg));
      expect(find.text('DEG'), findsOneWidget);
    });

    testWidgets('mostra RAD quando angleMode é rad', (tester) async {
      await tester.pumpWidget(createTestWidget(angleMode: AngleMode.rad));
      expect(find.text('RAD'), findsOneWidget);
    });

    testWidgets('toque no botão de ângulo chama onToggleAngleMode', (
      tester,
    ) async {
      var called = false;
      await tester.pumpWidget(
        createTestWidget(onToggleAngleMode: () => called = true),
      );
      await tester.tap(find.byKey(const ValueKey('scientific_angle_mode')));
      await tester.pumpAndSettle();
      expect(called, isTrue);
    });

    testWidgets('toque curto no SHIFT chama onToggleShift', (tester) async {
      var called = false;
      await tester.pumpWidget(
        createTestWidget(onToggleShift: () => called = true),
      );
      await tester.tap(find.byKey(const ValueKey('scientific_shift')));
      await tester.pumpAndSettle();
      expect(called, isTrue);
    });

    testWidgets('toque longo no SHIFT chama onLockShift', (tester) async {
      var called = false;
      await tester.pumpWidget(
        createTestWidget(onLockShift: () => called = true),
      );
      await tester.longPress(find.byKey(const ValueKey('scientific_shift')));
      await tester.pumpAndSettle();
      expect(called, isTrue);
    });

    testWidgets('mostra π e e', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('π'), findsOneWidget);
      expect(find.text('e'), findsOneWidget);
    });

    testWidgets('toque em π chama onPi', (tester) async {
      var called = false;
      await tester.pumpWidget(createTestWidget(onPi: () => called = true));
      await tester.tap(find.byKey(const ValueKey('scientific_pi')));
      await tester.pumpAndSettle();
      expect(called, isTrue);
    });

    testWidgets('toque em e chama onEuler', (tester) async {
      var called = false;
      await tester.pumpWidget(createTestWidget(onEuler: () => called = true));
      await tester.tap(find.byKey(const ValueKey('scientific_euler')));
      await tester.pumpAndSettle();
      expect(called, isTrue);
    });
  });
}
