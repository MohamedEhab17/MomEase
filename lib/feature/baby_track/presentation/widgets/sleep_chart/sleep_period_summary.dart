import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_sleep_records_entity.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/sleep_chart/sleep_metric_item.dart';

/// Period-overview card showing average sleep, logged days, and –
/// in monthly mode – good/poor day breakdowns.
class SleepPeriodSummary extends StatelessWidget {
  const SleepPeriodSummary({
    super.key,
    required this.isWeekly,
    required this.weeklyRecords,
    required this.monthlyRecords,
    required this.formattedAverage,
  });

  final bool isWeekly;
  final WeeklySleepRecordsEntity weeklyRecords;
  final MonthlySleepRecordsEntity monthlyRecords;

  /// Pre-formatted average sleep string (e.g. "7h 30m") so this widget
  /// remains stateless and free of parsing logic.
  final String formattedAverage;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    final dividerColor = colors.primaryLighter.withValues(alpha: 60);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.primaryLighter.withValues(alpha: 20),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.trContext(TK.babySleepPeriodOverview),
            style: context.text.titleSmall!.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.lightTextPrimary,
            ),
          ),
          12.h.height,
          Row(
            children: [
              Expanded(child: _avgSleepMetric(context, colors)),
              Expanded(child: _loggedDaysMetric(context, colors)),
            ],
          ),
          if (!isWeekly) ...[
            12.h.height,
            Divider(height: 1, color: dividerColor),
            12.h.height,
            Row(
              children: [
                Expanded(child: _goodDaysMetric(context, colors)),
                Expanded(child: _poorDaysMetric(context, colors)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _avgSleepMetric(BuildContext context, dynamic colors) =>
      SleepMetricItem(
        icon: Icons.bedtime_rounded,
        label: context.trContext(TK.babySleepAvgSleep),
        value: formattedAverage,
        color: colors.primaryDark,
      );

  Widget _loggedDaysMetric(BuildContext context, dynamic colors) {
    final count = isWeekly
        ? weeklyRecords.totalRecords.toString()
        : monthlyRecords.totalRecords.toString();
    return SleepMetricItem(
      icon: Icons.equalizer_rounded,
      label: context.trContext(TK.babySleepLoggedDays),
      value: context.trContext(
        TK.babySleepDaysSuffix,
        namedArgs: {'count': count},
      ),
      color: colors.primaryAccent,
    );
  }

  Widget _goodDaysMetric(BuildContext context, dynamic colors) =>
      SleepMetricItem(
        icon: Icons.check_circle_outline_rounded,
        label: context.trContext(TK.babySleepGoodDays),
        value: context.trContext(
          TK.babySleepDaysSuffix,
          namedArgs: {'count': monthlyRecords.goodDays.toString()},
        ),
        color: colors.severityMinimal,
      );

  Widget _poorDaysMetric(BuildContext context, dynamic colors) =>
      SleepMetricItem(
        icon: Icons.warning_amber_rounded,
        label: context.trContext(TK.babySleepPoorDays),
        value: context.trContext(
          TK.babySleepDaysSuffix,
          namedArgs: {'count': monthlyRecords.poorDays.toString()},
        ),
        color: colors.severityHigh,
      );
}
