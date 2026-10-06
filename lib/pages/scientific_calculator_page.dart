import 'package:calculator_05122025/controllers/scientific_calculator_controller.dart';
import 'package:calculator_05122025/l10n/app_localizations.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/constants/app_colors.dart';
import 'package:calculator_05122025/utils/constants/app_scientific_strings.dart';
import 'package:calculator_05122025/utils/constants/app_sizes.dart';
import 'package:calculator_05122025/utils/constants/app_strings.dart';
import 'package:calculator_05122025/utils/enums/calculator_key_action.dart';
import 'package:calculator_05122025/utils/enums/scientific_error_type.dart';
import 'package:calculator_05122025/utils/enums/scientific_function_type.dart';
import 'package:calculator_05122025/utils/keyboard/calculator_key_resolver.dart';
import 'package:calculator_05122025/utils/mixins/clipboard_feedback_mixin.dart';
import 'package:calculator_05122025/utils/responsive_utils.dart';
import 'package:calculator_05122025/widgets/app_bar_title_widget.dart';
import 'package:calculator_05122025/widgets/history_bottom_sheet.dart';
import 'package:calculator_05122025/widgets/landscape_layout_widget.dart';
import 'package:calculator_05122025/widgets/portrait_layout_widget.dart';
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

class _ScientificCalculatorPageState extends State<ScientificCalculatorPage>
    with ClipboardFeedbackMixin<ScientificCalculatorPage> {
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
    if (event is! KeyDownEvent) return;

    try {
      final action = CalculatorKeyResolver.resolve(event);
      if (action != null) {
        _runKeyAction(action, event.character);
        return;
      }
      _runScientificKey(event.character);
    } catch (e, stackTrace) {
      logger.error(
        'Erro ao processar evento de teclado',
        tag: 'ScientificCalculatorPage',
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
        _controller.clearAll();
      case CalculatorKeyAction.digit:
        if (character != null) {
          _controller.appendNumber(character);
        }
      case CalculatorKeyAction.decimal:
        _controller.appendDecimal();
      case CalculatorKeyAction.add:
        _controller.setBinaryOperator(AppStrings.additionSymbol);
      case CalculatorKeyAction.subtract:
        _controller.setBinaryOperator(AppStrings.subtractionSymbol);
      case CalculatorKeyAction.multiply:
        _controller.setBinaryOperator(AppStrings.multiplicationSymbol);
      case CalculatorKeyAction.divide:
        _controller.setBinaryOperator(AppStrings.divisionSymbol);
    }
  }

  void _runScientificKey(String? character) {
    if (character == null) return;

    switch (character.toLowerCase()) {
      case 's':
        _controller.appendFunction(ScientificFunctionType.sin);
      case 'c':
        _controller.appendFunction(ScientificFunctionType.cos);
      case 't':
        _controller.appendFunction(ScientificFunctionType.tan);
      case 'l':
        _controller.appendFunction(ScientificFunctionType.log);
      case 'n':
        _controller.appendFunction(ScientificFunctionType.ln);
      case 'p':
        _controller.appendConstant(AppScientificStrings.pi);
      case '(':
        _controller.openParen();
      case ')':
        _controller.closeParen();
      case '!':
        _controller.appendFunction(ScientificFunctionType.factorial);
      case '^':
        _controller.setBinaryOperator(ScientificFunctionType.power.lexeme);
    }
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
        title: AppBarTitleWidget(text: l10n.scientificPageTitle),
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
                  child: isLandscape
                      ? LandscapeLayoutWidget(
                          displayText: resolvedDisplayText,
                          expressionDisplay: _controller.expressionDisplay,
                          keypad: _ScientificKeypadSection(
                            controller: _controller,
                          ),
                        )
                      : PortraitLayoutWidget(
                          displayText: resolvedDisplayText,
                          expressionDisplay: _controller.expressionDisplay,
                          keypad: _ScientificKeypadSection(
                            controller: _controller,
                          ),
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

class _ScientificKeypadSection extends StatelessWidget {
  final ScientificCalculatorController controller;

  const _ScientificKeypadSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ScientificKeypadWidget(
      angleMode: controller.angleMode,
      isShiftActive: controller.isShiftActive,
      hasMemoryValue: controller.state.hasMemoryValue,
      onToggleAngleMode: controller.toggleAngleMode,
      onToggleShift: controller.toggleShift,
      onLockShift: controller.lockShift,
      onPi: () => controller.appendConstant(AppScientificStrings.pi),
      onEuler: () => controller.appendConstant(AppScientificStrings.euler),
      onFunction: controller.appendFunction,
      onBinaryOperator: controller.setBinaryOperator,
      onOpenParen: controller.openParen,
      onCloseParen: controller.closeParen,
      onMemoryAdd: controller.memoryAdd,
      onMemorySubtract: controller.memorySubtract,
      onMemoryRecall: controller.memoryRecall,
      onMemoryClear: controller.memoryClear,
      onClear: controller.clearAll,
      onBackspace: controller.backspace,
      onPercentage: controller.calculatePercentage,
      onDecimal: controller.appendDecimal,
      onCalculate: controller.calculateResult,
      onNumberPressed: controller.appendNumber,
    );
  }
}
