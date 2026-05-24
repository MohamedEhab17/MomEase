import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';

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
              context.trContext(TK.babyFeedingFrequency),
              style: context.text.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: context.ext.colors.lightTextPrimary,
              ),
            ),
            Text(
              context.trContext(TK.babyLast7Days),
              style: context.text.bodyMedium!.copyWith(
                color: context.ext.colors.lightTextSecondary,
              ),
            ),
          ],
        ),
        12.h.height,
        SizedBox(
          height: 120.h,
          child: CustomPaint(
            painter: _BarChartPainter(
              context: context,
              data: data,
              primaryDark: context.ext.colors.primaryDark,
              primaryLighter: context.ext.colors.primaryLighter,
            ),
            size: Size(double.infinity, 120.h),
          ),
        ),
        6.h.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dayLabels
              .map((d) => Text(d, style: context.text.bodyMedium!))
              .toList(),
        ),
      ],
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> data;

  final Color primaryDark;
  final Color primaryLighter;
  final BuildContext context;

  _BarChartPainter({
    required this.context,
    required this.data,
    required this.primaryDark,
    required this.primaryLighter,
  });

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
            ? context.ext.colors.primaryDark
            : context.ext.colors.primaryLighter.withAlpha(180)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) => old.data != data;
}
