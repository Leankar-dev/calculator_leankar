import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/constants/app_ad_ids.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/result.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final AdMobService instance = AdMobService();

  AdMobService();

  Future<Result<InitializationStatus>> initialize() async {
    try {
      final status = await MobileAds.instance.initialize();
      logger.info('SDK inicializado', tag: 'AdMobService');
      return Result.success(status);
    } catch (e, stackTrace) {
      logger.error(
        'Falha na inicialização',
        tag: 'AdMobService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(ErrorType.adMobInitError, e.toString());
    }
  }

  BannerAd createBannerAd({
    required AdSize size,
    required BannerAdListener listener,
  }) {
    return BannerAd(
      adUnitId: AppAdIds.bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: listener,
    );
  }
}
