import 'package:calculator_05122025/controllers/ad_consent_controller.dart';
import 'package:calculator_05122025/services/ad_mob_service.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/enums/ad_consent_load_status.dart';
import 'package:calculator_05122025/widgets/ads/banner_ad_placeholder_widget.dart';
import 'package:calculator_05122025/widgets/ads/banner_ad_widget.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class AdBannerFooterWidget extends StatelessWidget {
  final AdMobService adMobService;

  const AdBannerFooterWidget({super.key, required this.adMobService});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AdConsentController.instance,
      builder: (context, child) {
        final state = AdConsentController.instance.state;

        if (state.loadStatus == AdConsentLoadStatus.loading) {
          return const BannerAdPlaceholderWidget(
            height: AppSizes.adBannerPlaceholderHeight,
          );
        }

        if (!state.canRequestAds) {
          return const SizedBox.shrink();
        }

        return BannerAdWidget(adMobService: adMobService);
      },
    );
  }
}
