import 'package:flutter/material.dart';

class MainMobileLayout extends StatelessWidget {
  final Widget header;
  final Widget bodyContent;
  final Widget bottomNav;

  const MainMobileLayout({
    super.key,
    required this.header,
    required this.bodyContent,
    required this.bottomNav,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: Column(
        children: [
          header,
          Expanded(
            child: bodyContent,
          ),
        ],
      ),
      bottomNavigationBar: bottomNav,
    );
  }
}
