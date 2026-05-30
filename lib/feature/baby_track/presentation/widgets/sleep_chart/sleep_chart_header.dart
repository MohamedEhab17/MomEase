import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/sleep_chart/sleep_toggle_tab.dart';

/// Header row containing the chart title, date-range subtitle,
/// and the weekly/monthly toggle tabs.
class SleepChartHeader extends StatelessWidget {
  const SleepChartHeader({
    super.key,
    required this.isWeekly,
    required this.dateRangeLabel,
    required this.onToggleWeekly,
    required this.onToggleMonthly,
  });

  final bool isWeekly;

  /// Pre-formatted date range string (e.g. "1 Jan – 7 Jan" or month name).
  final String dateRangeLabel;

  final VoidCallback onToggleWeekly;
  final VoidCallback onToggleMonthly;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.trContext(TK.babySleepDuration),
              style: context.text.titleMedium!.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.lightTextPrimary,
              ),
            ),
            4.h.height,
            Text(
              dateRangeLabel,
              style: context.text.bodySmall!.copyWith(
                color: colors.lightTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        _ToggleSwitch(
          isWeekly: isWeekly,
          onToggleWeekly: onToggleWeekly,
          onToggleMonthly: onToggleMonthly,
        ),
      ],
    );
  }
}

/// Segmented toggle (Weekly / Monthly) rendered as a custom pill.
class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({
    required this.isWeekly,
    required this.onToggleWeekly,
    required this.onToggleMonthly,
  });

  final bool isWeekly;
  final VoidCallback onToggleWeekly;
  final VoidCallback onToggleMonthly;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colors.primaryLighter.withValues(alpha: 40),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          SleepToggleTab(
            label: context.trContext(TK.babySleepWeekly),
            isActive: isWeekly,
            onTap: onToggleWeekly,
          ),
          SleepToggleTab(
            label: context.trContext(TK.babySleepMonthly),
            isActive: !isWeekly,
            onTap: onToggleMonthly,
          ),
        ],
      ),
    );
  }
}
