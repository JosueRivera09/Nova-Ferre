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
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: logProvider.pendingDeliveries.length,
                  itemBuilder: (context, index) {
                    final delivery = logProvider.pendingDeliveries[index];
                    final venta = delivery['ventas'];
                    
                    final date = DateTime.tryParse(venta['fecha_venta'] ?? '') ?? DateTime.now();
                    final formattedDate = "${date.day}/${date.month}/${date.year} a las ${date.hour}:${date.minute.toString().padLeft(2, '0')}";

                    final List detalles = venta['detalle_ventas'] ?? [];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ticket: ${delivery['id_venta']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                const Chip(
                                  label: Text(
                                    "PENDIENTE",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Color(0xFFFFF3E0),
                                  side: BorderSide.none,
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, color: Colors.blueGrey, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  venta['cliente_nombre'] ?? "Cliente General",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Productos:",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: detalles.map((detalle) {
                                  final cantidad = detalle['cantidad'];
                                  final nombre = detalle['productos']?['nombre_articulo'] ?? 'Desconocido';
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 6.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${cantidad.toInt()}x ",
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE6683C)),
                                        ),
                                        Expanded(child: Text(nombre)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Total: \$${venta['total']}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6683C),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.local_shipping_outlined, color: Colors.white),
                              label: const Text(
                                "CONFIRMAR ENTREGA",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE6683C),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () async {
                                final currentContext = context;
                                final ok = await logProvider.markAsDelivered(
                                  delivery['id_despacho'],
                                  authProvider.user!.id,
                                );
                                if (ok && currentContext.mounted) {
                                  currentContext.read<DashboardProvider>().fetchMetrics();
                                  CustomNotification.show(
                                    currentContext, 
                                    "Pedido entregado correctamente", 
                                    isSuccess: true,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
