import 'dart:async';

import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/env/app_env.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/result.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';

const String _levelPlayAdServiceLogTag = 'LevelPlayAdService';

class LevelPlayAdService {
  static final LevelPlayAdService instance = LevelPlayAdService();

  static const Duration _initializationTimeout = Duration(seconds: 15);

  LevelPlayAdService();

  Future<Result<LevelPlayConfiguration>>? _initialization;

  Future<Result<LevelPlayConfiguration>> initialize() {
    final pendingInitialization = _initialization;
    if (pendingInitialization != null) {
      return pendingInitialization;
    }

    final initialization = _initializeSdk().then((result) {
      if (result.isFailure) {
        _initialization = null;
      }
      return result;
    });
    _initialization = initialization;
    return initialization;
  }

  Future<Result<LevelPlayConfiguration>> _initializeSdk() async {
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
        tag: _levelPlayAdServiceLogTag,
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(ErrorType.adInitError, e.toString());
    }

    return completer.future.timeout(
      _initializationTimeout,
      onTimeout: () {
        logger.warning(
          'Tempo esgotado aguardando a inicialização do SDK',
          tag: _levelPlayAdServiceLogTag,
        );
        return Result.failure(
          ErrorType.adInitError,
          'Tempo esgotado aguardando a inicialização',
        );
      },
    );
  }
}

class _LevelPlayAdServiceInitListener implements LevelPlayInitListener {
  _LevelPlayAdServiceInitListener(this._completer);

  final Completer<Result<LevelPlayConfiguration>> _completer;

  @override
  void onInitSuccess(LevelPlayConfiguration configuration) {
    logger.info('SDK inicializado', tag: _levelPlayAdServiceLogTag);
    if (!_completer.isCompleted) {
      _completer.complete(Result.success(configuration));
    }
  }

  @override
  void onInitFailed(LevelPlayInitError error) {
    logger.error(
      'Falha na inicialização',
      tag: _levelPlayAdServiceLogTag,
      error: error.errorMessage,
    );
    if (!_completer.isCompleted) {
      _completer.complete(
        Result.failure(ErrorType.adInitError, error.errorMessage),
      );
    }
  }
}
