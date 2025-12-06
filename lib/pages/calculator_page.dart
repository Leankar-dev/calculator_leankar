import 'package:calculator_05122025/controllers/calculator_controller.dart';
import 'package:calculator_05122025/utils/enums/operations_type.dart';
import 'package:calculator_05122025/widgets/calculator_display_widget.dart';
import 'package:calculator_05122025/widgets/calculator_keypad_widget.dart';
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
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  void _handleKeyEvent(KeyEvent event) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: const Text(
          'Calculadora',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: Column(
          children: [
            CalculatorDisplayWidget(
              displayText: _controller.displayText,
              expressionDisplay: _controller.expressionDisplay,
            ),
            const SizedBox(height: 10),
            CalculatorKeypadWidget(
              onClear: _controller.clearDisplay,
              onBackspace: _controller.backspace,
              onPercentage: _controller.calculatePercentage,
              onDecimal: _controller.appendDecimal,
              onCalculate: _controller.calculateResult,
              onNumberPressed: _controller.appendNumber,
              onOperationPressed: _controller.setOperationType,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Neumorphic(
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(16),
                        ),
                        depth: 4,
                        intensity: 0.5,
                        color: NeumorphicTheme.baseColor(context),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 60,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '📧 leankar.dev@gmail.com',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '🌐 https://leankar.dev',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
