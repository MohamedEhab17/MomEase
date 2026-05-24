import 'dart:ui';
import 'package:flutter/material.dart';

class DrawerBackdrop extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onTap;

  const DrawerBackdrop({
    super.key,
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        if (animation.value == 0) return const SizedBox.shrink();
        return Positioned.fill(
          child: GestureDetector(
            onTap: onTap,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5 * animation.value,
                sigmaY: 5 * animation.value,
              ),
              child: Container(
                // 0.3 opacity  → 0.3 * 255 ≈ 76
                color: Colors.black.withAlpha((76 * animation.value).round()),
              ),
            ),
          ),
        );
      },
    );
  }
}
