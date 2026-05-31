import 'package:calculator_05122025/controllers/ad_consent_controller.dart';
import 'package:calculator_05122025/controllers/ad_consent_state.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/ad_consent_load_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/mock_ad_mob_service.dart';
import '../mocks/mock_logger_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAdMobService mockAdMobService;
  late MockLoggerService mockLogger;

  AdConsentController buildController() {
    return AdConsentController(
      adMobService: mockAdMobService,
      loggerService: mockLogger,
    );
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockAdMobService = MockAdMobService();
    mockLogger = MockLoggerService();
  });

  group('AdConsentController', () {
    group('Estado inicial', () {
      test('loadStatus deve ser initial', () {
        final controller = buildController();
        expect(
          controller.state.loadStatus,
          equals(AdConsentLoadStatus.initial),
        );
      });

      test('canRequestAds deve ser false', () {
        final controller = buildController();
        expect(controller.state.canRequestAds, isFalse);
      });

      test('errorMessage deve ser null', () {
        final controller = buildController();
        expect(controller.state.errorMessage, isNull);
      });
    });

    group('initialize() em debug mode', () {
      test('define loadStatus como ready', () async {
        final controller = buildController();
        await controller.initialize();
        expect(
          controller.state.loadStatus,
          equals(AdConsentLoadStatus.ready),
        );
      });

      test('define canRequestAds como true', () async {
        final controller = buildController();
        await controller.initialize();
        expect(controller.state.canRequestAds, isTrue);
      });

      test('chama adMobService.initialize()', () async {
        final controller = buildController();
        await controller.initialize();
        expect(mockAdMobService.initializeCalled, isTrue);
      });

      test('notifica listeners ao menos uma vez', () async {
        final controller = buildController();
        int notifyCount = 0;
        controller.addListener(() => notifyCount++);
        await controller.initialize();
        expect(notifyCount, greaterThanOrEqualTo(1));
      });

      test('passa por loadStatus.loading antes de ready', () async {
        final controller = buildController();
        final statuses = <AdConsentLoadStatus>[];
        controller.addListener(() => statuses.add(controller.state.loadStatus));
        await controller.initialize();
        expect(statuses, contains(AdConsentLoadStatus.loading));
        expect(statuses, contains(AdConsentLoadStatus.ready));
      });

      test('estado final não contém errorMessage', () async {
        final controller = buildController();
        await controller.initialize();
        expect(controller.state.errorMessage, isNull);
      });
    });

    group('loadPersistedConsent()', () {
      test('define canRequestAds como true quando persistido é true', () async {
        SharedPreferences.setMockInitialValues({
          AppStrings.prefAdConsentKey: true,
        });
        final controller = buildController();
        await controller.loadPersistedConsent();
        expect(controller.state.canRequestAds, isTrue);
      });

      test(
        'define canRequestAds como false quando persistido é false',
        () async {
          SharedPreferences.setMockInitialValues({
            AppStrings.prefAdConsentKey: false,
          });
          final controller = buildController();
          await controller.loadPersistedConsent();
          expect(controller.state.canRequestAds, isFalse);
        },
      );

      test('mantém canRequestAds false quando chave ausente', () async {
        SharedPreferences.setMockInitialValues({});
        final controller = buildController();
        await controller.loadPersistedConsent();
        expect(controller.state.canRequestAds, isFalse);
      });

      test('notifica listeners', () async {
        final controller = buildController();
        int notifyCount = 0;
        controller.addListener(() => notifyCount++);
        await controller.loadPersistedConsent();
        expect(notifyCount, 1);
      });

      test('não altera loadStatus', () async {
        final controller = buildController();
        await controller.loadPersistedConsent();
        expect(
          controller.state.loadStatus,
          equals(AdConsentLoadStatus.initial),
        );
      });
    });

    group('AdConsentState.copyWith()', () {
      test('altera canRequestAds mantendo outros campos', () {
        const state = AdConsentState(
          canRequestAds: false,
          loadStatus: AdConsentLoadStatus.ready,
        );
        final updated = state.copyWith(canRequestAds: true);
        expect(updated.canRequestAds, isTrue);
        expect(updated.loadStatus, equals(AdConsentLoadStatus.ready));
        expect(updated.errorMessage, isNull);
      });

      test('altera loadStatus mantendo canRequestAds', () {
        const state = AdConsentState(canRequestAds: true);
        final updated = state.copyWith(
          loadStatus: AdConsentLoadStatus.failed,
        );
        expect(updated.loadStatus, equals(AdConsentLoadStatus.failed));
        expect(updated.canRequestAds, isTrue);
      });

      test('altera errorMessage', () {
        const state = AdConsentState();
        final updated = state.copyWith(errorMessage: 'erro de teste');
        expect(updated.errorMessage, equals('erro de teste'));
      });

      test('sem argumentos retorna estado equivalente', () {
        const state = AdConsentState(
          canRequestAds: true,
          loadStatus: AdConsentLoadStatus.loading,
          errorMessage: 'msg',
        );
        final updated = state.copyWith();
        expect(updated.canRequestAds, equals(state.canRequestAds));
        expect(updated.loadStatus, equals(state.loadStatus));
        expect(updated.errorMessage, equals(state.errorMessage));
      });
    });
  });
}
