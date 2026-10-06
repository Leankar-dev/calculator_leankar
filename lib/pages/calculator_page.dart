import 'dart:async';
import 'package:calculator_05122025/controllers/ad_consent_controller.dart';
import 'package:calculator_05122025/controllers/calculator_controller.dart';
import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/pages/imc_calculator_page.dart';
import 'package:calculator_05122025/pages/scientific_calculator_page.dart';
import 'package:calculator_05122025/pages/settings_page.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/ad_consent_load_status.dart';
import 'package:calculator_05122025/utils/enums/calculator_key_action.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/utils/keyboard/calculator_key_resolver.dart';
import 'package:calculator_05122025/utils/mixins/clipboard_feedback_mixin.dart';
import 'package:calculator_05122025/utils/responsive_utils.dart';
import 'package:calculator_05122025/widgets/ads/ad_banner_footer_widget.dart';
import 'package:calculator_05122025/widgets/ads/ad_consent_dialog_widget.dart';
import 'package:calculator_05122025/widgets/app_bar_title_widget.dart';
import 'package:calculator_05122025/widgets/app_drawer_widget.dart';
import 'package:calculator_05122025/widgets/calculator_footer_widget.dart';
import 'package:calculator_05122025/widgets/calculator_keypad_widget.dart';
import 'package:calculator_05122025/widgets/history_bottom_sheet.dart';
import 'package:calculator_05122025/widgets/landscape_layout_widget.dart';
import 'package:calculator_05122025/widgets/portrait_layout_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class CalculatorPage extends StatefulWidget {
  final CalculatorController? controller;

  const CalculatorPage({super.key, this.controller});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage>
    with ClipboardFeedbackMixin<CalculatorPage> {
  late final CalculatorController _controller;
  late final bool _ownsController;
  final FocusNode _focusNode = FocusNode();
  StreamSubscription<void>? _inputRejectedSubscription;
  bool _adConsentDialogShown = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? CalculatorController();
    _inputRejectedSubscription = _controller.inputRejected.listen((_) {
      HapticFeedback.heavyImpact();
    });
    _initializeController();
    AdConsentController.instance.addListener(_handleAdConsentStateChange);
    AdConsentController.instance.initialize();
  }

  void _handleAdConsentStateChange() {
    if (_adConsentDialogShown || !mounted) return;
    if (AdConsentController.instance.state.loadStatus !=
        AdConsentLoadStatus.pendingUserChoice) {
      return;
    }

    _adConsentDialogShown = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AdConsentDialogWidget(),
    );
  }

  Future<void> _initializeController() async {
    try {
      await _controller.loadHistory();
    } catch (e, stackTrace) {
      logger.error(
        'Erro ao inicializar controller',
        tag: 'CalculatorPage',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void dispose() {
    _inputRejectedSubscription?.cancel();
    AdConsentController.instance.removeListener(_handleAdConsentStateChange);
    if (_ownsController) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _navigateToImc() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ImcCalculatorPage(),
      ),
    );
  }

  void _navigateToScientific() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ScientificCalculatorPage(),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsPage(controller: SettingsController.instance),
      ),
    );
  }

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => HistoryBottomSheet(
        history: _controller.history,
        onItemTap: _controller.useHistoryResult,
        onClearHistory: _controller.clearHistory,
      ),
    );
  }

  String _resolveDisplayText(AppLocalizations l10n) {
    final errorType = _controller.state.errorType;
    if (errorType == null) return _controller.displayText;
    switch (errorType) {
      case ErrorType.divisionByZero:
        return l10n.errorDivisionByZero;
      case ErrorType.infinity:
        return l10n.errorInfinity;
      case ErrorType.notANumber:
        return l10n.errorNan;
      case ErrorType.overflow:
        return l10n.errorOverflow;
      default:
        return l10n.errorGeneric;
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    try {
      final action = CalculatorKeyResolver.resolve(event);
      if (action != null) {
        _runKeyAction(action, event.character);
        return;
      }
      _runBasicCalculatorKey(event.character);
    } catch (e, stackTrace) {
      logger.error(
        'Erro ao processar evento de teclado',
        tag: 'CalculatorPage',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _runKeyAction(CalculatorKeyAction action, String? character) {
    switch (action) {
      case CalculatorKeyAction.copy:
        copyWithFeedback(_controller.copyToClipboard);
      case CalculatorKeyAction.paste:
        pasteWithFeedback(_controller.pasteFromClipboard);
      case CalculatorKeyAction.calculate:
        _controller.calculateResult();
      case CalculatorKeyAction.backspace:
        _controller.backspace();
      case CalculatorKeyAction.clear:
        _controller.clearDisplay();
      case CalculatorKeyAction.digit:
        if (character != null) {
          _controller.appendNumber(character);
        }
      case CalculatorKeyAction.decimal:
        _controller.appendDecimal();
      case CalculatorKeyAction.add:
        _controller.setOperationType(OperationsType.addition);
      case CalculatorKeyAction.subtract:
        _controller.setOperationType(OperationsType.subtraction);
      case CalculatorKeyAction.multiply:
        _controller.setOperationType(OperationsType.multiplication);
      case CalculatorKeyAction.divide:
        _controller.setOperationType(OperationsType.division);
    }
  }

  void _runBasicCalculatorKey(String? character) {
    if (character == AppStrings.percentSymbol) {
      _controller.calculatePercentage();
      return;
    }

    if (character == AppStrings.clearButtonLower ||
        character == AppStrings.clearButtonText) {
      _controller.clearDisplay();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        leading: Center(
          child: Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(AppSizes.appBarLogoBorderRadius),
              ),
              depth: AppSizes.appBarLogoDepth,
              intensity: AppSizes.appBarLogoIntensity,
              lightSource: LightSource.topLeft,
              color: NeumorphicTheme.baseColor(context),
            ),
            padding: const EdgeInsets.all(AppSizes.appBarLogoPadding),
            child: Image.asset(
              AppStrings.logoAssetPath,
              height: AppSizes.appBarLogoHeight,
            ),
          ),
        ),
        title: AppBarTitleWidget(text: l10n.calculatorPageTitle),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => NeumorphicButton(
              style: const NeumorphicStyle(
                depth: AppSizes.appBarMenuButtonDepth,
                intensity: AppSizes.appBarMenuButtonIntensity,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              padding: const EdgeInsets.all(AppSizes.appBarMenuButtonPadding),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              child: const Icon(Icons.menu, color: AppColors.iconMuted),
            ),
          ),
        ],
      ),
      endDrawer: AppDrawerWidget(
        onHistoryTap: _showHistory,
        onImcTap: _navigateToImc,
        onScientificTap: _navigateToScientific,
        onSettingsTap: _navigateToSettings,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const CalculatorFooterWidget(),
            Expanded(
              child: KeyboardListener(
                focusNode: _focusNode,
                autofocus: true,
                onKeyEvent: _handleKeyEvent,
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    final isLandscape = ResponsiveUtils.isLandscape(context);
                    final maxWidth = ResponsiveUtils.getMaxCalculatorWidth();
                    final resolvedDisplayText = _resolveDisplayText(l10n);

                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isLandscape ? double.infinity : maxWidth,
                        ),
                        child: isLandscape
                            ? LandscapeLayoutWidget(
                                displayText: resolvedDisplayText,
                                expressionDisplay:
                                    _controller.expressionDisplay,
                                keypad: _CalculatorKeypadSection(
                                  controller: _controller,
                                ),
                              )
                            : PortraitLayoutWidget(
                                displayText: resolvedDisplayText,
                                expressionDisplay:
                                    _controller.expressionDisplay,
                                keypad: _CalculatorKeypadSection(
                                  controller: _controller,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const AdBannerFooterWidget(),
          ],
        ),
      ),
    );
  }
}

class _CalculatorKeypadSection extends StatelessWidget {
  final CalculatorController controller;

  const _CalculatorKeypadSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return CalculatorKeypadWidget(
      onClear: controller.clearDisplay,
      onBackspace: controller.backspace,
      onPercentage: controller.calculatePercentage,
      onDecimal: controller.appendDecimal,
      onCalculate: controller.calculateResult,
      onNumberPressed: controller.appendNumber,
      onOperationPressed: controller.setOperationType,
    );
  }
}
