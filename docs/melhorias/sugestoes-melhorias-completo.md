# Sugestões de Melhorias - Calculator Leankar

## Índice
1. [Arquitetura e Estrutura](#arquitetura-e-estrutura)
2. [Controle de Estado](#controle-de-estado)
3. [Widgets e UI](#widgets-e-ui)
4. [Testes](#testes)
5. [Código e Boas Práticas](#código-e-boas-práticas)
6. [Acessibilidade](#acessibilidade)
7. [Internacionalização](#internacionalização)
8. [Recursos Adicionais](#recursos-adicionais)

---

## Arquitetura e Estrutura

### 1. Implementar Injeção de Dependências
**Prioridade: Alta**

Atualmente, o `CalculatorController` é instanciado diretamente na `CalculatorPage`. Recomenda-se usar um padrão de injeção de dependências.

**Sugestão:**
```dart
// Usar Provider ou GetIt para injeção de dependências
class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculatorController(),
      child: const _CalculatorPageContent(),
    );
  }
}
```

**Benefícios:**
- Facilita testes unitários
- Melhora a manutenibilidade
- Permite melhor separação de responsabilidades

### 2. Adicionar Camada de Services
**Prioridade: Média**

Extrair a lógica de cálculo para uma classe de serviço separada.

**Sugestão:**
```dart
// lib/services/calculation_service.dart
class CalculationService {
  double calculate({
    required double first,
    required double second,
    required OperationsType operation,
  }) {
    switch (operation) {
      case OperationsType.addition:
        return first + second;
      case OperationsType.subtraction:
        return first - second;
      case OperationsType.multiplication:
        return first * second;
      case OperationsType.division:
        if (second == 0) throw DivisionByZeroException();
        return first / second;
    }
  }
}
```

**Benefícios:**
- Separação de responsabilidades
- Facilita testes da lógica de cálculo
- Permite reutilização em outros contextos

---

## Controle de Estado

### 3. Implementar Estado Imutável
**Prioridade: Alta**

O `CalculatorController` usa variáveis mutáveis. Considere usar um estado imutável.

**Sugestão:**
```dart
// lib/models/calculator_state.dart
class CalculatorState {
  final String displayText;
  final String firstOperand;
  final String secondOperand;
  final OperationsType? currentOperation;
  final bool shouldResetDisplay;

  const CalculatorState({
    this.displayText = '0',
    this.firstOperand = '',
    this.secondOperand = '',
    this.currentOperation,
    this.shouldResetDisplay = false,
  });

  CalculatorState copyWith({
    String? displayText,
    String? firstOperand,
    String? secondOperand,
    OperationsType? currentOperation,
    bool? shouldResetDisplay,
  }) {
    return CalculatorState(
      displayText: displayText ?? this.displayText,
      firstOperand: firstOperand ?? this.firstOperand,
      secondOperand: secondOperand ?? this.secondOperand,
      currentOperation: currentOperation ?? this.currentOperation,
      shouldResetDisplay: shouldResetDisplay ?? this.shouldResetDisplay,
    );
  }
}
```

**Benefícios:**
- Mais fácil de testar
- Previne bugs relacionados a estado mutável
- Facilita implementação de undo/redo

### 4. Adicionar Histórico de Cálculos
**Prioridade: Baixa**

Implementar um histórico de operações realizadas.

**Sugestão:**
```dart
class CalculationHistory {
  final String expression;
  final String result;
  final DateTime timestamp;

  CalculationHistory({
    required this.expression,
    required this.result,
    required this.timestamp,
  });
}

// No controller
final List<CalculationHistory> _history = [];

void _addToHistory(String expression, String result) {
  _history.add(CalculationHistory(
    expression: expression,
    result: result,
    timestamp: DateTime.now(),
  ));
}
```

---

## Widgets e UI

### 5. Adicionar Feedback Tátil (Haptic Feedback)
**Prioridade: Média**

Melhorar a experiência do usuário com feedback tátil ao pressionar botões.

**Sugestão:**
```dart
// No ButtonWidget
import 'package:flutter/services.dart';

onPressed: () {
  HapticFeedback.lightImpact();
  widget.onPressed();
}
```

### 6. Implementar Animações
**Prioridade: Baixa**

Adicionar animações sutis para melhorar a experiência do usuário.

**Sugestão:**
```dart
// No CalculatorDisplayWidget
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: Text(
    displayText,
    key: ValueKey(displayText),
    style: const TextStyle(fontSize: 48),
  ),
)
```

### 7. Melhorar Responsividade
**Prioridade: Alta**

Adaptar o layout para diferentes tamanhos de tela.

**Sugestão:**
```dart
// lib/utils/responsive_utils.dart
class ResponsiveUtils {
  static double getButtonFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 28;
    if (width > 400) return 24;
    return 20;
  }

  static double getDisplayFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 64;
    if (width > 400) return 48;
    return 36;
  }
}
```

### 8. Adicionar Modo Landscape
**Prioridade: Média**

Otimizar o layout para orientação paisagem.

**Sugestão:**
```dart
@override
Widget build(BuildContext context) {
  final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
  
  return Scaffold(
    body: isLandscape
        ? Row(
            children: [
              Expanded(child: CalculatorDisplayWidget(...)),
              Expanded(child: CalculatorKeypadWidget(...)),
            ],
          )
        : Column(
            children: [
              CalculatorDisplayWidget(...),
              CalculatorKeypadWidget(...),
            ],
          ),
  );
}
```

---

## Testes

### 9. Adicionar Testes de Integração
**Prioridade: Alta**

Criar testes de integração para fluxos completos.

**Sugestão:**
```dart
// integration_test/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Fluxo completo de cálculo', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Testar sequência de operações
    await tester.tap(find.text('5'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('3'));
    await tester.tap(find.text('='));
    
    expect(find.text('8'), findsOneWidget);
  });
}
```

### 10. Implementar Testes Golden
**Prioridade: Média**

Adicionar testes de snapshot visual.

**Sugestão:**
```dart
// test/widgets/golden/calculator_display_golden_test.dart
void main() {
  testWidgets('Display rendering matches golden', (tester) async {
    await tester.pumpWidget(
      NeumorphicApp(
        home: CalculatorDisplayWidget(
          displayText: '123',
          expressionDisplay: '100 +',
        ),
      ),
    );

    await expectLater(
      find.byType(CalculatorDisplayWidget),
      matchesGoldenFile('goldens/calculator_display.png'),
    );
  });
}
```

### 11. Melhorar Cobertura de Testes de Edge Cases
**Prioridade: Alta**

Adicionar mais testes para casos extremos.

**Sugestão:**
```dart
test('deve lidar com números muito grandes', () {
  controller.appendNumber('9');
  for (int i = 0; i < 20; i++) {
    controller.appendNumber('9');
  }
  expect(controller.displayText.length, lessThan(30));
});

test('deve lidar com muitos decimais', () {
  controller.appendNumber('1');
  controller.appendDecimal();
  for (int i = 0; i < 15; i++) {
    controller.appendNumber('3');
  }
  expect(controller.displayText.split(',')[1].length, lessThanOrEqualTo(10));
});
```

---

## Código e Boas Práticas

### 12. Adicionar Constantes Globais
**Prioridade: Média**

Centralizar valores mágicos em constantes.

**Sugestão:**
```dart
// lib/utils/constants.dart
class AppConstants {
  // Cores
  static const Color clearButtonColor = Color(0xFFE57373);
  static const Color backspaceButtonColor = Color(0xFFFFB74D);
  static const Color operationButtonColor = Color(0xFF64B5F6);
  static const Color equalsButtonColor = Color(0xFF81C784);
  
  // Tamanhos
  static const double buttonPadding = 6.0;
  static const double buttonBorderRadius = 16.0;
  static const double displayHeight = 160.0;
  
  // Limites
  static const int maxDisplayLength = 15;
  static const int maxDecimalPlaces = 8;
}
```

### 13. Implementar Tratamento de Erros Robusto
**Prioridade: Alta**

Criar um sistema de tratamento de erros mais completo.

**Sugestão:**
```dart
// lib/utils/exceptions.dart
class CalculatorException implements Exception {
  final String message;
  CalculatorException(this.message);
}

class DivisionByZeroException extends CalculatorException {
  DivisionByZeroException() : super('Divisão por zero');
}

class OverflowException extends CalculatorException {
  OverflowException() : super('Número muito grande');
}

// No controller
void _handleError(Exception e) {
  if (e is CalculatorException) {
    _displayText = e.message;
  } else {
    _displayText = 'Erro desconhecido';
  }
  notifyListeners();
}
```

### 14. Adicionar Logging
**Prioridade: Baixa**

Implementar sistema de logs para debugging.

**Sugestão:**
```dart
// lib/utils/logger.dart
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger();

  static void debug(String message) => _logger.d(message);
  static void info(String message) => _logger.i(message);
  static void warning(String message) => _logger.w(message);
  static void error(String message, [dynamic error]) => _logger.e(message, error: error);
}

// No controller
void calculateResult() {
  AppLogger.info('Calculando: $_firstOperand $_currentOperation $_secondOperand');
  // ... resto do código
}
```

### 15. Refatorar Formatação de Números
**Prioridade: Média**

Usar `NumberFormat` para formatação consistente.

**Sugestão:**
```dart
import 'package:intl/intl.dart';

// lib/utils/number_formatter.dart
class NumberFormatter {
  static final NumberFormat _formatter = NumberFormat.decimalPattern('pt_BR');
  
  static String format(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return _formatter.format(value);
  }
  
  static double? parse(String text) {
    try {
      return _formatter.parse(text).toDouble();
    } catch (e) {
      return null;
    }
  }
}
```

---

## Acessibilidade

### 16. Adicionar Suporte a Screen Readers
**Prioridade: Alta**

Melhorar acessibilidade com Semantics.

**Sugestão:**
```dart
// No ButtonWidget
Semantics(
  button: true,
  label: _getSemanticLabel(text),
  child: NeumorphicButton(
    // ... resto do código
  ),
)

String _getSemanticLabel(String text) {
  switch (text) {
    case '\u{00F7}': return 'Dividir';
    case '\u{00D7}': return 'Multiplicar';
    case '\u{002D}': return 'Subtrair';
    case '\u{002B}': return 'Adicionar';
    case '\u{232B}': return 'Apagar';
    case '\u{0025}': return 'Porcentagem';
    case '=': return 'Igual';
    case 'C': return 'Limpar';
    default: return text;
  }
}
```

### 17. Melhorar Contraste de Cores
**Prioridade: Média**

Garantir contraste adequado para acessibilidade.

**Sugestão:**
```dart
// Verificar contraste WCAG AA (4.5:1) para texto normal
// Usar ferramentas como https://webaim.org/resources/contrastchecker/

// Adicionar temas com alto contraste
class HighContrastTheme {
  static NeumorphicThemeData lightTheme = const NeumorphicThemeData(
    baseColor: Color(0xFFFFFFFF),
    defaultTextColor: Color(0xFF000000),
    // ... outras configurações
  );
}
```

---

## Internacionalização

### 18. Implementar i18n Completo
**Prioridade: Média**

Adicionar suporte completo a múltiplos idiomas.

**Sugestão:**
```dart
// lib/l10n/app_en.arb
{
  "appTitle": "Calculator Leankar",
  "clear": "Clear",
  "backspace": "Backspace",
  "percentage": "Percentage",
  "errorDivisionByZero": "Division by zero"
}

// lib/l10n/app_pt.arb
{
  "appTitle": "Calculadora Leankar",
  "clear": "Limpar",
  "backspace": "Apagar",
  "percentage": "Porcentagem",
  "errorDivisionByZero": "Divisão por zero"
}

// pubspec.yaml
flutter:
  generate: true
```

---

## Recursos Adicionais

### 19. Adicionar Temas Customizáveis
**Prioridade: Baixa**

Permitir que o usuário escolha temas personalizados.

**Sugestão:**
```dart
// lib/models/theme_model.dart
class ThemeModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = Colors.blue;

  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setAccentColor(Color color) {
    _accentColor = color;
    notifyListeners();
  }
}
```

### 20. Implementar Persistência Local
**Prioridade: Baixa**

Salvar configurações e histórico localmente.

**Sugestão:**
```dart
// lib/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _historyKey = 'calculation_history';
  static const String _themeModeKey = 'theme_mode';

  Future<void> saveHistory(List<CalculationHistory> history) async {
    final prefs = await SharedPreferences.getInstance();
    final json = history.map((h) => h.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(json));
  }

  Future<List<CalculationHistory>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_historyKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => CalculationHistory.fromJson(e)).toList();
  }
}
```

### 21. Adicionar Modo Científico
**Prioridade: Baixa**

Expandir funcionalidades para calculadora científica.

**Sugestão:**
```dart
// lib/utils/enums/operations_type.dart
enum OperationsType {
  addition(symbol: '+'),
  subtraction(symbol: '-'),
  multiplication(symbol: '×'),
  division(symbol: '÷'),
  // Novas operações
  sine(symbol: 'sin'),
  cosine(symbol: 'cos'),
  tangent(symbol: 'tan'),
  squareRoot(symbol: '√'),
  power(symbol: '^'),
  logarithm(symbol: 'log');
  
  final String symbol;
  const OperationsType({required this.symbol});
}
```

### 22. Implementar Modo de Conversão de Unidades
**Prioridade: Baixa**

Adicionar conversor de unidades (comprimento, peso, temperatura, etc.).

**Sugestão:**
```dart
// lib/pages/converter_page.dart
class ConverterPage extends StatelessWidget {
  const ConverterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: const Text('Conversor'),
      ),
      body: Column(
        children: [
          // Seletor de categoria (comprimento, peso, etc)
          // Inputs de origem e destino
          // Botão de converter
        ],
      ),
    );
  }
}
```

---

## Melhorias de Performance

### 23. Implementar Lazy Loading
**Prioridade: Baixa**

Para o histórico, se implementado.

**Sugestão:**
```dart
ListView.builder(
  itemCount: history.length,
  itemBuilder: (context, index) {
    return HistoryItemWidget(history: history[index]);
  },
)
```

### 24. Otimizar Rebuild de Widgets
**Prioridade: Média**

Usar `const` construtores sempre que possível e `Consumer` para rebuilds seletivos.

**Sugestão:**
```dart
// Ao invés de usar setState() na página inteira
Consumer<CalculatorController>(
  builder: (context, controller, child) {
    return CalculatorDisplayWidget(
      displayText: controller.displayText,
      expressionDisplay: controller.expressionDisplay,
    );
  },
)
```

---

## Documentação

### 25. Adicionar Documentação de API
**Prioridade: Média**

Documentar todas as classes e métodos públicos.

**Sugestão:**
```dart
/// Controla o estado e a lógica da calculadora.
///
/// Este controller gerencia:
/// - Display atual ([displayText])
/// - Operandos da operação ([_firstOperand], [_secondOperand])
/// - Operação matemática atual ([_currentOperation])
/// 
/// Exemplo de uso:
/// ```dart
/// final controller = CalculatorController();
/// controller.appendNumber('5');
/// controller.setOperationType(OperationsType.addition);
/// controller.appendNumber('3');
/// controller.calculateResult();
/// print(controller.displayText); // '8'
/// ```
class CalculatorController extends ChangeNotifier {
  // ...
}
```

### 26. Criar Diagramas de Arquitetura
**Prioridade: Baixa**

Adicionar diagramas UML ou de fluxo na documentação.

**Sugestão:**
```markdown
<!-- docs/architecture.md -->
# Arquitetura

## Diagrama de Componentes

┌─────────────────┐
│   MyApp         │
└────────┬────────┘
         │
┌────────▼────────┐
│ CalculatorPage  │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼───┐ ┌──▼──────────────────┐
│Display│ │CalculatorController │
└───────┘ └─────────────────────┘
```

---

## CI/CD

### 27. Adicionar GitHub Actions
**Prioridade: Alta**

Automatizar testes e análise de código.

**Sugestão:**
```yaml
# .github/workflows/flutter.yml
name: Flutter CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.1'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3
```

### 28. Configurar Deploy Automático
**Prioridade: Média**

Automatizar build e deploy para web.

**Sugestão:**
```yaml
# .github/workflows/deploy.yml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build web --release
      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

---

## Segurança

### 29. Adicionar Validações de Entrada
**Prioridade: Alta**

Validar todas as entradas do usuário.

**Sugestão:**
```dart
void appendNumber(String digit) {
  if (!RegExp(r'^[0-9]$').hasMatch(digit)) {
    AppLogger.warning('Entrada inválida: $digit');
    return;
  }
  
  if (_displayText.length >= AppConstants.maxDisplayLength) {
    AppLogger.warning('Limite de caracteres atingido');
    return;
  }
  
  // ... resto do código
}
```

---

## Priorização de Implementação

### Fase 1 - Crítico (1-2 semanas)
1. Injeção de Dependências (#1)
2. Estado Imutável (#3)
3. Tratamento de Erros (#13)
4. Testes de Edge Cases (#11)
5. Validações de Entrada (#29)
6. Suporte a Screen Readers (#16)

### Fase 2 - Importante (2-4 semanas)
7. Camada de Services (#2)
8. Responsividade (#7)
9. Feedback Tátil (#5)
10. Constantes Globais (#12)
11. Testes de Integração (#9)
12. GitHub Actions (#27)

### Fase 3 - Melhorias (1-2 meses)
13. Histórico de Cálculos (#4)
14. i18n Completo (#18)
15. Modo Landscape (#8)
16. Temas Customizáveis (#19)
17. Persistência Local (#20)
18. Documentação de API (#25)

### Fase 4 - Recursos Adicionais (opcional)
19. Animações (#6)
20. Modo Científico (#21)
21. Conversor de Unidades (#22)
22. Testes Golden (#10)

---

## Conclusão

Este documento apresenta 29 sugestões de melhorias organizadas por categoria e prioridade. Recomenda-se implementar as melhorias de forma incremental, começando pelas de alta prioridade (Fase 1) e progredindo gradualmente.

Cada melhoria foi projetada para:
- ✅ Melhorar a qualidade do código
- ✅ Aumentar a manutenibilidade
- ✅ Facilitar testes
- ✅ Melhorar a experiência do usuário
- ✅ Preparar o app para crescimento futuro

**Última atualização:** Janeiro 2026  
**Versão do documento:** 1.0
