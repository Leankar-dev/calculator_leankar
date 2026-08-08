import 'package:calculator_05122025/services/level_play_ad_service.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/result.dart';
import 'package:unity_levelplay_mediation/unity_levelplay_mediation.dart';

class MockLevelPlayAdService extends LevelPlayAdService {
  bool initializeCalled = false;
  Result<LevelPlayConfiguration>? initializeResult;

  @override
  Future<Result<LevelPlayConfiguration>> initialize() async {
    initializeCalled = true;
    return initializeResult ??
        Result.failure(ErrorType.adInitError, 'mock: sem SDK real');
  }
}
