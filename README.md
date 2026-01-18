# Calculadora Neumórfica / Neumorphic Calculator / Calculadora Neumórfica

<p align="center">
  <img src="assets/images/logo.png" alt="Logo" width="100">
</p>

---

## Idiomas / Languages / Idiomas

- [Português (BR)](#português-br)
- [English](#english)
- [Español](#español)

---

# Português (BR)

## Calculadora Neumórfica

Uma calculadora Flutter com design neumórfico moderno, desenvolvida seguindo as melhores práticas de arquitetura e testes.

### Funcionalidades

- Operações aritméticas básicas: adição, subtração, multiplicação e divisão
- Cálculo de porcentagem
- Suporte a entrada via teclado físico
- Design neumórfico elegante
- Suporte a tema claro/escuro
- Separador decimal com vírgula (padrão brasileiro)
- Tratamento de erro para divisão por zero

### Capturas de Tela

A calculadora apresenta um design neumórfico com botões em alto-relevo e display em baixo-relevo, proporcionando uma experiência visual moderna e agradável.

### Atalhos de Teclado

| Tecla | Ação |
|-------|------|
| `0-9` | Inserir números |
| `+`, `-`, `*`, `/` | Operações |
| `,` ou `.` | Separador decimal |
| `Enter` ou `=` | Calcular resultado |
| `Backspace` | Apagar último dígito |
| `Escape` ou `Delete` | Limpar tudo |
| `%` | Calcular porcentagem |
| `C` | Limpar display |

### Como Executar

```bash
# Clonar o repositório
git clone <url-do-repositorio>

# Entrar no diretório
cd calculator_leankar

# Instalar dependências
flutter pub get

# Executar o app
flutter run

# Executar testes
flutter test

# Analisar código
flutter analyze
```

### Tecnologias

- **Flutter SDK** ^3.10.1
- **Dart** ^3.10.1
- [flutter_neumorphic_plus](https://pub.dev/packages/flutter_neumorphic_plus) - Design neumórfico

### Arquitetura

O app segue um padrão similar ao MVC com separação clara de responsabilidades:

```
lib/
├── main.dart                           # Ponto de entrada
├── app_calculator.dart                 # Configuração do app (tema, rotas)
├── controllers/
│   └── calculator_controller.dart      # Lógica de negócio (ChangeNotifier)
├── pages/
│   └── calculator_page.dart            # Tela principal (StatefulWidget)
├── widgets/
│   ├── button_widget.dart              # Botão neumórfico reutilizável
│   ├── calculator_display_widget.dart  # Display da calculadora
│   ├── calculator_keypad_widget.dart   # Orquestrador do teclado
│   ├── first_row_widget.dart           # Linha: C, ⌫, %
│   ├── number_row_widget.dart          # Linhas de números + operação
│   └── last_row_widget.dart            # Linha: 0, vírgula, =, +
└── utils/
    └── enums/
        └── operations_type.dart        # Enum de operações
```

### Testes

O projeto possui cobertura completa de testes:

```
test/
├── controllers/
│   └── calculator_controller_test.dart  # 23 testes
├── pages/
│   └── calculator_page_test.dart        # 20 testes
└── widgets/
    ├── button_widget_test.dart          # 6 testes
    ├── calculator_display_widget_test.dart # 8 testes
    └── calculator_keypad_widget_test.dart  # 14 testes
```

**Total: 71 testes**

### Padrões de Código

- Todos os widgets são implementados como classes (`StatelessWidget` ou `StatefulWidget`)
- Gerenciamento de estado com `ChangeNotifier`
- Separação de responsabilidades entre UI e lógica
- Nomenclatura consistente e em inglês
- Testes automatizados para todas as funcionalidades

---

# English

## Neumorphic Calculator

A Flutter calculator with modern neumorphic design, developed following best practices for architecture and testing.

### Features

- Basic arithmetic operations: addition, subtraction, multiplication, and division
- Percentage calculation
- Physical keyboard input support
- Elegant neumorphic design
- Light/dark theme support
- Comma as decimal separator (Brazilian standard)
- Error handling for division by zero

### Screenshots

The calculator features a neumorphic design with embossed buttons and engraved display, providing a modern and pleasant visual experience.

### Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `0-9` | Insert numbers |
| `+`, `-`, `*`, `/` | Operations |
| `,` or `.` | Decimal separator |
| `Enter` or `=` | Calculate result |
| `Backspace` | Delete last digit |
| `Escape` or `Delete` | Clear all |
| `%` | Calculate percentage |
| `C` | Clear display |

### How to Run

```bash
# Clone the repository
git clone <repository-url>

# Enter the directory
cd calculator_leankar

# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze
```

### Technologies

- **Flutter SDK** ^3.10.1
- **Dart** ^3.10.1
- [flutter_neumorphic_plus](https://pub.dev/packages/flutter_neumorphic_plus) - Neumorphic design

### Architecture

The app follows an MVC-like pattern with clear separation of concerns:

```
lib/
├── main.dart                           # Entry point
├── app_calculator.dart                 # App configuration (theme, routes)
├── controllers/
│   └── calculator_controller.dart      # Business logic (ChangeNotifier)
├── pages/
│   └── calculator_page.dart            # Main screen (StatefulWidget)
├── widgets/
│   ├── button_widget.dart              # Reusable neumorphic button
│   ├── calculator_display_widget.dart  # Calculator display
│   ├── calculator_keypad_widget.dart   # Keypad orchestrator
│   ├── first_row_widget.dart           # Row: C, ⌫, %
│   ├── number_row_widget.dart          # Number rows + operation
│   └── last_row_widget.dart            # Row: 0, comma, =, +
└── utils/
    └── enums/
        └── operations_type.dart        # Operations enum
```

### Tests

The project has complete test coverage:

```
test/
├── controllers/
│   └── calculator_controller_test.dart  # 23 tests
├── pages/
│   └── calculator_page_test.dart        # 20 tests
└── widgets/
    ├── button_widget_test.dart          # 6 tests
    ├── calculator_display_widget_test.dart # 8 tests
    └── calculator_keypad_widget_test.dart  # 14 tests
```

**Total: 71 tests**

### Code Standards

- All widgets are implemented as classes (`StatelessWidget` or `StatefulWidget`)
- State management with `ChangeNotifier`
- Separation of concerns between UI and logic
- Consistent naming conventions in English
- Automated tests for all features

---

# Español

## Calculadora Neumórfica

Una calculadora Flutter con diseño neumórfico moderno, desarrollada siguiendo las mejores prácticas de arquitectura y pruebas.

### Funcionalidades

- Operaciones aritméticas básicas: suma, resta, multiplicación y división
- Cálculo de porcentaje
- Soporte para entrada por teclado físico
- Diseño neumórfico elegante
- Soporte para tema claro/oscuro
- Coma como separador decimal (estándar brasileño)
- Manejo de errores para división por cero

### Capturas de Pantalla

La calculadora presenta un diseño neumórfico con botones en relieve y pantalla hundida, proporcionando una experiencia visual moderna y agradable.

### Atajos de Teclado

| Tecla | Acción |
|-------|--------|
| `0-9` | Insertar números |
| `+`, `-`, `*`, `/` | Operaciones |
| `,` o `.` | Separador decimal |
| `Enter` o `=` | Calcular resultado |
| `Backspace` | Borrar último dígito |
| `Escape` o `Delete` | Limpiar todo |
| `%` | Calcular porcentaje |
| `C` | Limpiar pantalla |

### Cómo Ejecutar

```bash
# Clonar el repositorio
git clone <url-del-repositorio>

# Entrar en el directorio
cd calculator_leankar

# Instalar dependencias
flutter pub get

# Ejecutar la app
flutter run

# Ejecutar pruebas
flutter test

# Analizar código
flutter analyze
```

### Tecnologías

- **Flutter SDK** ^3.10.1
- **Dart** ^3.10.1
- [flutter_neumorphic_plus](https://pub.dev/packages/flutter_neumorphic_plus) - Diseño neumórfico

### Arquitectura

La app sigue un patrón similar a MVC con clara separación de responsabilidades:

```
lib/
├── main.dart                           # Punto de entrada
├── app_calculator.dart                 # Configuración de la app (tema, rutas)
├── controllers/
│   └── calculator_controller.dart      # Lógica de negocio (ChangeNotifier)
├── pages/
│   └── calculator_page.dart            # Pantalla principal (StatefulWidget)
├── widgets/
│   ├── button_widget.dart              # Botón neumórfico reutilizable
│   ├── calculator_display_widget.dart  # Pantalla de la calculadora
│   ├── calculator_keypad_widget.dart   # Orquestador del teclado
│   ├── first_row_widget.dart           # Fila: C, ⌫, %
│   ├── number_row_widget.dart          # Filas de números + operación
│   └── last_row_widget.dart            # Fila: 0, coma, =, +
└── utils/
    └── enums/
        └── operations_type.dart        # Enum de operaciones
```

### Pruebas

El proyecto tiene cobertura completa de pruebas:

```
test/
├── controllers/
│   └── calculator_controller_test.dart  # 23 pruebas
├── pages/
│   └── calculator_page_test.dart        # 20 pruebas
└── widgets/
    ├── button_widget_test.dart          # 6 pruebas
    ├── calculator_display_widget_test.dart # 8 pruebas
    └── calculator_keypad_widget_test.dart  # 14 pruebas
```

**Total: 71 pruebas**

### Estándares de Código

- Todos los widgets están implementados como clases (`StatelessWidget` o `StatefulWidget`)
- Gestión de estado con `ChangeNotifier`
- Separación de responsabilidades entre UI y lógica
- Nomenclatura consistente en inglés
- Pruebas automatizadas para todas las funcionalidades

---

## Autor / Author / Autor

<p align="center">
  <strong>LeanKar Dev</strong><br>
  📧 leankar.dev@gmail.com<br>
  🌐 <a href="https://leankar.dev">https://leankar.dev</a>
</p>

---

## Licença / License / Licencia

Este projeto está sob a licença MIT. / This project is under the MIT license. / Este proyecto está bajo la licencia MIT.
