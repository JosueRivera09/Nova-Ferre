import 'package:flutter/material.dart';

class DashboardDesktopLayout extends StatelessWidget {
  final List<Widget> kpiCards;
  final List<Widget> quickActions;
  final Widget userManagement;

  const DashboardDesktopLayout({
    super.key,
    required this.kpiCards,
    required this.quickActions,
    required this.userManagement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Resumen General",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // Fila de Tarjetas (KPIs) en Grid de 3 columnas
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 2.5,
          children: kpiCards,
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
          children: quickActions,
        ),

        const SizedBox(height: 40),
        const Text(
          "Gestión de Usuarios",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        userManagement,
      ],
    );
  }
}
