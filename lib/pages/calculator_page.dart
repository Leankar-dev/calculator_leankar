import 'dart:async';

import 'package:calculator_05122025/controllers/ad_consent_controller.dart';
import 'package:calculator_05122025/controllers/calculator_controller.dart';
import 'package:calculator_05122025/controllers/settings_controller.dart';
import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/pages/imc_calculator_page.dart';
import 'package:calculator_05122025/pages/settings_page.dart';
import 'package:calculator_05122025/services/ad_mob_service.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/error_type.dart';
import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/utils/enums/paste_result.dart';
import 'package:calculator_05122025/utils/responsive_utils.dart';
import 'package:calculator_05122025/widgets/ads/ad_banner_footer_widget.dart';
import 'package:calculator_05122025/widgets/app_drawer_widget.dart';
import 'package:calculator_05122025/widgets/calculator_footer_widget.dart';
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

class _CalculatorPageState extends State<CalculatorPage> {
  late final CalculatorController _controller;
  late final bool _ownsController;
  final FocusNode _focusNode = FocusNode();
  StreamSubscription<void>? _inputRejectedSubscription;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? CalculatorController();
    _inputRejectedSubscription = _controller.inputRejected.listen((_) {
      HapticFeedback.heavyImpact();
    });
    _initializeController();
    AdConsentController.instance.initialize();
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
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
    try {
      if (event is! KeyDownEvent) return;

      final String? key = event.character;
      final LogicalKeyboardKey logicalKey = event.logicalKey;

      final isControlPressed =
          HardwareKeyboard.instance.isControlPressed ||
          HardwareKeyboard.instance.isMetaPressed;

      if (isControlPressed) {
        if (logicalKey == LogicalKeyboardKey.keyC) {
          _controller.copyToClipboard().then((success) {
            if (success && mounted) {
              _showSnackBar(AppLocalizations.of(context).snackbarValueCopied);
            }
          });
          return;
        }
        if (logicalKey == LogicalKeyboardKey.keyV) {
          _controller.pasteFromClipboard().then((result) {
            if (result == PasteResult.success || !mounted) return;
            final l10n = AppLocalizations.of(context);
            switch (result) {
              case PasteResult.emptyClipboard:
                _showSnackBar(l10n.snackbarEmptyClipboard);
                break;
              case PasteResult.invalidFormat:
                _showSnackBar(l10n.snackbarInvalidPaste);
                break;
              case PasteResult.outOfRange:
                _showSnackBar(l10n.snackbarOutOfRange);
                break;
              case PasteResult.success:
                break;
            }
          });
          return;
        }
      }

      if (logicalKey == LogicalKeyboardKey.enter ||
          logicalKey == LogicalKeyboardKey.numpadEnter) {
        _controller.calculateResult();
        return;
      }

      if (logicalKey == LogicalKeyboardKey.backspace) {
        _controller.backspace();
        return;
      }

      if (logicalKey == LogicalKeyboardKey.escape ||
          logicalKey == LogicalKeyboardKey.delete) {
        _controller.clearDisplay();
        return;
      }

      if (key != null && RegExp(r'^[0-9]$').hasMatch(key)) {
        _controller.appendNumber(key);
        return;
      }

      if (key == '+') {
        _controller.setOperationType(OperationsType.addition);
        return;
      }
      if (key == '-') {
        _controller.setOperationType(OperationsType.subtraction);
        return;
      }
      if (key == '*' || key == 'x' || key == 'X') {
        _controller.setOperationType(OperationsType.multiplication);
        return;
      }
      if (key == '/') {
        _controller.setOperationType(OperationsType.division);
        return;
      }

      if (key == ',' || key == '.') {
        _controller.appendDecimal();
        return;
      }

      if (key == '=') {
        _controller.calculateResult();
        return;
      }

      if (key == '%') {
        _controller.calculatePercentage();
        return;
      }

      if (key == 'c' || key == 'C') {
        _controller.clearDisplay();
        return;
      }
    } catch (e, stackTrace) {
      logger.error(
        'Erro ao processar evento de teclado',
        tag: 'CalculatorPage',
        error: e,
        stackTrace: stackTrace,
      );
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
        title: Text(
          l10n.calculatorPageTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
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
                                onClear: _controller.clearDisplay,
                                onBackspace: _controller.backspace,
                                onPercentage: _controller.calculatePercentage,
                                onDecimal: _controller.appendDecimal,
                                onCalculate: _controller.calculateResult,
                                onNumberPressed: _controller.appendNumber,
                                onOperationPressed:
                                    _controller.setOperationType,
                              )
                            : PortraitLayoutWidget(
                                displayText: resolvedDisplayText,
                                expressionDisplay:
                                    _controller.expressionDisplay,
                                onClear: _controller.clearDisplay,
                                onBackspace: _controller.backspace,
                                onPercentage: _controller.calculatePercentage,
                                onDecimal: _controller.appendDecimal,
                                onCalculate: _controller.calculateResult,
                                onNumberPressed: _controller.appendNumber,
                                onOperationPressed:
                                    _controller.setOperationType,
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
            AdBannerFooterWidget(adMobService: AdMobService.instance),
          ],
        ),
      ),
    );
  }
}
