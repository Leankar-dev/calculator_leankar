import 'package:calculator_05122025/controllers/ad_consent_controller.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/widgets/settings/ad_consent_settings_widget.dart';
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

  Future<void> createController(Map<String, Object> storedValues) async {
    SharedPreferences.setMockInitialValues(storedValues);
    mockLevelPlayAdService = MockLevelPlayAdService();
    mockLogger = MockLoggerService();
    controller = AdConsentController(
      levelPlayAdService: mockLevelPlayAdService,
      loggerService: mockLogger,
    );
    await controller.loadPersistedConsent();
  }

  Widget buildTestWidget() {
    return L10nTestApp(
      child: Scaffold(body: AdConsentSettingsWidget(controller: controller)),
    );
  }

  Future<void> tapSwitch(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('ad_consent_switch')));
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
  }

  NeumorphicSwitch currentSwitch(WidgetTester tester) {
    return tester.widget<NeumorphicSwitch>(
      find.byKey(const ValueKey('ad_consent_switch')),
    );
  }

  group('AdConsentSettingsWidget', () {
    testWidgets('exibe cabeçalho, título e descrição', (tester) async {
      await createController({});
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('ANÚNCIOS'), findsOneWidget);
      expect(find.text('Exibir anúncios'), findsOneWidget);
      expect(
        find.text(
          'Os anúncios mantêm o app gratuito. Você pode alterar esta escolha a qualquer momento.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('o interruptor começa desligado sem consentimento', (
      tester,
    ) async {
      await createController({});
      await tester.pumpWidget(buildTestWidget());

      expect(currentSwitch(tester).value, isFalse);
    });

    testWidgets('o interruptor começa ligado com consentimento salvo', (
      tester,
    ) async {
      await createController({AppStrings.prefAdConsentKey: true});
      await tester.pumpWidget(buildTestWidget());

      expect(currentSwitch(tester).value, isTrue);
    });

    testWidgets('ligar concede o consentimento e inicializa o SDK', (
      tester,
    ) async {
      await createController({});
      await tester.pumpWidget(buildTestWidget());

      await tapSwitch(tester);

      expect(controller.state.canRequestAds, isTrue);
      expect(mockLevelPlayAdService.initializeCalled, isTrue);
      expect(currentSwitch(tester).value, isTrue);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(AppStrings.prefAdConsentKey), isTrue);
    });

    testWidgets('desligar revoga o consentimento e persiste a escolha', (
      tester,
    ) async {
      await createController({AppStrings.prefAdConsentKey: true});
      await tester.pumpWidget(buildTestWidget());

      await tapSwitch(tester);

      expect(controller.state.canRequestAds, isFalse);
      expect(currentSwitch(tester).value, isFalse);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(AppStrings.prefAdConsentKey), isFalse);
    });
  });
}
