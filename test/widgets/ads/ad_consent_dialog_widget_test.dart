import 'package:calculator_05122025/controllers/ad_consent_controller.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/widgets/ads/ad_consent_dialog_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/l10n_test_app.dart';
import '../../mocks/mock_level_play_ad_service.dart';
import '../../mocks/mock_logger_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLevelPlayAdService mockLevelPlayAdService;
  late MockLoggerService mockLogger;
  late AdConsentController controller;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockLevelPlayAdService = MockLevelPlayAdService();
    mockLogger = MockLoggerService();
    controller = AdConsentController(
      levelPlayAdService: mockLevelPlayAdService,
      loggerService: mockLogger,
    );
  });

  Widget buildTestWidget() {
    return L10nTestApp(
      child: Scaffold(
        body: AdConsentDialogWidget(controller: controller),
      ),
    );
  }

  group('AdConsentDialogWidget', () {
    testWidgets('exibe o título do diálogo', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Privacidade e Anúncios'), findsOneWidget);
    });

    testWidgets('exibe o corpo do diálogo', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(
        find.text(
          'Este app exibe anúncios para manter-se gratuito. Você pode escolher suas preferências de privacidade.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('exibe o botão de aceitar', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Aceitar'), findsOneWidget);
    });

    testWidgets('exibe o botão de recusar', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Recusar'), findsOneWidget);
    });

    testWidgets(
      'ao aceitar, grava preferência true e inicializa o serviço',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Aceitar'));
        await tester.pump();
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await tester.pumpAndSettle();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool(AppStrings.prefAdConsentKey), isTrue);
        expect(mockLevelPlayAdService.initializeCalled, isTrue);
      },
    );

    testWidgets(
      'ao recusar, grava preferência false e não inicializa o serviço',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Recusar'));
        await tester.pump();
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await tester.pumpAndSettle();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool(AppStrings.prefAdConsentKey), isFalse);
        expect(mockLevelPlayAdService.initializeCalled, isFalse);
      },
    );

    testWidgets('fecha o diálogo após a escolha', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        L10nTestApp(
          child: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => AdConsentDialogWidget(controller: controller),
                ),
                child: const Text('abrir'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      expect(find.byType(AdConsentDialogWidget), findsOneWidget);

      await tester.tap(find.text('Aceitar'));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AdConsentDialogWidget), findsNothing);
    });
  });
}
