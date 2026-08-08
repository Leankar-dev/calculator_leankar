import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/constants/app_ad_unit_ids.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/widgets/ads/banner_ad_placeholder_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget>
    implements LevelPlayBannerAdViewListener {
  final GlobalKey<LevelPlayBannerAdViewState> _bannerKey =
      GlobalKey<LevelPlayBannerAdViewState>();

  LevelPlayAdSize? _adSize;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _resolveAdSize();
  }

  Future<void> _resolveAdSize() async {
    try {
      final adSize = await LevelPlayAdSize.createAdaptiveAdSize();
      if (mounted && adSize != null) {
        setState(() {
          _adSize = adSize;
        });
      }
    } catch (e) {
      logger.warning(
        'Falha ao resolver tamanho do banner: $e',
        tag: 'BannerAdWidget',
      );
    }
  }

  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    if (mounted) {
      setState(() {
        _isLoaded = true;
      });
    }
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    logger.warning(
      'Banner falhou ao carregar: ${error.errorMessage}',
      tag: 'BannerAdWidget',
    );
    if (mounted) {
      setState(() {
        _isLoaded = false;
      });
    }
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {}

  @override
  void onAdDisplayFailed(LevelPlayAdInfo adInfo, LevelPlayAdError error) {
    logger.warning(
      'Banner falhou ao exibir: ${error.errorMessage}',
      tag: 'BannerAdWidget',
    );
  }

  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {}

  @override
  void onAdExpanded(LevelPlayAdInfo adInfo) {}

  @override
  void onAdCollapsed(LevelPlayAdInfo adInfo) {}

  @override
  void onAdLeftApplication(LevelPlayAdInfo adInfo) {}

  @override
  void dispose() {
    _bannerKey.currentState?.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adSize = _adSize;

    if (adSize == null) {
      return const BannerAdPlaceholderWidget(
        height: AppSizes.adBannerPlaceholderHeight,
      );
    }

    return SizedBox(
      width: double.infinity,
      height: AppSizes.adBannerPlaceholderHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!_isLoaded)
            const BannerAdPlaceholderWidget(
              height: AppSizes.adBannerPlaceholderHeight,
            ),
          Visibility(
            visible: _isLoaded,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            child: LevelPlayBannerAdView(
              key: _bannerKey,
              adUnitId: AppAdUnitIds.bannerAdUnitId,
              adSize: adSize,
              listener: this,
              onPlatformViewCreated: () => _bannerKey.currentState?.loadAd(),
            ),
          ),
        ],
      ),
    );
  }
}
