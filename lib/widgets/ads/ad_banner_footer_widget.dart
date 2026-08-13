import 'dart:io' show Platform;

import 'package:calculator_05122025/controllers/ad_consent_controller.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/enums/ad_consent_load_status.dart';
import 'package:calculator_05122025/widgets/ads/banner_ad_placeholder_widget.dart';
import 'package:calculator_05122025/widgets/ads/banner_ad_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class AdBannerFooterWidget extends StatelessWidget {
  const AdBannerFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isAndroid) {
      return const SizedBox.shrink();
    }

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

        return const BannerAdWidget();
      },
    );
  }
}
