import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_chart_data_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_statistics_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_growth_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_growth_records_entity.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/growth_chart/growth_chart_view.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/growth_chart/growth_stats_summary.dart';

/// Top-level Growth Insights chart widget, inserted into the insights screen.
class GrowthInsightsChart extends StatefulWidget {
  const GrowthInsightsChart({
    super.key,
    required this.chartData,
    required this.statistics,
    required this.weeklyRecords,
    required this.monthlyRecords,
  });

  final GrowthChartDataEntity chartData;
  final GrowthStatisticsEntity statistics;
  final WeeklyGrowthRecordsEntity weeklyRecords;
  final MonthlyGrowthRecordsEntity monthlyRecords;

  @override
  State<GrowthInsightsChart> createState() => _GrowthInsightsChartState();
}

class _GrowthInsightsChartState extends State<GrowthInsightsChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──────────────────────────────────────────────────────────
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: colors.primaryExtraLight,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.child_care_rounded,
                color: colors.primaryDark,
                size: 20.sp,
              ),
            ),
            12.w.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Baby Growth',
                  style: context.text.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.lightTextPrimary,
                  ),
                ),
                Text(
                  'Weight & Height over time',
                  style: context.text.bodySmall!.copyWith(
                    color: colors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        20.h.height,

        // ── Chart ───────────────────────────────────────────────────────────
        GrowthChartView(
          chartData: widget.chartData,
          fadeAnimation: _fadeAnimation,
        ),
        20.h.height,

        // ── Period stats summary ─────────────────────────────────────────
        _GrowthPeriodSummary(
          weeklyRecords: widget.weeklyRecords,
          monthlyRecords: widget.monthlyRecords,
        ),
        16.h.height,

        // ── Full statistics card ─────────────────────────────────────────
        GrowthStatsSummary(statistics: widget.statistics),
      ],
    );
  }
}

/// Compact weekly/monthly gain summary.
class _GrowthPeriodSummary extends StatelessWidget {
  const _GrowthPeriodSummary({
    required this.weeklyRecords,
    required this.monthlyRecords,
  });

  final WeeklyGrowthRecordsEntity weeklyRecords;
  final MonthlyGrowthRecordsEntity monthlyRecords;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    final dividerColor = colors.primaryLighter.withValues(alpha: 60);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.primaryExtraLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TrendItem(
              icon: Icons.date_range_rounded,
              label: 'Weekly Gain',
              weightVal: weeklyRecords.weeklyWeightGain,
              heightVal: weeklyRecords.weeklyHeightGain,
              colors: colors,
              context: context,
            ),
          ),
          Container(width: 1, height: 50.h, color: dividerColor),
          Expanded(
            child: _TrendItem(
              icon: Icons.calendar_month_rounded,
              label: 'Monthly Gain',
              weightVal: monthlyRecords.monthlyWeightGain,
              heightVal: monthlyRecords.monthlyHeightGain,
              colors: colors,
              context: context,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendItem extends StatelessWidget {
  const _TrendItem({
    required this.icon,
    required this.label,
    required this.weightVal,
    required this.heightVal,
    required this.colors,
    required this.context,
  });

  final IconData icon;
  final String label;
  final double weightVal;
  final double heightVal;
  final dynamic colors;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          Icon(icon, size: 18.sp, color: colors.primaryDark),
          6.h.height,
          Text(
            label,
            style: context.text.bodySmall!.copyWith(
              color: colors.lightTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          4.h.height,
          Text(
            '+${weightVal.toStringAsFixed(2)} kg',
            style: context.text.bodySmall!.copyWith(
              color: colors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '+${heightVal.toStringAsFixed(2)} cm',
            style: context.text.bodySmall!.copyWith(
              color: colors.primaryAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
