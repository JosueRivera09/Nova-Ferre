import 'package:nova_ferre/nova_ferre_exports.dart';

class LogisticsView extends StatefulWidget {
  const LogisticsView({super.key});

  @override
  State<LogisticsView> createState() => _LogisticsViewState();
}

class _LogisticsViewState extends State<LogisticsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LogisticsProvider>().fetchPendingDeliveries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final logProvider = context.watch<LogisticsProvider>();
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        title: const Text(
          "Despachos Pendientes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: logProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE6683C)),
            )
          : logProvider.pendingDeliveries.isEmpty
          ? const Center(child: Text("No hay entregas pendientes"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logProvider.pendingDeliveries.length,
              itemBuilder: (context, index) {
                final delivery = logProvider.pendingDeliveries[index];
                final venta = delivery['ventas'];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              delivery['id_despacho'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const Chip(
                              label: Text(
                                "PENDIENTE",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.orange,
                                ),
                              ),
                              backgroundColor: Color(0xFFFFF3E0),
                            ),
                          ],
                        ),
                        const Divider(),
                        Text(
                          venta['cliente_nombre'] ?? "Sin nombre",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("Venta: ${delivery['id_venta']}"),
                        Text("Total: \$${venta['total']}"),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE6683C),
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final ok = await logProvider.markAsDelivered(
                              delivery['id_despacho'],
                              authProvider.user!.id,
                            );
                            if (mounted && ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Pedido entregado correctamente",
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "CONFIRMAR ENTREGA",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
