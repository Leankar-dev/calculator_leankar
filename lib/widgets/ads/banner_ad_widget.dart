import 'package:calculator_05122025/services/ad_mob_service.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/widgets/ads/banner_ad_placeholder_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  final AdMobService adMobService;

  const BannerAdWidget({super.key, required this.adMobService});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _loadInitiated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadInitiated) {
      _loadInitiated = true;
      _loadBanner();
    }
  }

  Future<void> _loadBanner() async {
    final ad = widget.adMobService.createBannerAd(
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: _onAdFailedToLoad,
      ),
    );

    _bannerAd = ad;
    await ad.load();
  }

  void _onAdFailedToLoad(Ad ad, LoadAdError error) {
    ad.dispose();
    logger.warning(
      'Banner falhou ao carregar: ${error.message}',
      tag: 'BannerAdWidget',
    );
    if (mounted) {
      setState(() {
        _bannerAd = null;
        _isLoaded = false;
      });
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const BannerAdPlaceholderWidget(
        height: AppSizes.adBannerPlaceholderHeight,
      );
    }

    return Neumorphic(
      style: NeumorphicStyle(
        depth: -1,
        intensity: 0.4,
        color: NeumorphicTheme.baseColor(context),
        boxShape: const NeumorphicBoxShape.rect(),
      ),
      child: SizedBox(
        width: double.infinity,
        height: AppSizes.adBannerPlaceholderHeight,
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
