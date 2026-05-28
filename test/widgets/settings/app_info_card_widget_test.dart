import 'package:calculator_05122025/widgets/settings/app_info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../helpers/l10n_test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildTestWidget() {
    return const L10nTestApp(
      child: Scaffold(
        body: SingleChildScrollView(child: AppInfoCardWidget()),
      ),
    );
  }

  group('AppInfoCardWidget', () {
    testWidgets('deve exibir traço enquanto versão carrega', (tester) async {
      PackageInfo.setMockInitialValues(
        appName: 'Test',
        packageName: 'com.test',
        version: '2.0.0',
        buildNumber: '1',
        buildSignature: '',
      );

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('—'), findsOneWidget);
    });

    testWidgets('deve exibir versão após carregamento', (tester) async {
      PackageInfo.setMockInitialValues(
        appName: 'Test',
        packageName: 'com.test',
        version: '2.0.0',
        buildNumber: '1',
        buildSignature: '',
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('v2.0.0'), findsOneWidget);
    });

    testWidgets('deve exibir label Programador', (tester) async {
      PackageInfo.setMockInitialValues(
        appName: 'Test',
        packageName: 'com.test',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: '',
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Programador'), findsOneWidget);
      expect(find.text('Leankar.dev'), findsOneWidget);
    });

    testWidgets('deve exibir label E-mail com valor correto', (tester) async {
      PackageInfo.setMockInitialValues(
        appName: 'Test',
        packageName: 'com.test',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: '',
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('leankar.dev@gmail.com'), findsOneWidget);
    });

    testWidgets('deve exibir label Website com valor correto', (tester) async {
      PackageInfo.setMockInitialValues(
        appName: 'Test',
        packageName: 'com.test',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: '',
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Website'), findsOneWidget);
      expect(find.text('leankar.dev'), findsOneWidget);
    });

    testWidgets('deve exibir label SOBRE O APP', (tester) async {
      PackageInfo.setMockInitialValues(
        appName: 'Test',
        packageName: 'com.test',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: '',
      );

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('SOBRE O APP'), findsOneWidget);
    });
  });
}
