import 'package:nova_ferre/nova_ferre_exports.dart';

class SalesView extends StatelessWidget {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // --- COLUMNA IZQUIERDA: CATÁLOGO (Flex 3) ---
        Expanded(
          flex: 3,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Buscador de Productos (Próximamente)",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Expanded(child: Center(child: Text("Grid de Productos"))),
              ],
            ),
          ),
        ),

        // --- DIVISOR VISUAL (Línea sutil) ---
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: Colors.grey.withOpacity(0.2),
        ),

        // --- COLUMNA DERECHA: CARRITO Y COBRO (Flex 2) ---
        Expanded(
          flex: 2,
          child: Container(
            // Un fondo ligeramente distinto para resaltar el área de cobro
            color: Theme.of(context).cardColor.withOpacity(0.5),
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "RESUMEN DE VENTA",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(child: Text("Lista de productos en carrito")),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("Sección de Totales y Botón Cobrar"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
