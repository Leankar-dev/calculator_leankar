import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:calculator_05122025/widgets/settings/theme_selector_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/l10n_test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SettingsController.instance.loadSettings();
  });

  Widget buildTestWidget() {
    return L10nTestApp(
      child: Scaffold(
        body: ThemeSelectorWidget(controller: SettingsController.instance),
      ),
    );
  }

  group('ThemeSelectorWidget', () {
    testWidgets('deve renderizar os 3 segmentos de tema', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Sistema'), findsOneWidget);
      expect(find.text('Claro'), findsOneWidget);
      expect(find.text('Escuro'), findsOneWidget);
    });

    testWidgets('deve exibir segmento Sistema selecionado por padrão', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      final button = tester.widget<SegmentedButton<ThemeMode>>(
        find.byType(SegmentedButton<ThemeMode>),
      );
      expect(button.selected, {ThemeMode.system});
    });

    testWidgets('deve exibir segmento correto após mudança no controller', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      await SettingsController.instance.setThemeMode(ThemeMode.dark);
      await tester.pump();

      final button = tester.widget<SegmentedButton<ThemeMode>>(
        find.byType(SegmentedButton<ThemeMode>),
      );
      expect(button.selected, {ThemeMode.dark});
    });

    testWidgets('deve chamar setThemeMode ao selecionar Claro', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('Claro'));
      await tester.pump();

      expect(SettingsController.instance.themeMode, ThemeMode.light);
    });

    testWidgets('deve exibir label APARÊNCIA', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('APARÊNCIA'), findsOneWidget);
    });
  });
}
