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

      test(
        'chamadas simultâneas compartilham a mesma inicialização em andamento',
        () async {
          final service = LevelPlayAdService();

          final first = service.initialize();
          final second = service.initialize();

          expect(identical(first, second), isTrue);
          await first;
        },
      );

      test(
        'após uma falha, uma nova chamada tenta inicializar novamente',
        () async {
          final service = LevelPlayAdService();

          final first = service.initialize();
          await first;
          final second = service.initialize();
          await second;

          expect(identical(first, second), isFalse);
        },
      );
    });
  });
}
