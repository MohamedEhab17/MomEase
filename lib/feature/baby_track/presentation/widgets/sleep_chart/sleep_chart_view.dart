import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/date_time_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/baby_track/presentation/models/sleep_chart_item.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/sleep_chart/sleep_bar_chart_painter.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/sleep_chart/sleep_chart_tooltip.dart';

/// Renders the bar-chart canvas, tap-to-select gesture, tooltip overlay,
/// and the x-axis label row directly below.
///
/// Stateless by design – all interactive state lives in [SleepDurationChart].
class SleepChartView extends StatelessWidget {
  const SleepChartView({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.fadeAnimation,
    required this.isWeekly,
    required this.onTapUp,
  });

  final List<SleepChartItem> items;
  final int selectedIndex;
  final Animation<double> fadeAnimation;
  final bool isWeekly;
  final void Function(TapUpDetails, double chartWidth, double barSpacing)
      onTapUp;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double chartWidth = constraints.maxWidth - 28;
        final double barSpacing =
            items.isNotEmpty ? chartWidth / items.length : 1;

        return Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _ChartCanvas(
                  items: items,
                  selectedIndex: selectedIndex,
                  fadeAnimation: fadeAnimation,
                  chartWidth: chartWidth,
                  barSpacing: barSpacing,
                  onTapUp: onTapUp,
                ),
                if (selectedIndex >= 0 && selectedIndex < items.length)
                  _buildTooltip(constraints.maxWidth, barSpacing, context),
              ],
            ),
            SizedBox(height: 12.h),
            _XAxisLabels(
              isWeekly: isWeekly,
              items: items,
            ),
          ],
        );
      },
    );
  }

  /// Positions the tooltip above the selected bar, clamped to screen edges.
  Widget _buildTooltip(
    double maxWidth,
    double barSpacing,
    BuildContext context,
  ) {
    const double tooltipWidth = 148;
    final double barCenterX =
        28 + (selectedIndex * barSpacing) + (barSpacing / 2);
    double left = barCenterX - (tooltipWidth / 2);
    left = left.clamp(4.0, maxWidth - tooltipWidth - 4);

    return Positioned(
      top: -70.h,
      left: left,
      child: SleepChartTooltip(
        item: items[selectedIndex],
      ),
    );
  }
}

// ── Private sub-widgets ──────────────────────────────────────────────────────

class _ChartCanvas extends StatelessWidget {
  const _ChartCanvas({
    required this.items,
    required this.selectedIndex,
    required this.fadeAnimation,
    required this.chartWidth,
    required this.barSpacing,
    required this.onTapUp,
  });

  final List<SleepChartItem> items;
  final int selectedIndex;
  final Animation<double> fadeAnimation;
  final double chartWidth;
  final double barSpacing;
  final void Function(TapUpDetails, double chartWidth, double barSpacing)
      onTapUp;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;

    return GestureDetector(
      onTapUp: (d) => onTapUp(d, chartWidth, barSpacing),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: SizedBox(
          height: 140.h,
          width: double.infinity,
          child: CustomPaint(
            painter: SleepBarChartPainter(
              items: items,
              selectedIndex: selectedIndex,
              primaryDark: colors.primaryDark,
              primaryAccent: colors.primaryAccent,
              gridColor: colors.greyLight,
              poorColor: colors.severityHigh,
            ),
          ),
        ),
      ),
    );
  }
}

/// X-axis label row rendered below the chart canvas.
class _XAxisLabels extends StatelessWidget {
  const _XAxisLabels({
    required this.isWeekly,
    required this.items,
  });

  final bool isWeekly;
  final List<SleepChartItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    final labelStyle = context.text.bodySmall!.copyWith(
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
      color: colors.lightTextSecondary,
    );

    return Padding(
      padding: EdgeInsets.only(left: 28.w),
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: isWeekly
            ? _weeklyLabels(context, labelStyle)
            : _monthlyLabels(context, labelStyle),
      ),
    );
  }

  List<Widget> _weeklyLabels(BuildContext context, TextStyle style) =>
      items.map((item) {
        return Expanded(
          child: Center(
            child: Text(
              item.date.getLocalizedDayName(context),
              style: style,
            ),
          ),
        );
      }).toList();

  List<Widget> _monthlyLabels(BuildContext context, TextStyle style) {
    if (items.isEmpty) return [];
    final int step =
        items.length > 1 ? ((items.length - 1) / 4).round().clamp(1, items.length) : 1;
    return List.generate(5, (i) {
      final itemIndex = (step * i).clamp(0, items.length - 1);
      final item = items[itemIndex];
      return Text(
        item.date.formatChartDate(context),
        style: style,
      );
    });
  }
}
