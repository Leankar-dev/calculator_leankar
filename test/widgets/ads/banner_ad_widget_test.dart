import 'package:calculator_05122025/services/ad_mob_service.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/result.dart';
import 'package:calculator_05122025/widgets/ads/banner_ad_placeholder_widget.dart';
import 'package:calculator_05122025/widgets/ads/banner_ad_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class _FakeBannerAd extends BannerAd {
  _FakeBannerAd({required super.listener})
    : super(
        adUnitId: 'ca-app-pub-3940256099942544/2934735716',
        size: AdSize.banner,
        request: const AdRequest(),
      );

  @override
  Future<void> load() async {}

  @override
  Future<void> dispose() async {}
}

class _TestAdMobService extends AdMobService {
  @override
  Future<Result<InitializationStatus>> initialize() async {
    return Result.failure(ErrorType.adMobInitError, 'mock');
  }

  @override
  BannerAd createBannerAd({
    required AdSize size,
    required BannerAdListener listener,
  }) {
    return _FakeBannerAd(listener: listener);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildTestWidget() {
    return NeumorphicApp(
      home: Scaffold(
        body: BannerAdWidget(adMobService: _TestAdMobService()),
      ),
    );
  }

  group('BannerAdWidget', () {
    testWidgets('exibe BannerAdPlaceholderWidget antes do anúncio carregar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(BannerAdPlaceholderWidget), findsOneWidget);
    });

    testWidgets('não exibe AdWidget enquanto anúncio não carrega', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(AdWidget), findsNothing);
    });

    testWidgets(
      'placeholder tem SizedBox com altura de adBannerPlaceholderHeight',
      (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
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
