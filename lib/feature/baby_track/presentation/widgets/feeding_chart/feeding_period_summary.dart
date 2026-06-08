import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/domain/entities/monthly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/weekly_feeding_records_entity.dart';
import 'package:new_mama/feature/baby_track/presentation/models/chart_item.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/sleep_chart/sleep_metric_item.dart';

/// Displays the period-overview card (average feeding, logged days, and
/// – in monthly mode – normal/abnormal breakdown).
class FeedingPeriodSummary extends StatelessWidget {
  const FeedingPeriodSummary({
    super.key,
    required this.isWeekly,
    required this.weeklyRecords,
    required this.monthlyRecords,
    required this.items,
  });

  final bool isWeekly;
  final WeeklyFeedingRecordsEntity weeklyRecords;
  final MonthlyFeedingRecordsEntity monthlyRecords;
  final List<ChartItem> items;

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
              Expanded(child: _avgFeedingMetric(context, colors)),
              Expanded(child: _loggedDaysMetric(context, colors)),
            ],
          ),
          if (!isWeekly) ...[
            12.h.height,
            Divider(height: 1, color: dividerColor),
            12.h.height,
            Row(
              children: [
                Expanded(child: _normalDaysMetric(context, colors)),
                Expanded(child: _abnormalDaysMetric(context, colors)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _avgFeedingMetric(BuildContext context, dynamic colors) {
    final value = isWeekly
        ? context.trContext(
            TK.babyFeedingTimesPerDaySuffix,
            namedArgs: {'count': weeklyRecords.weeklyAverage.toStringAsFixed(1)},
          )
        : context.trContext(
            TK.babyFeedingTimesPerDaySuffix,
            namedArgs: {
              'count': monthlyRecords.monthlyAverageTimesPerDay.toStringAsFixed(1),
            },
          );
    return SleepMetricItem(
      icon: Icons.date_range_rounded,
      label: context.trContext(TK.babyFeedingAvgFeeding),
      value: value,
      color: colors.primaryDark,
    );
  }

  Widget _loggedDaysMetric(BuildContext context, dynamic colors) {
    final count = isWeekly
        ? '${items.where((i) => i.timesPerDay > 0).length}'
        : '${monthlyRecords.totalRecords}';
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

  Widget _normalDaysMetric(BuildContext context, dynamic colors) => SleepMetricItem(
        icon: Icons.check_circle_outline_rounded,
        label: context.trContext(TK.babyFeedingNormalDays),
        value: context.trContext(
          TK.babySleepDaysSuffix,
          namedArgs: {'count': '${monthlyRecords.normalDays}'},
        ),
        color: colors.severityMinimal,
      );

  Widget _abnormalDaysMetric(BuildContext context, dynamic colors) => SleepMetricItem(
        icon: Icons.warning_amber_rounded,
        label: context.trContext(TK.babyFeedingAbnormalDays),
        value: context.trContext(
          TK.babySleepDaysSuffix,
          namedArgs: {'count': '${monthlyRecords.abnormalDays}'},
        ),
        color: colors.severityHigh,
      );
}
