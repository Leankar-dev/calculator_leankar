import 'package:calculator_05122025/controllers/calculator_controller.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/utils/responsive_utils.dart';
import 'package:calculator_05122025/widgets/history_bottom_sheet.dart';
import 'package:calculator_05122025/widgets/landscape_layout_widget.dart';
import 'package:calculator_05122025/widgets/portrait_layout_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final CalculatorController _controller = CalculatorController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeController();
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
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
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
              _showSnackBar('Valor copiado');
            }
          });
          return;
        }
        if (logicalKey == LogicalKeyboardKey.keyV) {
          _controller.pasteFromClipboard().then((success) {
            if (!success && mounted) {
              _showSnackBar('Valor inválido para colar');
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
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(10),
                ),
                depth: 6,
                intensity: 0.8,
                lightSource: LightSource.topLeft,
                color: NeumorphicTheme.baseColor(context),
              ),
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                'assets/images/logo2.png',
                height: 40,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Calculator',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          NeumorphicButton(
            style: const NeumorphicStyle(
              depth: 2,
              intensity: 0.6,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            padding: const EdgeInsets.all(12),
            onPressed: _showHistory,
            child: Icon(
              Icons.history,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
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

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isLandscape ? double.infinity : maxWidth,
                  ),
                  child: isLandscape
                      ? LandscapeLayoutWidget(
                          displayText: _controller.displayText,
                          expressionDisplay: _controller.expressionDisplay,
                          onClear: _controller.clearDisplay,
                          onBackspace: _controller.backspace,
                          onPercentage: _controller.calculatePercentage,
                          onDecimal: _controller.appendDecimal,
                          onCalculate: _controller.calculateResult,
                          onNumberPressed: _controller.appendNumber,
                          onOperationPressed: _controller.setOperationType,
                        )
                      : PortraitLayoutWidget(
                          displayText: _controller.displayText,
                          expressionDisplay: _controller.expressionDisplay,
                          onClear: _controller.clearDisplay,
                          onBackspace: _controller.backspace,
                          onPercentage: _controller.calculatePercentage,
                          onDecimal: _controller.appendDecimal,
                          onCalculate: _controller.calculateResult,
                          onNumberPressed: _controller.appendNumber,
                          onOperationPressed: _controller.setOperationType,
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
