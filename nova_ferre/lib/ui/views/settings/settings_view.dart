import 'package:nova_ferre/nova_ferre_exports.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Configuración",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
