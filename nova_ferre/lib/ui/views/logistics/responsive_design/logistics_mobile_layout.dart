import 'package:flutter/material.dart';
import 'logistics_delivery_card.dart';

class LogisticsMobileLayout extends StatelessWidget {
  final List<dynamic> pendingDeliveries;
  final Function(String idDespacho) onConfirmDelivery;

  const LogisticsMobileLayout({
    super.key,
    required this.pendingDeliveries,
    required this.onConfirmDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return pendingDeliveries.isEmpty
        ? const Center(child: Text("No hay entregas pendientes"))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
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
