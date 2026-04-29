import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String sku;
  final String name;
  final double price;
  final String category;
  final bool isActive;
  final bool isGridView;
  final VoidCallback onAdd;
  final double stock;

  const ProductCard({
    super.key,
    required this.sku,
    required this.name,
    required this.price,
    required this.category,
    this.isActive = true,
    required this.isGridView,
    required this.onAdd,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    // Lógica de iconos por categoría
    IconData categoryIcon = Icons.handyman_outlined;
    Color categoryColor = Colors.blueGrey;

    if (category == 'Pintura') {
      categoryIcon = Icons.format_paint_outlined;
      categoryColor = Colors.blue;
    } else if (category == 'Herramientas') {
      categoryIcon = Icons.build_outlined;
      categoryColor = Colors.orange;
    }

    if (isGridView) {
      return _buildGridCard(categoryIcon, categoryColor);
    } else {
      return _buildListTile(categoryIcon, categoryColor);
    }
  }

  Widget _buildGridCard(IconData icon, Color color) {
    bool isLowStock = stock < 10;

    return Opacity(
      opacity: isActive ? 1.0 : 0.5,
      child: Card(
        elevation: 0,
        color: isLowStock ? Colors.orange.shade50 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isLowStock
                ? Colors.orange.shade300
                : Colors.grey.withValues(alpha: 0.2),
          ),
        ),
        child: InkWell(
          onTap: isActive ? onAdd : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  sku,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Stock: ${stock.toInt()}",
                    style: TextStyle(
                      color: isLowStock ? Colors.orange.shade800 : Colors.blueGrey,
                      fontWeight: isLowStock ? FontWeight.bold : FontWeight.normal,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE6683C),
                      ),
                    ),
                    if (isActive)
                      const Icon(
                        Icons.add_circle_outline,
                        color: Colors.grey,
                        size: 30,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, Color color) {
    bool isLowStock = stock < 10;

    return Opacity(
      opacity: isActive ? 1.0 : 0.5,
      child: Container(
        color: isLowStock ? Colors.orange.shade50 : null,
        child: ListTile(
          onTap: isActive ? onAdd : null,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sku, style: const TextStyle(fontSize: 12)),
              Text(
                "Stock: ${stock.toInt()}",
                style: TextStyle(
                  color: isLowStock ? Colors.orange.shade800 : Colors.blueGrey,
                  fontWeight: isLowStock ? FontWeight.bold : FontWeight.normal,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          trailing: Text(
            "\$${price.toStringAsFixed(2)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFE6683C),
            ),
          ),
        ),
      ),
    );
  }
}
