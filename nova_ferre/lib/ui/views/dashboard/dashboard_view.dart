import 'package:nova_ferre/nova_ferre_exports.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            "Panel de Métricas",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          Text(
            "Próximamente: Gráficas de ventas y KPIs",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
