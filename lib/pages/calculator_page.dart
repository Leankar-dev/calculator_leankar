import 'package:calculator_05122025/controllers/calculator_controller.dart';
import 'package:calculator_05122025/services/logger_service.dart';
import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/utils/responsive_utils.dart';
import 'package:calculator_05122025/widgets/calculator_display_widget.dart';
import 'package:calculator_05122025/widgets/calculator_keypad_widget.dart';
import 'package:calculator_05122025/widgets/history_bottom_sheet.dart';
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

  void _handleKeyEvent(KeyEvent event) {
    try {
      if (event is! KeyDownEvent) return;

      final String? key = event.character;
      final LogicalKeyboardKey logicalKey = event.logicalKey;

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
        title: const Text(
          'Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
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
                      ? _buildLandscapeLayout()
                      : _buildPortraitLayout(context),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CalculatorDisplayWidget(
              displayText: _controller.displayText,
              expressionDisplay: _controller.expressionDisplay,
            ),
            const SizedBox(height: 8),
            CalculatorKeypadWidget(
              onClear: _controller.clearDisplay,
              onBackspace: _controller.backspace,
              onPercentage: _controller.calculatePercentage,
              onDecimal: _controller.appendDecimal,
              onCalculate: _controller.calculateResult,
              onNumberPressed: _controller.appendNumber,
              onOperationPressed: _controller.setOperationType,
            ),
            const SizedBox(height: 8),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CalculatorDisplayWidget(
                  displayText: _controller.displayText,
                  expressionDisplay: _controller.expressionDisplay,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: CalculatorKeypadWidget(
              onClear: _controller.clearDisplay,
              onBackspace: _controller.backspace,
              onPercentage: _controller.calculatePercentage,
              onDecimal: _controller.appendDecimal,
              onCalculate: _controller.calculateResult,
              onNumberPressed: _controller.appendNumber,
              onOperationPressed: _controller.setOperationType,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(12),
              ),
              depth: 3,
              intensity: 0.5,
              color: NeumorphicTheme.baseColor(context),
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/images/logo2.png',
              height: 45,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'https://leankar.dev',
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
