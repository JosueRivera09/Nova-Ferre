import 'package:flutter/material.dart';
import 'package:nova_ferre/ui/main/nova_ferre_exports.dart';

class InventoryMobileLayout extends StatelessWidget {
  final List<ProductModel> products;
  final Function(ProductModel) onEdit;

  const InventoryMobileLayout({
    super.key,
    required this.products,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return products.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("No se encontraron productos"),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              bool isLowStock = p.stock <= 5;

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Encabezado del Card: Nombre y Botón de Editar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              p.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey),
                            onPressed: () => onEdit(p),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.descripcion ?? "Sin descripción",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Divider(height: 20),
                      // Filas de Detalles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDetailCol("Código", p.id),
                          _buildDetailCol(
                            "Stock",
                            "${p.stock.toInt()}",
                            color: isLowStock ? Colors.red : Colors.green,
                          ),
                          _buildDetailCol(
                            "Precio",
                            "\$${p.precioVenta.toStringAsFixed(2)}",
                            color: const Color(0xFFE6683C),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Estado y Motivo
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: p.estado
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              p.estado ? "Activo" : "Inactivo",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: p.estado ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (!p.estado)
                            Expanded(
                              child: Text(
                                p.motivoInactivo ?? "Sin motivo",
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildDetailCol(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
