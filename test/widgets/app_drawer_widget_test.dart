import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/widgets/app_drawer_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/l10n_test_app.dart';

class _WideDrawerTheme extends StatelessWidget {
  final Widget child;
  const _WideDrawerTheme({required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        drawerTheme: const DrawerThemeData(width: 600),
      ),
      child: child,
    );
  }
}

void main() {
  Widget createTestWidget({
    VoidCallback? onHistoryTap,
    VoidCallback? onImcTap,
    VoidCallback? onSettingsTap,
  }) {
    return L10nTestApp(
      child: _WideDrawerTheme(
        child: Scaffold(
          endDrawer: AppDrawerWidget(
            onHistoryTap: onHistoryTap ?? () {},
            onImcTap: onImcTap ?? () {},
            onSettingsTap: onSettingsTap ?? () {},
          ),
          body: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
              child: const Text('abrir drawer'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openDrawer(WidgetTester tester) async {
    await tester.tap(find.text('abrir drawer'));
    await tester.pumpAndSettle();
  }

  group('AppDrawerWidget', () {
    testWidgets('deve exibir nome do app no cabeçalho', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openDrawer(tester);

      expect(find.text(AppStrings.appName), findsOneWidget);
    });

    testWidgets('deve exibir item Histórico', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openDrawer(tester);

      expect(find.text('Histórico'), findsOneWidget);
    });

    testWidgets('deve exibir item Calculadora IMC', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openDrawer(tester);

      expect(find.text('Calculadora IMC'), findsOneWidget);
    });

    testWidgets('deve exibir item Configurações', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openDrawer(tester);

      expect(find.text('Configurações'), findsOneWidget);
    });

    testWidgets('deve exibir ícone de histórico', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openDrawer(tester);

      expect(find.byIcon(Icons.history), findsOneWidget);
    });

    testWidgets('deve exibir ícone de IMC', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openDrawer(tester);

      expect(find.byIcon(Icons.monitor_weight_outlined), findsOneWidget);
    });

    testWidgets('deve exibir ícone de configurações', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openDrawer(tester);

      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });

    testWidgets('deve exibir três NeumorphicButton para os itens do menu', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await openDrawer(tester);

      expect(find.byType(NeumorphicButton), findsNWidgets(3));
    });

    testWidgets('deve chamar onHistoryTap ao pressionar Histórico', (
      tester,
    ) async {
      bool called = false;

      await tester.pumpWidget(
        createTestWidget(onHistoryTap: () => called = true),
      );
      await openDrawer(tester);

      await tester.tap(find.text('Histórico'));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('deve chamar onImcTap ao pressionar Calculadora IMC', (
      tester,
    ) async {
      bool called = false;

      await tester.pumpWidget(
        createTestWidget(onImcTap: () => called = true),
      );
      await openDrawer(tester);

      await tester.tap(find.text('Calculadora IMC'));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('deve chamar onSettingsTap ao pressionar Configurações', (
      tester,
    ) async {
      bool called = false;

      await tester.pumpWidget(
        createTestWidget(onSettingsTap: () => called = true),
      );
      await openDrawer(tester);

      await tester.tap(find.text('Configurações'));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });
  });
}
