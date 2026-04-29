import 'package:flutter/material.dart';

class DashboardMobileLayout extends StatelessWidget {
  final List<Widget> kpiCards;
  final List<Widget> quickActions;
  final Widget userManagement;

  const DashboardMobileLayout({
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        // Fila de Tarjetas (KPIs) en 1 columna
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: kpiCards.length,
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemBuilder: (context, index) => kpiCards[index],
        ),

        const SizedBox(height: 25),
        const Text(
          "Acciones Rápidas",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        // Botonera de navegación rápida vertical
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: quickActions.map((action) => Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: action,
          )).toList(),
        ),

        const SizedBox(height: 25),
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
