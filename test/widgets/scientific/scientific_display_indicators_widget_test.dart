import 'package:calculator_05122025/utils/enums/angle_mode.dart';
import 'package:calculator_05122025/widgets/scientific/scientific_display_indicators_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({
    AngleMode angleMode = AngleMode.deg,
    bool hasMemoryValue = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ScientificDisplayIndicatorsWidget(
          angleMode: angleMode,
          hasMemoryValue: hasMemoryValue,
        ),
      ),
    );
  }

  group('ScientificDisplayIndicatorsWidget', () {
    testWidgets('mostra DEG quando angleMode é deg', (tester) async {
      await tester.pumpWidget(createTestWidget(angleMode: AngleMode.deg));
      expect(find.text('DEG'), findsOneWidget);
    });

    testWidgets('mostra RAD quando angleMode é rad', (tester) async {
      await tester.pumpWidget(createTestWidget(angleMode: AngleMode.rad));
      expect(find.text('RAD'), findsOneWidget);
    });

    testWidgets('não mostra M quando hasMemoryValue é false', (tester) async {
      await tester.pumpWidget(createTestWidget(hasMemoryValue: false));
      expect(
        find.byKey(const ValueKey('scientific_memory_indicator')),
        findsNothing,
      );
    });

    testWidgets('mostra M quando hasMemoryValue é true', (tester) async {
      await tester.pumpWidget(createTestWidget(hasMemoryValue: true));
      expect(
        find.byKey(const ValueKey('scientific_memory_indicator')),
        findsOneWidget,
      );
    });
  });
}
