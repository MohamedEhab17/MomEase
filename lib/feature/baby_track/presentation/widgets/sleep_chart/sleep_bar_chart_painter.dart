import 'package:flutter/material.dart';
import 'sleep_chart_item.dart';

class SleepBarChartPainter extends CustomPainter {
  final List<SleepChartItem> items;
  final int selectedIndex;
  final Color primaryDark;
  final Color primaryAccent;
  final Color gridColor;
  final Color poorColor;

  SleepBarChartPainter({
    required this.items,
    required this.selectedIndex,
    required this.primaryDark,
    required this.primaryAccent,
    required this.gridColor,
    required this.poorColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final double maxVal = items
        .where((i) => i.sleepHours != null)
        .fold<double>(8.0, (m, i) => i.sleepHours! > m ? i.sleepHours! : m);
    final double scaleMax = maxVal < 8 ? 8.0 : maxVal;

    // Grid lines
    final paintGrid = Paint()
      ..color = gridColor.withValues(alpha: 100)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final double chartHeight = size.height - 20;
    final double step = scaleMax / 4;

    for (int i = 0; i <= 4; i++) {
      final double val = step * i;
      final double y = chartHeight - (val / scaleMax) * chartHeight;
      canvas.drawLine(Offset(28, y), Offset(size.width, y), paintGrid);

      textPainter.text = TextSpan(
        text: '${val.toInt()}h',
        style: TextStyle(
          color: gridColor.withValues(alpha: 180),
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 6));
    }

    final double chartWidth = size.width - 28;
    final int count = items.length;
    final double barSpacing = chartWidth / count;
    final double barWidth = count > 10 ? (barSpacing * 0.6) : (barSpacing * 0.4);

    for (int i = 0; i < count; i++) {
      final item = items[i];
      if (item.sleepHours == null) continue;

      final double barHeight = (item.sleepHours! / scaleMax) * chartHeight;
      final double x = 28 + (i * barSpacing) + (barSpacing - barWidth) / 2;
      final double y = chartHeight - barHeight;

      if (barHeight > 0) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          const Radius.circular(4),
        );

        final isSelected = i == selectedIndex;
        final isPoor = item.status.toLowerCase() == 'poor';

        final Color barColor = isPoor ? poorColor : primaryDark;
        final Color barColorLight =
            isPoor ? poorColor.withValues(alpha: 130) : primaryAccent;

        final paint = Paint()
          ..shader = LinearGradient(
            colors: isSelected
                ? [barColor, barColor.withValues(alpha: 150)]
                : [barColorLight, barColorLight.withValues(alpha: 80)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ).createShader(Rect.fromLTWH(x, y, barWidth, barHeight))
          ..style = PaintingStyle.fill;

        canvas.drawRRect(rect, paint);

        if (isSelected) {
          final strokePaint = Paint()
            ..color = barColor
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke;
          canvas.drawRRect(rect, strokePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant SleepBarChartPainter old) =>
      old.items != items || old.selectedIndex != selectedIndex;
}
