import 'package:calculator_05122025/services/ad_mob_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdMobService', () {
    group('createBannerAd()', () {
      test('retorna instância de BannerAd', () {
        final ad = AdMobService().createBannerAd(
          size: AdSize.banner,
          listener: BannerAdListener(),
        );
        expect(ad, isA<BannerAd>());
      });

      test('usa o tamanho passado como parâmetro', () {
        final ad = AdMobService().createBannerAd(
          size: AdSize.banner,
          listener: BannerAdListener(),
        );
        expect(ad.size, equals(AdSize.banner));
      });

      test('aceita AdSize leaderboard', () {
        final ad = AdMobService().createBannerAd(
          size: AdSize.leaderboard,
          listener: BannerAdListener(),
        );
        expect(ad.size, equals(AdSize.leaderboard));
      });

      test('usa adUnitId não vazio', () {
        final ad = AdMobService().createBannerAd(
          size: AdSize.banner,
          listener: BannerAdListener(),
        );
        expect(ad.adUnitId, isNotEmpty);
      });

      test('associa o listener fornecido', () {
        final listener = BannerAdListener();
        final ad = AdMobService().createBannerAd(
          size: AdSize.banner,
          listener: listener,
        );
        expect(ad.listener, equals(listener));
      });
    });
  });
}
