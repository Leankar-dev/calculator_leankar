# Calculadora Neumórfica

Uma calculadora Flutter com design neumórfico moderno.

## Funcionalidades

- Operações aritméticas básicas: adição, subtração, multiplicação e divisão
- Cálculo de porcentagem
- Suporte a entrada via teclado físico
- Design neumórfico com suporte a tema claro/escuro
- Separador decimal com vírgula (padrão brasileiro)

## Atalhos de Teclado

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

## Como Executar

```bash
# Instalar dependências
flutter pub get

# Executar o app
flutter run
```

## Tecnologias

- Flutter SDK ^3.10.1
- [flutter_neumorphic_plus](https://pub.dev/packages/flutter_neumorphic_plus) - Design neumórfico

## Estrutura do Projeto

```
lib/
├── main.dart                    # Ponto de entrada do app
├── controllers/
│   └── calculator_controller.dart   # Lógica de cálculo
├── pages/
│   └── calculator_page.dart     # Tela principal
├── widgets/
│   ├── button_widget.dart       # Botão neumórfico
│   ├── calculator_display_widget.dart   # Display da calculadora
│   └── calculator_keypad_widget.dart    # Teclado numérico
└── utils/
    └── enums/
        └── operations_type.dart # Tipos de operações
```

## Autor

- Email: leankar.dev@gmail.com
- Website: https://leankar.dev
