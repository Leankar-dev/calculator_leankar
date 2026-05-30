import 'package:calculator_05122025/controllers/ad_consent_state.dart';
import 'package:calculator_05122025/services/ad_mob_service.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/ad_consent_load_status.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdConsentController extends ChangeNotifier {
  static final AdConsentController instance = AdConsentController();

  AdConsentController({
    AdMobService? adMobService,
    LoggerService? loggerService,
  }) : _adMobService = adMobService ?? AdMobService.instance,
       _logger = loggerService ?? LoggerService.instance;

  final AdMobService _adMobService;
  final LoggerService _logger;

  AdConsentState _state = const AdConsentState();

  AdConsentState get state => _state;

  void _update(AdConsentState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> initialize() async {
    if (kDebugMode) {
      await _initializeForDebug();
      return;
    }

    _update(_state.copyWith(loadStatus: AdConsentLoadStatus.loading));

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        try {
          await _handleConsentInfoUpdated();
        } catch (e) {
          _logger.warning(
            'Erro ao processar fluxo UMP: $e',
            tag: 'AdConsentController',
          );
          await _finalizeConsent();
        }
      },
      (FormError error) {
        _logger.warning(
          'Falha ao atualizar consentimento: ${error.message}',
          tag: 'AdConsentController',
        );
        _finalizeConsent().catchError((e) {
          _update(
            _state.copyWith(
              loadStatus: AdConsentLoadStatus.failed,
              errorMessage: error.message,
            ),
          );
        });
      },
    );
  }

  Future<void> _initializeForDebug() async {
    _update(_state.copyWith(loadStatus: AdConsentLoadStatus.loading));
    await _adMobService.initialize();
    _update(
      _state.copyWith(
        canRequestAds: true,
        loadStatus: AdConsentLoadStatus.ready,
      ),
    );
    _logger.info(
      'Debug mode: MobileAds inicializado sem fluxo UMP',
      tag: 'AdConsentController',
    );
  }

  Future<void> _handleConsentInfoUpdated() async {
    await ConsentForm.loadAndShowConsentFormIfRequired((FormError? formError) {
      if (formError != null) {
        _logger.warning(
          'Erro no formulário UMP: ${formError.message}',
          tag: 'AdConsentController',
        );
      }
    });
    await _finalizeConsent();
  }

  Future<void> _finalizeConsent() async {
    final canRequest = await ConsentInformation.instance.canRequestAds();

    if (canRequest) {
      await _adMobService.initialize();
    }

    await _persistConsentStatus(canRequestAds: canRequest);

    _update(
      _state.copyWith(
        canRequestAds: canRequest,
        loadStatus: AdConsentLoadStatus.ready,
      ),
    );

    _logger.info(
      'Consentimento finalizado: canRequestAds=$canRequest',
      tag: 'AdConsentController',
    );
  }

  Future<void> loadPersistedConsent() async {
    final prefs = await SharedPreferences.getInstance();
    final persisted = prefs.getBool(AppStrings.prefAdConsentKey) ?? false;
    _update(_state.copyWith(canRequestAds: persisted));
  }

  Future<void> _persistConsentStatus({required bool canRequestAds}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppStrings.prefAdConsentKey, canRequestAds);
  }
}
