import 'package:calculator_05122025/services/level_play_ad_service.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LevelPlayAdService', () {
    group('initialize()', () {
      test(
        'retorna Result.failure com ErrorType.adInitError quando o canal de plataforma do SDK não está disponível no ambiente de teste',
        () async {
          final result = await LevelPlayAdService().initialize();

          expect(result.isFailure, isTrue);
          expect(result.error, equals(ErrorType.adInitError));
        },
      );
    });
  });
}
