import 'package:flutter/material.dart';

class SidebarItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final String label;
  final bool isLogout;
  final Function(int) onTap;

  const SidebarItem({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    const accentColor = Color(0xFFE6683C);
    final color = isLogout
        ? Colors.redAccent.withOpacity(0.8)
        : (isSelected ? accentColor : Colors.white60);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => isLogout ? null : onTap(index),
        child: Container(
          decoration: BoxDecoration(
            border: isSelected
                ? const Border(left: BorderSide(color: accentColor, width: 4))
                : null,
            color: isSelected
                ? Colors.white.withOpacity(0.05)
                : Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 15),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
