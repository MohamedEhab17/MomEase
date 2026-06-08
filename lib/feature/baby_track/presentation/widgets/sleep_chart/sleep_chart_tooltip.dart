import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/date_time_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/presentation/extensions/sleep_status_extension.dart';
import 'package:new_mama/feature/baby_track/presentation/models/sleep_chart_item.dart';

/// Floating tooltip card shown above a selected bar in the sleep chart.
class SleepChartTooltip extends StatelessWidget {
  const SleepChartTooltip({
    super.key,
    required this.item,
  });

  final SleepChartItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;

    return Card(
      elevation: 6,
      shadowColor: colors.primaryDark.withValues(alpha: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        width: 148.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colors.primaryLighter.withValues(alpha: 100),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.date.formatChartDate(context),
              softWrap: true,
              style: context.text.bodySmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.lightTextSecondary,
              ),
            ),
            4.h.height,
            if (item.sleepHours != null)
              _SleepValueRow(item: item)
            else
              Text(
                context.trContext(TK.babySleepNoData),
                softWrap: true,
                style: context.text.bodySmall!.copyWith(
                  color: colors.lightTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Inline row displaying sleep duration and status badge.
class _SleepValueRow extends StatelessWidget {
  const _SleepValueRow({required this.item});

  final SleepChartItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    final statusColor = item.status.statusColor(context);
    final statusBg = item.status.statusBgColor(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatHours(item.sleepHours!),
          softWrap: true,
          style: context.text.titleSmall!.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.primaryDark,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: statusBg,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            item.status.statusLabel(context),
            softWrap: true,
            style: context.text.bodySmall!.copyWith(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  /// Formats fractional hours into a human-readable string (e.g. "7h 30m").
  String _formatHours(double h) {
    final hours = h.floor();
    final mins = ((h - hours) * 60).round();
    if (hours == 0) return '${mins}m';
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}m';
  }
}
