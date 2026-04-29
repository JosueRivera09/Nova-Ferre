import 'package:flutter/material.dart';
import 'logistics_delivery_card.dart';

class LogisticsDesktopLayout extends StatelessWidget {
  final List<dynamic> pendingDeliveries;
  final Function(String idDespacho) onConfirmDelivery;

  const LogisticsDesktopLayout({
    super.key,
    required this.pendingDeliveries,
    required this.onConfirmDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return pendingDeliveries.isEmpty
        ? const Center(child: Text("No hay entregas pendientes"))
        : GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 500,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 0.9,
            ),
            itemCount: pendingDeliveries.length,
            itemBuilder: (context, index) {
              final delivery = pendingDeliveries[index];
              return LogisticsDeliveryCard(
                delivery: delivery,
                onConfirm: () => onConfirmDelivery(delivery['id_despacho'].toString()),
              );
            },
          );
  }
}
