import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/widgets/splash/splash_title_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/l10n_test_app.dart';
import '../../helpers/text_scaled_box.dart';

void main() {
  Widget createTestWidget(double value, {double textScale = 1.0}) {
    return L10nTestApp(
      child: TextScaledBox(
        textScale: textScale,
        child: Center(
          child: SplashTitleWidget(
            animation: AlwaysStoppedAnimation(value),
            text: AppStrings.appName,
          ),
        ),
      ),
    );
  }

  List<double> readOpacities(WidgetTester tester) {
    return tester
        .widgetList<Opacity>(
          find.descendant(
            of: find.byType(SplashTitleWidget),
            matching: find.byType(Opacity),
          ),
        )
        .map((opacity) => opacity.opacity)
        .toList();
  }

  final lettersCount = AppStrings.appName.replaceAll(' ', '').length;

  group('SplashTitleWidget', () {
    testWidgets('uma letra por caractere, sem contar o espaço', (tester) async {
      await tester.pumpWidget(createTestWidget(0.6));

      expect(readOpacities(tester), hasLength(lettersCount));
    });

    testWidgets('exibe o nome da marca letra a letra', (tester) async {
      await tester.pumpWidget(createTestWidget(0.6));

      final shown = tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(SplashTitleWidget),
              matching: find.byType(Text),
            ),
          )
          .map((text) => text.data)
          .join();

      expect(shown, AppStrings.appName.replaceAll(' ', ''));
    });

    testWidgets('começa com todas as letras invisíveis', (tester) async {
      await tester.pumpWidget(createTestWidget(0.0));

      expect(readOpacities(tester), everyElement(0.0));
    });

    testWidgets('mostra todas as letras depois da revelação', (tester) async {
      await tester.pumpWidget(createTestWidget(0.6));

      expect(readOpacities(tester), everyElement(1.0));
    });

    testWidgets('as letras somem de novo no fim da saída', (tester) async {
      await tester.pumpWidget(createTestWidget(1.0));

      expect(readOpacities(tester), everyElement(0.0));
    });

    testWidgets('as letras surgem em sequência durante a revelação', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(0.4));

      final opacities = readOpacities(tester);

      expect(opacities.first, greaterThan(opacities.last));
      for (var index = 1; index < opacities.length; index++) {
        expect(opacities[index], lessThanOrEqualTo(opacities[index - 1]));
      }
    });

    testWidgets('é decorativo e fica fora da árvore de semântica', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(0.6));

      expect(
        find.descendant(
          of: find.byType(SplashTitleWidget),
          matching: find.byType(ExcludeSemantics),
        ),
        findsWidgets,
      );
    });

    testWidgets('cabe em 320x568 com texto ampliado sem overflow', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestWidget(0.6, textScale: 1.5));

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(SplashTitleWidget)).width,
        lessThanOrEqualTo(320),
      );
    });
  });
}
