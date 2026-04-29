import 'package:flutter/material.dart';

class LoginMobileLayout extends StatelessWidget {
  final Widget formWidget;

  const LoginMobileLayout({
    super.key,
    required this.formWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3136),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: formWidget,
          ),
        ),
      ),
    );
  }
}
