import 'dart:ui';
import 'package:flutter/material.dart';

class LoginDesktopLayout extends StatefulWidget {
  final Widget formWidget;

  const LoginDesktopLayout({
    super.key,
    required this.formWidget,
  });

  @override
  State<LoginDesktopLayout> createState() => _LoginDesktopLayoutState();
}

class _LoginDesktopLayoutState extends State<LoginDesktopLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Animación continua y lenta (66 segundos para completar un ciclo, un 10% más lento)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 66),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2124), // Un fondo oscuro base por si acaso
      body: Stack(
        children: [
          // 1. Fondo con efecto Parallax
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left: -(_controller.value * 2048),
                top: 0,
                bottom: 0,
                child: Row(
                  children: [
                    Image.asset('assets/images/imgPatron.png', width: 2048, fit: BoxFit.cover),
                    Image.asset('assets/images/imgPatron.png', width: 2048, fit: BoxFit.cover),
                  ],
                ),
              );
            },
          ),

          // 2. Efecto de difuminado
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withValues(alpha: 0.2), // Ligero oscurecimiento
              ),
            ),
          ),

          // 3. Tarjeta centrada (Formulario)
          Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color(0xFF2C3136),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: SizedBox(
                  width: 350,
                  child: widget.formWidget,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
