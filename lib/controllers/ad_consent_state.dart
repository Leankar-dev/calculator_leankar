import 'package:calculator_05122025/utils/enums/ad_consent_load_status.dart';

final class AdConsentState {
  final bool canRequestAds;
  final AdConsentLoadStatus loadStatus;
  final String? errorMessage;

  const AdConsentState({
    this.canRequestAds = false,
    this.loadStatus = AdConsentLoadStatus.initial,
    this.errorMessage,
  });

  AdConsentState copyWith({
    bool? canRequestAds,
    AdConsentLoadStatus? loadStatus,
    String? errorMessage,
  }) {
    return AdConsentState(
      canRequestAds: canRequestAds ?? this.canRequestAds,
      loadStatus: loadStatus ?? this.loadStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
