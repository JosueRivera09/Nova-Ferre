import 'package:nova_ferre/nova_ferre_exports.dart';

class LogisticsView extends StatelessWidget {
  const LogisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            "Módulo de Logística",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          Text(
            "Próximamente: Seguimiento de entregas y pedidos",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
