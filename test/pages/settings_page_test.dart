import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:calculator_05122025/pages/settings_page.dart';
import 'package:calculator_05122025/widgets/settings/app_info_card_widget.dart';
import 'package:calculator_05122025/widgets/settings/theme_selector_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SettingsController.instance.loadSettings();
    PackageInfo.setMockInitialValues(
      appName: 'Test',
      packageName: 'com.test',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  Widget buildTestWidget() {
    return NeumorphicApp(
      home: SettingsPage(controller: SettingsController.instance),
    );
  }

  group('SettingsPage', () {
    testWidgets('deve carregar sem erros e exibir widgets principais',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ThemeSelectorWidget), findsOneWidget);
      expect(find.byType(AppInfoCardWidget), findsOneWidget);
    });

    testWidgets('deve exibir título Configurações na AppBar', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Configurações'), findsOneWidget);
    });

    testWidgets('deve exibir segmento Sistema selecionado por padrão',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final button = tester.widget<SegmentedButton<ThemeMode>>(
        find.byType(SegmentedButton<ThemeMode>),
      );
      expect(button.selected, {ThemeMode.system});
    });

    testWidgets('deve atualizar controller ao tocar em Claro', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('Claro'));
      await tester.pump();

      expect(SettingsController.instance.themeMode, ThemeMode.light);
    });

    testWidgets('deve atualizar controller ao tocar em Escuro', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('Escuro'));
      await tester.pump();

      expect(SettingsController.instance.themeMode, ThemeMode.dark);
    });
  });
}
