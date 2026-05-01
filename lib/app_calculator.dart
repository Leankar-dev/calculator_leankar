import 'package:calculator_05122025/pages/calculator_page.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator App',
      themeMode: ThemeMode.light,
      theme: const NeumorphicThemeData(
        baseColor: Color(0xFFE0E5EC),
        lightSource: LightSource.topLeft,
        depth: 10,
        intensity: 0.5,
      ),
      darkTheme: const NeumorphicThemeData(
        baseColor: Color(0xFF3E3E3E),
        lightSource: LightSource.topLeft,
        depth: 6,
        intensity: 0.3,
      ),
      home: const CalculatorPage(),
    );
  }
}
