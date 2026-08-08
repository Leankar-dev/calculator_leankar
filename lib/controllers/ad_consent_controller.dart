import 'package:calculator_05122025/controllers/ad_consent_state.dart';
import 'package:calculator_05122025/services/level_play_ad_service.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/ad_consent_load_status.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';

class AdConsentController extends ChangeNotifier {
  static final AdConsentController instance = AdConsentController();

  AdConsentController({
    LevelPlayAdService? levelPlayAdService,
    LoggerService? loggerService,
  }) : _levelPlayAdService = levelPlayAdService ?? LevelPlayAdService.instance,
       _logger = loggerService ?? LoggerService.instance;

  final LevelPlayAdService _levelPlayAdService;
  final LoggerService _logger;

  AdConsentState _state = const AdConsentState();

  AdConsentState get state => _state;

  void _update(AdConsentState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> initialize() async {
    _update(_state.copyWith(loadStatus: AdConsentLoadStatus.loading));

    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(AppStrings.prefAdConsentKey)) {
      _update(
        _state.copyWith(loadStatus: AdConsentLoadStatus.pendingUserChoice),
      );
      _logger.info(
        'Sem preferência salva: aguardando escolha do usuário',
        tag: 'AdConsentController',
      );
      return;
    }

    await _applyConsent(prefs.getBool(AppStrings.prefAdConsentKey) ?? false);
  }

  Future<void> submitUserChoice(bool accepted) async {
    await _persistConsentStatus(canRequestAds: accepted);
    await _applyConsent(accepted);
  }

  Future<void> _applyConsent(bool accepted) async {
    try {
      await LevelPlayPrivacySettings.setGDPRConsents({'UnityAds': accepted});
    } catch (e) {
      _logger.warning(
        'Falha ao aplicar LevelPlayPrivacySettings: $e',
        tag: 'AdConsentController',
      );
    }

    if (accepted) {
      final result = await _levelPlayAdService.initialize();
      if (result.isFailure) {
        _logger.warning(
          'Falha ao inicializar SDK após consentimento: ${result.errorFullMessage}',
          tag: 'AdConsentController',
        );
      }
    }

    _update(
      _state.copyWith(
        canRequestAds: accepted,
        loadStatus: AdConsentLoadStatus.ready,
      ),
    );

    _logger.info(
      'Consentimento finalizado: canRequestAds=$accepted',
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
