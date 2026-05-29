import 'dart:math' as math;
import 'package:flutter/material.dart';

class BurstParticles extends StatelessWidget {
  final Color color;
  final double scale;
  const BurstParticles({super.key, required this.color, required this.scale});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: _BurstPainter(color: color, progress: (scale - 0.5) / 1.1),
      ),
    );
  }
}

class _BurstPainter extends CustomPainter {
  final Color color;
  final double progress;

  const _BurstPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * progress;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    final paint = Paint()
      ..color = color.withAlpha((opacity * 0.6 * 255).toInt())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(center, radius, paint);

    const count = 6;
    final dotPaint = Paint()
      ..color = color.withAlpha((opacity * 255).toInt())
      ..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi;
      final dx = center.dx + radius * math.cos(angle);
      final dy = center.dy + radius * math.sin(angle);
      canvas.drawCircle(Offset(dx, dy), 2.5 * (1 - progress * 0.5), dotPaint);
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.progress != progress;
}
