import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/widgets/ads/banner_ad_placeholder_widget.dart';
import 'package:calculator_05122025/widgets/ads/banner_ad_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildTestWidget() {
    return const NeumorphicApp(
      home: Scaffold(body: BannerAdWidget()),
    );
  }

  group('BannerAdWidget', () {
    testWidgets(
      'exibe BannerAdPlaceholderWidget quando o canal de plataforma do SDK não está disponível',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();
        expect(find.byType(BannerAdPlaceholderWidget), findsOneWidget);
      },
    );

    testWidgets(
      'placeholder tem SizedBox com altura de adBannerPlaceholderHeight',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SizedBox &&
                widget.height == AppSizes.adBannerPlaceholderHeight,
          ),
          findsWidgets,
        );
      },
    );

    testWidgets('placeholder contém widget Neumorphic', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      expect(
        find.descendant(
          of: find.byType(BannerAdPlaceholderWidget),
          matching: find.byType(Neumorphic),
        ),
        findsOneWidget,
      );
    });

    testWidgets('mantém placeholder após múltiplos pumps', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(BannerAdPlaceholderWidget), findsOneWidget);
    });
  });
}
