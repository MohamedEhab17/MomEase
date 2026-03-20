import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class SleepDurationChart extends StatelessWidget {
  final List<double> points; // normalized 0..1
  final List<String> timeLabels;

  const SleepDurationChart({
    super.key,
    required this.points,
    this.timeLabels = const ['8 AM', '12 PM', '4 PM', '12 AM'],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sleep Duration (hrs)',
              style: AppStyles.styleInter14.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextPrimary,
              ),
            ),
            Text(
              'Daily Avg',
              style: AppStyles.styleInter10.copyWith(
                color: AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 80.h,
          child: CustomPaint(
            painter: _LineChartPainter(points: points),
            size: Size(double.infinity, 80.h),
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: timeLabels
              .map(
                (t) => Text(
                  t,
                  style: AppStyles.styleInter10.copyWith(
                    color: AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> points;

  _LineChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < points.length; i++) {
      final x = i * size.width / (points.length - 1);
      final y = size.height - points[i] * size.height * 0.85;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        final prevX = (i - 1) * size.width / (points.length - 1);
        final prevY = size.height - points[i - 1] * size.height * 0.85;
        final cpX1 = prevX + (x - prevX) * 0.5;
        final cpY1 = prevY;
        final cpX2 = prevX + (x - prevX) * 0.5;
        final cpY2 = y;
        path.cubicTo(cpX1, cpY1, cpX2, cpY2, x, y);
        fillPath.cubicTo(cpX1, cpY1, cpX2, cpY2, x, y);
      }
    }

    // Fill gradient under curve
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryDark.withAlpha(50),
          AppColors.primaryDark.withAlpha(0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, gradientPaint);

    // Draw line
    final linePaint = Paint()
      ..color = AppColors.primaryDark
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) => old.points != points;
}
