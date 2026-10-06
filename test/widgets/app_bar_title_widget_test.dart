import 'package:calculator_05122025/widgets/app_bar_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({required String text, required double width}) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: width,
            child: AppBarTitleWidget(text: text),
          ),
        ),
      ),
    );
  }

  group('AppBarTitleWidget', () {
    testWidgets('exibe o texto informado', (tester) async {
      await tester.pumpWidget(
        createTestWidget(text: 'Calculadora IMC', width: 400),
      );
      expect(find.text('Calculadora IMC'), findsOneWidget);
    });

    testWidgets('reduz o texto para caber em largura estreita sem cortar', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(text: 'Calculadora Científica', width: 120),
      );
      final titleRect = tester.getRect(find.byType(AppBarTitleWidget));
      final textRect = tester.getRect(find.text('Calculadora Científica'));
      expect(textRect.width, lessThanOrEqualTo(titleRect.width));
      expect(tester.takeException(), isNull);
    });
  });
}
