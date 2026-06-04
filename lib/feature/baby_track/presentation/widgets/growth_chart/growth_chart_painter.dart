import 'package:flutter/material.dart';

/// Paints two lines (weight & height) on a single canvas.
class GrowthChartPainter extends CustomPainter {
  final List<double> weightValues;
  final List<double> heightValues;
  final Color weightColor;
  final Color heightColor;
  final Color gridColor;
  final Color labelColor;
  final double strokeWidth;

  GrowthChartPainter({
    required this.weightValues,
    required this.heightValues,
    required this.weightColor,
    required this.heightColor,
    required this.gridColor,
    required this.labelColor,
    this.strokeWidth = 2.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (weightValues.isEmpty && heightValues.isEmpty) return;

    const paddingLeft = 8.0;
    const paddingRight = 8.0;
    const paddingTop = 8.0;
    const paddingBottom = 8.0;

    final chartW = size.width - paddingLeft - paddingRight;
    final chartH = size.height - paddingTop - paddingBottom;

    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 4; i++) {
      final y = paddingTop + (chartH / 4) * i;
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );
    }

    _drawLine(canvas, weightValues, chartW, chartH, paddingLeft, paddingTop,
        weightColor);
    _drawLine(canvas, heightValues, chartW, chartH, paddingLeft, paddingTop,
        heightColor);
  }

  void _drawLine(
    Canvas canvas,
    List<double> values,
    double chartW,
    double chartH,
    double paddingLeft,
    double paddingTop,
    Color color,
  ) {
    if (values.length < 2) return;

    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal).abs();
    final step = chartW / (values.length - 1);

    final path = Path();
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < values.length; i++) {
      final x = paddingLeft + step * i;
      final normalized = range < 0.001 ? 0.5 : (values[i] - minVal) / range;
      final y = paddingTop + chartH * (1 - normalized);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        // Smooth bezier
        final prevX = paddingLeft + step * (i - 1);
        final prevNorm = range < 0.001 ? 0.5 : (values[i - 1] - minVal) / range;
        final prevY = paddingTop + chartH * (1 - prevNorm);
        final cpX = (prevX + x) / 2;
        path.cubicTo(cpX, prevY, cpX, y, x, y);
      }

      // Draw dot
      canvas.drawCircle(Offset(x, y), 3.5, dotPaint);
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(GrowthChartPainter old) =>
      old.weightValues != weightValues ||
      old.heightValues != heightValues ||
      old.weightColor != weightColor ||
      old.heightColor != heightColor;
}
