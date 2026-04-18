import 'package:flutter/material.dart';

class HeaderIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const HeaderIcon({
    super.key,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(
        icon,
        color: isActive ? const Color(0xFFE6683C) : Colors.white,
        size: 24,
      ),
      onPressed: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
