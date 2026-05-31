import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/widgets/ads/banner_ad_placeholder_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({required double height}) {
    return NeumorphicApp(
      home: Scaffold(
        body: BannerAdPlaceholderWidget(height: height),
      ),
    );
  }

  group('BannerAdPlaceholderWidget', () {
    testWidgets('renderiza sem erros com altura padrão', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(height: AppSizes.adBannerPlaceholderHeight),
      );
      expect(find.byType(BannerAdPlaceholderWidget), findsOneWidget);
    });

    testWidgets('contém widget Neumorphic', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(height: AppSizes.adBannerPlaceholderHeight),
      );
      expect(
        find.descendant(
          of: find.byType(BannerAdPlaceholderWidget),
          matching: find.byType(Neumorphic),
        ),
        findsOneWidget,
      );
    });

    testWidgets('tem SizedBox com altura de adBannerPlaceholderHeight', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(height: AppSizes.adBannerPlaceholderHeight),
      );
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox &&
              widget.height == AppSizes.adBannerPlaceholderHeight &&
              widget.width == double.infinity,
        ),
        findsOneWidget,
      );
    });

    testWidgets('aceita altura customizada', (WidgetTester tester) async {
      const customHeight = 100.0;
      await tester.pumpWidget(buildTestWidget(height: customHeight));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.height == customHeight,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renderiza sem erros com altura mínima', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(height: 1.0));
      expect(find.byType(BannerAdPlaceholderWidget), findsOneWidget);
    });
  });
}
