import 'package:nova_ferre/nova_ferre_exports.dart';

class InventoryView extends StatelessWidget {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            "Gestión de Inventario",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          Text(
            "Próximamente: Control de stock y almacén",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
