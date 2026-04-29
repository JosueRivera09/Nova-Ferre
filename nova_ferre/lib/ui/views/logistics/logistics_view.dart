import 'package:nova_ferre/ui/main/nova_ferre_exports.dart';
import 'responsive_design/logistics_desktop_layout.dart';
import 'responsive_design/logistics_mobile_layout.dart';

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
          : LayoutBuilder(
              builder: (context, constraints) {
                void confirmDelivery(String idDespacho) async {
                  final currentContext = context;
                  final ok = await logProvider.markAsDelivered(
                    idDespacho,
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
                }

                if (constraints.maxWidth > 800) {
                  return LogisticsDesktopLayout(
                    pendingDeliveries: logProvider.pendingDeliveries,
                    onConfirmDelivery: confirmDelivery,
                  );
                }
                return LogisticsMobileLayout(
                  pendingDeliveries: logProvider.pendingDeliveries,
                  onConfirmDelivery: confirmDelivery,
                );
              },
            ),
    );
  }
}
