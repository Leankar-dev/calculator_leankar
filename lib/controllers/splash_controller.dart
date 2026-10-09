import 'package:calculator_05122025/controllers/splash_state.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/enums/splash_status.dart';
import 'package:flutter/foundation.dart';

class SplashController extends ChangeNotifier {
  SplashController({LoggerService? loggerService})
    : _logger = loggerService ?? LoggerService.instance;

  final LoggerService _logger;

  SplashState _state = const SplashState();

  SplashState get state => _state;

  void start({required bool reduceMotion}) {
    if (_state.status != SplashStatus.idle) {
      _logIgnored('start');
      return;
    }
    _update(
      _state.copyWith(status: SplashStatus.running, reduceMotion: reduceMotion),
    );
  }

  void requestSkip() {
    if (!_state.canSkip) {
      _logIgnored('requestSkip');
      return;
    }
    _update(_state.copyWith(skipRequested: true));
  }

  void beginExit() {
    if (_state.status != SplashStatus.running) {
      _logIgnored('beginExit');
      return;
    }
    _update(_state.copyWith(status: SplashStatus.exiting));
  }

  void finish() {
    final canFinish =
        _state.status == SplashStatus.running ||
        _state.status == SplashStatus.exiting;
    if (!canFinish) {
      _logIgnored('finish');
      return;
    }
    _update(_state.copyWith(status: SplashStatus.finished));
  }

  void _update(SplashState newState) {
    _state = newState;
    notifyListeners();
  }

  void _logIgnored(String action) {
    _logger.warning(
      'Transição ignorada: $action em ${_state.status.name}',
      tag: 'SplashController',
    );
  }
}
