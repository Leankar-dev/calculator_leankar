import 'package:calculator_05122025/utils/enums/splash_status.dart';

class SplashState {
  final SplashStatus status;
  final bool reduceMotion;
  final bool skipRequested;

  const SplashState({
    this.status = SplashStatus.idle,
    this.reduceMotion = false,
    this.skipRequested = false,
  });

  bool get isFinished => status == SplashStatus.finished;
  bool get canSkip => status == SplashStatus.running && !skipRequested;

  SplashState copyWith({
    SplashStatus? status,
    bool? reduceMotion,
    bool? skipRequested,
  }) {
    return SplashState(
      status: status ?? this.status,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      skipRequested: skipRequested ?? this.skipRequested,
    );
  }
}
