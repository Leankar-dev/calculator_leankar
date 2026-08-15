import 'package:calculator_05122025/controllers/scientific_calculator_controller.dart';
import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_scientific_strings.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/paste_result.dart';
import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:calculator_05122025/utils/responsive_utils.dart';
import 'package:calculator_05122025/widgets/history_bottom_sheet.dart';
import 'package:calculator_05122025/widgets/landscape_layout_widget.dart';
import 'package:calculator_05122025/widgets/portrait_layout_widget.dart';
import 'package:calculator_05122025/widgets/scientific/scientific_display_indicators_widget.dart';
import 'package:calculator_05122025/widgets/scientific/scientific_keypad_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ScientificCalculatorPage extends StatefulWidget {
  final ScientificCalculatorController? controller;

  const ScientificCalculatorPage({super.key, this.controller});

  @override
  State<ScientificCalculatorPage> createState() =>
      _ScientificCalculatorPageState();
}

class _ScientificCalculatorPageState extends State<ScientificCalculatorPage> {
  late final ScientificCalculatorController _controller;
  late final bool _ownsController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? ScientificCalculatorController();
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      await _controller.loadHistory();
    } catch (e, stackTrace) {
      logger.error(
        'Erro ao inicializar controller',
        tag: 'ScientificCalculatorPage',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  String _resolveDisplayText(AppLocalizations l10n) {
    final errorType = _controller.state.errorType;
    if (errorType == null) return _controller.resultDisplay;
    switch (errorType) {
      case ScientificErrorType.syntaxError:
      case ScientificErrorType.emptyExpression:
        return l10n.scientificErrorSyntax;
      case ScientificErrorType.unbalancedParens:
        return l10n.scientificErrorParens;
      case ScientificErrorType.domainError:
        return l10n.scientificErrorDomain;
      case ScientificErrorType.factorialDomainError:
        return l10n.scientificErrorFactorialDomain;
      case ScientificErrorType.factorialOverflow:
        return l10n.scientificErrorFactorialOverflow;
      case ScientificErrorType.divisionByZero:
        return l10n.scientificErrorDivisionByZero;
      case ScientificErrorType.overflow:
        return l10n.scientificErrorOverflow;
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    try {
      if (event is! KeyDownEvent) return;

      final String? key = event.character;
      final String? lowerKey = key?.toLowerCase();
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
        _controller.clearAll();
        return;
      }

      if (key != null && RegExp(r'^[0-9]$').hasMatch(key)) {
        _controller.appendNumber(key);
        return;
      }

      if (key == AppStrings.additionSymbol) {
        _controller.setBinaryOperator(AppStrings.additionSymbol);
        return;
      }
      if (key == AppStrings.subtractionSymbol) {
        _controller.setBinaryOperator(AppStrings.subtractionSymbol);
        return;
      }
      if (key == AppStrings.keyboardAsterisk ||
          key == AppStrings.keyboardXLower ||
          key == AppStrings.keyboardXUpper) {
        _controller.setBinaryOperator(AppStrings.multiplicationSymbol);
        return;
      }
      if (key == AppStrings.keyboardSlash) {
        _controller.setBinaryOperator(AppStrings.divisionSymbol);
        return;
      }

      if (key == AppStrings.decimalSeparator || key == AppStrings.keyboardDot) {
        _controller.appendDecimal();
        return;
      }

      if (key == AppStrings.equalsButtonText) {
        _controller.calculateResult();
        return;
      }

      if (lowerKey == 's') {
        _controller.appendFunction(ScientificFunctionType.sin);
        return;
      }
      if (lowerKey == 'c') {
        _controller.appendFunction(ScientificFunctionType.cos);
        return;
      }
      if (lowerKey == 't') {
        _controller.appendFunction(ScientificFunctionType.tan);
        return;
      }
      if (lowerKey == 'l') {
        _controller.appendFunction(ScientificFunctionType.log);
        return;
      }
      if (lowerKey == 'n') {
        _controller.appendFunction(ScientificFunctionType.ln);
        return;
      }
      if (lowerKey == 'p') {
        _controller.appendConstant(AppScientificStrings.pi);
        return;
      }
      if (key == '(') {
        _controller.openParen();
        return;
      }
      if (key == ')') {
        _controller.closeParen();
        return;
      }
      if (key == '!') {
        _controller.appendFunction(ScientificFunctionType.factorial);
        return;
      }
      if (key == '^') {
        _controller.setBinaryOperator('^');
        return;
      }
    } catch (e, stackTrace) {
      logger.error(
        'Erro ao processar evento de teclado',
        tag: 'ScientificCalculatorPage',
        error: e,
        stackTrace: stackTrace,
      );
    }
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

  Widget _buildKeypad() {
    return ScientificKeypadWidget(
      angleMode: _controller.angleMode,
      isShiftActive: _controller.isShiftActive,
      hasMemoryValue: _controller.state.hasMemoryValue,
      onToggleAngleMode: _controller.toggleAngleMode,
      onToggleShift: _controller.toggleShift,
      onLockShift: _controller.lockShift,
      onPi: () => _controller.appendConstant(AppScientificStrings.pi),
      onEuler: () => _controller.appendConstant(AppScientificStrings.euler),
      onFunction: _controller.appendFunction,
      onBinaryOperator: _controller.setBinaryOperator,
      onOpenParen: _controller.openParen,
      onCloseParen: _controller.closeParen,
      onMemoryAdd: _controller.memoryAdd,
      onMemorySubtract: _controller.memorySubtract,
      onMemoryRecall: _controller.memoryRecall,
      onMemoryClear: _controller.memoryClear,
      onClear: _controller.clearAll,
      onBackspace: _controller.backspace,
      onPercentage: _controller.calculatePercentage,
      onDecimal: _controller.appendDecimal,
      onCalculate: _controller.calculateResult,
      onNumberPressed: _controller.appendNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        leading: NeumorphicButton(
          onPressed: () => Navigator.of(context).pop(),
          style: const NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            depth: AppSizes.appBarMenuButtonDepth,
            intensity: AppSizes.appBarMenuButtonIntensity,
          ),
          padding: const EdgeInsets.all(AppSizes.appBarMenuButtonPadding),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primaryText,
          ),
        ),
        title: Text(
          l10n.scientificPageTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        centerTitle: true,
        actions: [
          NeumorphicButton(
            onPressed: _showHistory,
            style: const NeumorphicStyle(
              boxShape: NeumorphicBoxShape.circle(),
              depth: AppSizes.appBarMenuButtonDepth,
              intensity: AppSizes.appBarMenuButtonIntensity,
            ),
            padding: const EdgeInsets.all(AppSizes.appBarMenuButtonPadding),
            child: const Icon(Icons.history, color: AppColors.iconMuted),
          ),
        ],
      ),
      body: SafeArea(
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
                  child: Column(
                    children: [
                      ScientificDisplayIndicatorsWidget(
                        angleMode: _controller.angleMode,
                        hasMemoryValue: _controller.state.hasMemoryValue,
                      ),
                      Expanded(
                        child: isLandscape
                            ? LandscapeLayoutWidget(
                                displayText: resolvedDisplayText,
                                expressionDisplay:
                                    _controller.expressionDisplay,
                                keypad: _buildKeypad(),
                              )
                            : PortraitLayoutWidget(
                                displayText: resolvedDisplayText,
                                expressionDisplay:
                                    _controller.expressionDisplay,
                                keypad: _buildKeypad(),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
