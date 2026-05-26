import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/widgets/app_drawer_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

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
    return NeumorphicApp(
      home: _WideDrawerTheme(
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

      expect(find.text(AppStrings.drawerItemHistory), findsOneWidget);
    });

    testWidgets('deve exibir item Calculadora IMC', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openDrawer(tester);

      expect(find.text(AppStrings.imcPageTitle), findsOneWidget);
    });

    testWidgets('deve exibir item Configurações', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openDrawer(tester);

      expect(find.text(AppStrings.settingsPageTitle), findsOneWidget);
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

    testWidgets('deve exibir três NeumorphicButton para os itens do menu',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openDrawer(tester);

      expect(find.byType(NeumorphicButton), findsNWidgets(3));
    });

    testWidgets('deve chamar onHistoryTap ao pressionar Histórico',
        (tester) async {
      bool called = false;

      await tester.pumpWidget(
        createTestWidget(onHistoryTap: () => called = true),
      );
      await openDrawer(tester);

      await tester.tap(find.text(AppStrings.drawerItemHistory));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('deve chamar onImcTap ao pressionar Calculadora IMC',
        (tester) async {
      bool called = false;

      await tester.pumpWidget(
        createTestWidget(onImcTap: () => called = true),
      );
      await openDrawer(tester);

      await tester.tap(find.text(AppStrings.imcPageTitle));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('deve chamar onSettingsTap ao pressionar Configurações',
        (tester) async {
      bool called = false;

      await tester.pumpWidget(
        createTestWidget(onSettingsTap: () => called = true),
      );
      await openDrawer(tester);

      await tester.tap(find.text(AppStrings.settingsPageTitle));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });
  });
}
