import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_chart_data_entity.dart';
import 'growth_chart_painter.dart';

/// Renders the line chart canvas for growth data.
class GrowthChartView extends StatelessWidget {
  const GrowthChartView({
    super.key,
    required this.chartData,
    required this.fadeAnimation,
  });

  final GrowthChartDataEntity chartData;
  final Animation<double> fadeAnimation;

  @override
  Widget build(BuildContext context) {
    // Map to (ageInWeeks, value) tuples
    final weightPoints = chartData.weightData
        .map((e) => (e.ageInWeeks, e.value.toDouble()))
        .toList();
    final heightPoints = chartData.heightData
        .map((e) => (e.ageInWeeks, e.value.toDouble()))
        .toList();

    if (weightPoints.isEmpty && heightPoints.isEmpty) {
      return SizedBox(
        height: 160.h,
        child: Center(
          child: Text(
            context.trContext(TK.babySleepNoData),
            style: context.text.bodyMedium!.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final weightColor = context.ext.colors.primaryDark;
    final heightColor = context.ext.colors.primaryAccent;
    final gridColor = context.colors.outlineVariant.withValues(alpha: 0.5);

    return FadeTransition(
      opacity: fadeAnimation,
      child: Column(
        children: [
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: weightColor),
              6.w.width,
              Text(
                context.trContext(TK.babyGrowthWeightKg),
                style: context.text.bodySmall!.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              20.w.width,
              _LegendDot(color: heightColor),
              6.w.width,
              Text(
                context.trContext(TK.babyGrowthHeightCm),
                style: context.text.bodySmall!.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          12.h.height,
          SizedBox(
            height: 160.h,
            width: double.infinity,
            child: CustomPaint(
              painter: GrowthChartPainter(
                weightPoints: weightPoints,
                heightPoints: heightPoints,
                weightColor: weightColor,
                heightColor: heightColor,
                gridColor: gridColor,
                labelColor: context.colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
