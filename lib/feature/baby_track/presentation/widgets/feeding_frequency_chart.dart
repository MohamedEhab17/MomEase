import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class FeedingFrequencyChart extends StatelessWidget {
  final List<double> data; // 7 values, one per day
  final List<String> dayLabels;

  const FeedingFrequencyChart({
    super.key,
    required this.data,
    this.dayLabels = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
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
              'Feeding Frequency',
              style: AppStyles.styleInter14.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextPrimary,
              ),
            ),
            Text(
              'Last 7 Days',
              style: AppStyles.styleInter10.copyWith(
                color: AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 120.h,
          child: CustomPaint(
            painter: _BarChartPainter(data: data),
            size: Size(double.infinity, 120.h),
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dayLabels
              .map(
                (d) => Text(
                  d,
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

class _BarChartPainter extends CustomPainter {
  final List<double> data;

  _BarChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final barWidth = size.width / (data.length * 2);
    final gap = barWidth;

    final highlightIndex = data.indexOf(maxValue);

    for (int i = 0; i < data.length; i++) {
      final barHeight =
          (data[i] / (maxValue == 0 ? 1 : maxValue)) * size.height * 0.85;
      final x = gap / 2 + i * (barWidth + gap);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight),
        const Radius.circular(6),
      );

      final isHighlighted = i == highlightIndex;
      final paint = Paint()
        ..color = isHighlighted
            ? AppColors.primaryDark
            : AppColors.primaryLighter.withAlpha(180)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) => old.data != data;
}
