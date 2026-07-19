import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: context.ext.colors.primaryDark, width: 3),
        ),
        child: Icon(icon, size: size, color: context.ext.colors.primaryDark),
      ),
    );
  }
}
