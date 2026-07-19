import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';

class MoodTrendChart extends StatelessWidget {
  final List<double> points; // normalized 0..1

  const MoodTrendChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.trContext(TK.babyMoodTrend),
          style: context.theme.textTheme.bodyMedium,
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 60.h,
          width: double.infinity,
          child: CustomPaint(
            painter: _MoodLinePainter(
              context: context,
              points: points,
              primaryDark: context.ext.colors.primaryDark,
            ),
          ),
        ),
      ],
    );
  }
}

class _MoodLinePainter extends CustomPainter {
  final List<double> points;

  final Color primaryDark;
  final BuildContext context;

  _MoodLinePainter({
    required this.context,
    required this.points,
    required this.primaryDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < points.length; i++) {
      final x = i * size.width / (points.length - 1);
      final y = size.height - points[i] * size.height * 0.8;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        final prevX = (i - 1) * size.width / (points.length - 1);
        final prevY = size.height - points[i - 1] * size.height * 0.8;
        final cpX = prevX + (x - prevX) * 0.5;
        path.cubicTo(cpX, prevY, cpX, y, x, y);
        fillPath.cubicTo(cpX, prevY, cpX, y, x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          context.ext.colors.primaryDark.withAlpha(40),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, gradientPaint);

    final linePaint = Paint()
      ..color = context.ext.colors.primaryDark
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _MoodLinePainter old) => old.points != points;
}
