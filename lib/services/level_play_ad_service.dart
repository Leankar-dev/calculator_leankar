import 'dart:async';

import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/env/app_env.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/result.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';

class LevelPlayAdService {
  static final LevelPlayAdService instance = LevelPlayAdService();

  LevelPlayAdService();

  Future<Result<LevelPlayConfiguration>> initialize() async {
    final completer = Completer<Result<LevelPlayConfiguration>>();

    try {
      await LevelPlay.init(
        initRequest: LevelPlayInitRequest.builder(
          AppEnv.unityAppKeyAndroid,
        ).build(),
        initListener: _LevelPlayAdServiceInitListener(completer),
      );
    } catch (e, stackTrace) {
      logger.error(
        'Falha na inicialização',
        tag: 'LevelPlayAdService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(ErrorType.adInitError, e.toString());
    }

    return completer.future;
  }
}

class _LevelPlayAdServiceInitListener implements LevelPlayInitListener {
  _LevelPlayAdServiceInitListener(this._completer);

  final Completer<Result<LevelPlayConfiguration>> _completer;

  @override
  void onInitSuccess(LevelPlayConfiguration configuration) {
    logger.info('SDK inicializado', tag: 'LevelPlayAdService');
    if (!_completer.isCompleted) {
      _completer.complete(Result.success(configuration));
    }
  }

  @override
  void onInitFailed(LevelPlayInitError error) {
    logger.error(
      'Falha na inicialização',
      tag: 'LevelPlayAdService',
      error: error.errorMessage,
    );
    if (!_completer.isCompleted) {
      _completer.complete(
        Result.failure(ErrorType.adInitError, error.errorMessage),
      );
    }
  }
}
