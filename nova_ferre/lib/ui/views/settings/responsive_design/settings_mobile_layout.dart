import 'package:flutter/material.dart';

class SettingsMobileLayout extends StatelessWidget {
  final Widget categoryManagement;

  const SettingsMobileLayout({
    super.key,
    required this.categoryManagement,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Gestión de Categorías",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          categoryManagement,
        ],
      ),
    );
  }
}
