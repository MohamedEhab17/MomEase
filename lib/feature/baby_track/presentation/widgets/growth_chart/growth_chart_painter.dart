import 'package:flutter/material.dart';

/// Paints two lines (weight & height) on a single canvas.
/// - Lines drawn with GLOBAL scaling so they appear at different Y positions.
/// - Left axis labels show weight values, right axis labels show height values.
class GrowthChartPainter extends CustomPainter {
  final List<(int, double)> weightPoints;
  final List<(int, double)> heightPoints;
  final Color weightColor;
  final Color heightColor;
  final Color gridColor;
  final Color labelColor;
  final double strokeWidth;

  GrowthChartPainter({
    required this.weightPoints,
    required this.heightPoints,
    required this.weightColor,
    required this.heightColor,
    required this.gridColor,
    required this.labelColor,
    this.strokeWidth = 2.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (weightPoints.isEmpty && heightPoints.isEmpty) return;

    const double paddingLeft = 40.0;
    const double paddingRight = 40.0;
    const double paddingTop = 12.0;
    const double paddingBottom = 12.0;

    final double chartW = size.width - paddingLeft - paddingRight;
    final double chartH = size.height - paddingTop - paddingBottom;

    // ── Shared X axis (ageInWeeks) ──────────────────────────────────────────
    final allWeeks = [
      ...weightPoints.map((p) => p.$1),
      ...heightPoints.map((p) => p.$1),
    ];
    final int xMin = allWeeks.reduce((a, b) => a < b ? a : b);
    final int xMax = allWeeks.reduce((a, b) => a > b ? a : b);
    final double xRange = (xMax - xMin).toDouble();

    double toX(int week) {
      if (xRange < 0.001) return paddingLeft + chartW / 2;
      return paddingLeft + ((week - xMin) / xRange) * chartW;
    }

    // ── GLOBAL Y min/max (so both lines appear at different heights) ─────────
    final allValues = [
      ...weightPoints.map((p) => p.$2),
      ...heightPoints.map((p) => p.$2),
    ];
    final double globalMin = allValues.reduce((a, b) => a < b ? a : b);
    final double globalMax = allValues.reduce((a, b) => a > b ? a : b);
    final double globalRange =
        (globalMax - globalMin).abs() < 0.001 ? 1.0 : globalMax - globalMin;

    // Add a 10% top/bottom margin so dots don't clip the edges
    final double margin = globalRange * 0.1;
    final double displayMin = globalMin - margin < 0 ? 0.0 : globalMin - margin;
    final double displayMax = globalMax + margin;
    final double displayRange = displayMax - displayMin;

    double toY(double val) {
      final double normalized = (val - displayMin) / displayRange;
      return paddingTop + chartH * (1.0 - normalized);
    }

    // ── Draw grid lines ─────────────────────────────────────────────────────
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 4; i++) {
      final double y = paddingTop + (chartH / 4) * i;
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );
    }

    // ── Y-axis labels ───────────────────────────────────────────────────────
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Each grid line corresponds to a value in the global scale.
    // Left side → weight labels (kg), Right side → height labels (cm).
    for (int i = 0; i <= 4; i++) {
      final double y = paddingTop + (chartH / 4) * i;
      // i=0 → top (displayMax), i=4 → bottom (displayMin)
      final double normalized = 1.0 - (i / 4.0);
      final double globalVal = displayMin + normalized * displayRange;

      // Left: weight labels
      if (weightPoints.isNotEmpty) {
        textPainter.text = TextSpan(
          text: globalVal.toStringAsFixed(1),
          style: TextStyle(
            color: weightColor,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            paddingLeft - 4 - textPainter.width,
            y - textPainter.height / 2,
          ),
        );
      }

      // Right: height labels
      if (heightPoints.isNotEmpty) {
        textPainter.text = TextSpan(
          text: globalVal.toStringAsFixed(0),
          style: TextStyle(
            color: heightColor,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            size.width - paddingRight + 4,
            y - textPainter.height / 2,
          ),
        );
      }
    }

    // ── Draw lines (height first so weight appears on top) ──────────────────
    _drawLine(
      canvas: canvas,
      points: heightPoints,
      color: heightColor,
      toX: toX,
      toY: toY,
      dotRadius: 3.5,
      lineWidth: 1.8,
    );
    _drawLine(
      canvas: canvas,
      points: weightPoints,
      color: weightColor,
      toX: toX,
      toY: toY,
      dotRadius: 3.0,
      lineWidth: 2.5,
    );
  }

  void _drawLine({
    required Canvas canvas,
    required List<(int, double)> points,
    required Color color,
    required double Function(int) toX,
    required double Function(double) toY,
    required double dotRadius,
    required double lineWidth,
  }) {
    if (points.isEmpty) return;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (points.length == 1) {
      canvas.drawCircle(
        Offset(toX(points.first.$1), toY(points.first.$2)),
        dotRadius,
        dotPaint,
      );
      return;
    }

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final double x = toX(points[i].$1);
      final double y = toY(points[i].$2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final double prevX = toX(points[i - 1].$1);
        final double prevY = toY(points[i - 1].$2);
        final double cpX = (prevX + x) / 2;
        path.cubicTo(cpX, prevY, cpX, y, x, y);
      }

      canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(GrowthChartPainter old) {
    if (old.weightPoints.length != weightPoints.length) return true;
    if (old.heightPoints.length != heightPoints.length) return true;
    for (int i = 0; i < weightPoints.length; i++) {
      if (old.weightPoints[i] != weightPoints[i]) return true;
    }
    for (int i = 0; i < heightPoints.length; i++) {
      if (old.heightPoints[i] != heightPoints[i]) return true;
    }
    return old.weightColor != weightColor || old.heightColor != heightColor;
  }
}
