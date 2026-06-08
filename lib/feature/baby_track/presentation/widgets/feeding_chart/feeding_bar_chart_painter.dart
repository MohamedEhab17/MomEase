import 'package:flutter/material.dart';
import 'package:new_mama/feature/baby_track/presentation/models/chart_item.dart';

class FeedingBarChartPainter extends CustomPainter {
  final List<ChartItem> items;
  final int selectedIndex;
  final Color primaryDark;
  final Color primaryAccent;
  final Color gridColor;

  FeedingBarChartPainter({
    required this.items,
    required this.selectedIndex,
    required this.primaryDark,
    required this.primaryAccent,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final maxVal = items.fold<int>(
      0,
      (max, item) => item.timesPerDay > max ? item.timesPerDay : max,
    );
    final double scaleMax = maxVal < 8 ? 8.0 : maxVal.toDouble();

    // Draw background horizontal lines
    final paintGrid = Paint()
      ..color = gridColor.withValues(alpha: 100)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final double chartHeight =
        size.height - 20; // reserve space for bottom labels
    final double step = scaleMax / 4;
    for (int i = 0; i <= 4; i++) {
      final double val = step * i;
      final double y = chartHeight - (val / scaleMax) * chartHeight;
      // Draw grid line
      canvas.drawLine(Offset(25, y), Offset(size.width, y), paintGrid);

      // Draw grid label
      textPainter.text = TextSpan(
        text: val.toInt().toString(),
        style: TextStyle(
          color: gridColor.withValues(alpha: 180),
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 6));
    }

    final double chartWidth = size.width - 25;
    final int count = items.length;
    final double barSpacing = chartWidth / count;
    final double barWidth = count > 10
        ? (barSpacing * 0.6)
        : (barSpacing * 0.4);

    for (int i = 0; i < count; i++) {
      final item = items[i];
      final double barHeight = (item.timesPerDay / scaleMax) * chartHeight;
      final double x = 25 + (i * barSpacing) + (barSpacing - barWidth) / 2;
      final double y = chartHeight - barHeight;

      if (barHeight > 0) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          const Radius.circular(4),
        );

        final isSelected = i == selectedIndex;
        final paint = Paint()
          ..shader = LinearGradient(
            colors: isSelected
                ? [primaryDark, primaryDark.withValues(alpha: 150)]
                : [
                    primaryAccent.withValues(alpha: 160),
                    primaryAccent.withValues(alpha: 80),
                  ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ).createShader(Rect.fromLTWH(x, y, barWidth, barHeight))
          ..style = PaintingStyle.fill;

        canvas.drawRRect(rect, paint);

        // Highlight selected bar outline
        if (isSelected) {
          final strokePaint = Paint()
            ..color = primaryDark
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke;
          canvas.drawRRect(rect, strokePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant FeedingBarChartPainter old) =>
      old.items != items || old.selectedIndex != selectedIndex;
}
