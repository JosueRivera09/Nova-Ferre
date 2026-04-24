import 'package:nova_ferre/nova_ferre_exports.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchMetrics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dash = context.watch<DashboardProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: RefreshIndicator(
        onRefresh: () => dash.fetchMetrics(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Resumen General",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Fila de Tarjetas (KPIs)
              LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: constraints.maxWidth > 600 ? 3 : 1,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 2.5,
                    children: [
                      _kpiCard(
                        "Ventas de Hoy",
                        "\$${dash.metrics['total_hoy']}",
                        Icons.monetization_on,
                        Colors.green,
                      ),
                      _kpiCard(
                        "Stock Crítico",
                        "${dash.metrics['bajo_stock']} Prod.",
                        Icons.warning_amber_rounded,
                        Colors.red,
                      ),
                      _kpiCard(
                        "Por Despachar",
                        "${dash.metrics['pendientes']} Pedidos",
                        Icons.local_shipping,
                        Colors.orange,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),
              const Text(
                "Acciones Rápidas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Botonera de navegación rápida
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  _quickAction(
                    context,
                    "Nueva Venta",
                    Icons.add_shopping_cart,
                    const SalesView(),
                  ),
                  _quickAction(
                    context,
                    "Ver Inventario",
                    Icons.inventory_2,
                    const InventoryView(),
                  ),
                  _quickAction(
                    context,
                    "Logística",
                    Icons.delivery_dining,
                    const LogisticsView(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kpiCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction(
    BuildContext context,
    String label,
    IconData icon,
    Widget page,
  ) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      onPressed: () {
        // Aquí puedes usar tu sistema de navegación (Router o Navigator)
      },
      icon: Icon(icon, color: const Color(0xFFE6683C)),
      label: Text(label),
    );
  }
}
