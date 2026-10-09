import 'dart:ui';

import 'package:calculator_05122025/app/app_calculator.dart';
import 'package:calculator_05122025/controllers/ad_consent_controller.dart';
import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

Future<void> bootstrap() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  _registerGlobalErrorHandlers();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await _loadPersistedState();

  runApp(const AppCalculator());

  FlutterNativeSplash.remove();
}

void _registerGlobalErrorHandlers() {
  FlutterError.onError = (details) {
    logger.error(
      'Erro do framework',
      tag: 'Bootstrap',
      error: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    logger.error(
      'Erro não tratado',
      tag: 'Bootstrap',
      error: error,
      stackTrace: stackTrace,
    );
    return true;
  };
}

Future<void> _loadPersistedState() async {
  try {
    await SettingsController.instance.loadSettings(
      deviceLocale: PlatformDispatcher.instance.locale,
    );
  } catch (e, stackTrace) {
    logger.error(
      'Falha ao carregar configurações, usando padrões',
      tag: 'Bootstrap',
      error: e,
      stackTrace: stackTrace,
    );
  }

  try {
    await AdConsentController.instance.loadPersistedConsent();
  } catch (e, stackTrace) {
    logger.error(
      'Falha ao carregar consentimento, anúncios desativados',
      tag: 'Bootstrap',
      error: e,
      stackTrace: stackTrace,
    );
  }
}
