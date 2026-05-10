import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class AppDrawerWidget extends StatelessWidget {
  final VoidCallback onHistoryTap;
  final VoidCallback onImcTap;
  final VoidCallback onSettingsTap;

  const AppDrawerWidget({
    super.key,
    required this.onHistoryTap,
    required this.onImcTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: NeumorphicTheme.baseColor(context),
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeader(),
            const Divider(),
            _DrawerItem(
              icon: Icons.history,
              label: 'Histórico',
              onTap: () {
                Navigator.of(context).pop();
                onHistoryTap();
              },
            ),
            _DrawerItem(
              icon: Icons.monitor_weight_outlined,
              label: 'Calculadora IMC',
              onTap: () {
                Navigator.of(context).pop();
                onImcTap();
              },
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              label: 'Configurações',
              onTap: () {
                Navigator.of(context).pop();
                onSettingsTap();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
              depth: 6,
              intensity: 0.8,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset('assets/images/logo4.png', height: 36),
          ),
          const SizedBox(width: 16),
          const Text(
            'Leankar Calc',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      style: const NeumorphicStyle(depth: 2, intensity: 0.6),
      onPressed: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
