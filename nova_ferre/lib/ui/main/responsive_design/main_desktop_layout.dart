import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nova_ferre/ui/main/nova_ferre_exports.dart';

class MainDesktopLayout extends StatelessWidget {
  final Widget sidebar;
  final Widget header;
  final Widget bodyContent;
  final String? activeOverlay;
  final VoidCallback onCloseOverlay;

  const MainDesktopLayout({
    super.key,
    required this.sidebar,
    required this.header,
    required this.bodyContent,
    this.activeOverlay,
    required this.onCloseOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: Row(
        children: [
          sidebar,
          Expanded(
            child: Column(
              children: [
                header,
                Expanded(
                  child: Stack(
                    children: [
                      IgnorePointer(
                        ignoring: activeOverlay != null,
                        child: bodyContent,
                      ),
                      if (activeOverlay != null) _buildBlurOverlay(),
                      if (activeOverlay != null)
                        Align(
                          alignment: Alignment.topRight,
                          child: SidePanelOverlay(
                            title: activeOverlay!,
                            onClose: onCloseOverlay,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onCloseOverlay,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(color: Colors.black.withValues(alpha: 0.05)),
        ),
      ),
    );
  }
}
