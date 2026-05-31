import 'package:calculator_05122025/services/ad_mob_service.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/result.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MockAdMobService extends AdMobService {
  bool initializeCalled = false;
  Result<InitializationStatus>? initializeResult;

  @override
  Future<Result<InitializationStatus>> initialize() async {
    initializeCalled = true;
    return initializeResult ??
        Result.failure(ErrorType.adMobInitError, 'mock: sem SDK real');
  }

  @override
  BannerAd createBannerAd({
    required AdSize size,
    required BannerAdListener listener,
  }) {
    throw UnimplementedError(
      'createBannerAd não disponível em MockAdMobService',
    );
  }
}
