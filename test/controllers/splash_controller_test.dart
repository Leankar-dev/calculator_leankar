import 'package:calculator_05122025/controllers/splash_controller.dart';
import 'package:calculator_05122025/controllers/splash_state.dart';
import 'package:calculator_05122025/utils/enums/splash_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mock_logger_service.dart';

void main() {
  late MockLoggerService logger;
  late SplashController controller;
  late int notifications;

  setUp(() {
    logger = MockLoggerService();
    controller = SplashController(loggerService: logger);
    notifications = 0;
    controller.addListener(() => notifications++);
  });

  tearDown(() {
    controller.dispose();
  });

  group('estado inicial', () {
    test('começa ociosa, sem movimento reduzido e sem pulo solicitado', () {
      final state = controller.state;

      expect(state.status, SplashStatus.idle);
      expect(state.reduceMotion, isFalse);
      expect(state.skipRequested, isFalse);
      expect(state.isFinished, isFalse);
      expect(state.canSkip, isFalse);
    });
  });

  group('start', () {
    test('passa para running e guarda reduceMotion falso', () {
      controller.start(reduceMotion: false);

      expect(controller.state.status, SplashStatus.running);
      expect(controller.state.reduceMotion, isFalse);
      expect(controller.state.canSkip, isTrue);
    });

    test('passa para running e guarda reduceMotion verdadeiro', () {
      controller.start(reduceMotion: true);

      expect(controller.state.status, SplashStatus.running);
      expect(controller.state.reduceMotion, isTrue);
    });

    test('chamada repetida é ignorada e registrada', () {
      controller.start(reduceMotion: true);
      controller.start(reduceMotion: false);

      expect(controller.state.reduceMotion, isTrue);
      expect(logger.warningMessages, hasLength(1));
      expect(logger.warningMessages.single, contains('start'));
      expect(notifications, 1);
    });
  });

  group('requestSkip', () {
    test('marca o pulo solicitado quando está em running', () {
      controller.start(reduceMotion: false);

      controller.requestSkip();

      expect(controller.state.status, SplashStatus.running);
      expect(controller.state.skipRequested, isTrue);
      expect(controller.state.canSkip, isFalse);
    });

    test('segunda chamada é ignorada e registrada', () {
      controller.start(reduceMotion: false);
      controller.requestSkip();
      notifications = 0;

      controller.requestSkip();

      expect(notifications, 0);
      expect(logger.warningMessages, hasLength(1));
      expect(logger.warningMessages.single, contains('requestSkip'));
    });

    test('é ignorada em idle', () {
      controller.requestSkip();

      expect(controller.state.skipRequested, isFalse);
      expect(logger.warningMessages, hasLength(1));
    });

    test('é ignorada em exiting', () {
      controller.start(reduceMotion: false);
      controller.beginExit();

      controller.requestSkip();

      expect(controller.state.skipRequested, isFalse);
      expect(logger.warningMessages, hasLength(1));
    });

    test('é ignorada em finished', () {
      controller.start(reduceMotion: false);
      controller.finish();

      controller.requestSkip();

      expect(controller.state.skipRequested, isFalse);
      expect(logger.warningMessages, hasLength(1));
    });
  });

  group('beginExit', () {
    test('passa de running para exiting', () {
      controller.start(reduceMotion: false);

      controller.beginExit();

      expect(controller.state.status, SplashStatus.exiting);
    });

    test('é ignorada em idle', () {
      controller.beginExit();

      expect(controller.state.status, SplashStatus.idle);
      expect(logger.warningMessages, hasLength(1));
      expect(logger.warningMessages.single, contains('beginExit'));
    });

    test('é ignorada em exiting e em finished', () {
      controller.start(reduceMotion: false);
      controller.beginExit();
      controller.beginExit();
      expect(controller.state.status, SplashStatus.exiting);

      controller.finish();
      controller.beginExit();

      expect(controller.state.status, SplashStatus.finished);
      expect(logger.warningMessages, hasLength(2));
    });
  });

  group('finish', () {
    test('conclui a partir de running', () {
      controller.start(reduceMotion: false);

      controller.finish();

      expect(controller.state.status, SplashStatus.finished);
      expect(controller.state.isFinished, isTrue);
    });

    test('conclui a partir de exiting', () {
      controller.start(reduceMotion: false);
      controller.beginExit();

      controller.finish();

      expect(controller.state.status, SplashStatus.finished);
    });

    test('é ignorada em idle', () {
      controller.finish();

      expect(controller.state.status, SplashStatus.idle);
      expect(logger.warningMessages, hasLength(1));
      expect(logger.warningMessages.single, contains('finish'));
    });

    test('é ignorada em finished', () {
      controller.start(reduceMotion: false);
      controller.finish();
      notifications = 0;

      controller.finish();

      expect(controller.state.status, SplashStatus.finished);
      expect(notifications, 0);
      expect(logger.warningMessages, hasLength(1));
    });
  });

  group('notificações', () {
    test('cada transição válida notifica exatamente uma vez', () {
      controller.start(reduceMotion: false);
      expect(notifications, 1);

      controller.requestSkip();
      expect(notifications, 2);

      controller.beginExit();
      expect(notifications, 3);

      controller.finish();
      expect(notifications, 4);
    });

    test('transições inválidas não notificam', () {
      controller.beginExit();
      controller.finish();
      controller.requestSkip();

      expect(notifications, 0);
      expect(logger.warningMessages, hasLength(3));
    });
  });

  group('SplashState.copyWith', () {
    test('preserva os campos não informados', () {
      const original = SplashState(
        status: SplashStatus.running,
        reduceMotion: true,
        skipRequested: true,
      );

      final copy = original.copyWith();

      expect(copy.status, SplashStatus.running);
      expect(copy.reduceMotion, isTrue);
      expect(copy.skipRequested, isTrue);
    });

    test('substitui apenas os campos informados', () {
      const original = SplashState(reduceMotion: true);

      final copy = original.copyWith(status: SplashStatus.exiting);

      expect(copy.status, SplashStatus.exiting);
      expect(copy.reduceMotion, isTrue);
      expect(copy.skipRequested, isFalse);
    });
  });
}
