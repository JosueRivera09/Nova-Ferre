import 'package:flutter/material.dart';

class SettingsDesktopLayout extends StatelessWidget {
  final Widget categoryManagement;

  const SettingsDesktopLayout({
    super.key,
    required this.categoryManagement,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Gestión de Categorías",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              categoryManagement,
            ],
          ),
        ),
      ),
    );
  }
}
