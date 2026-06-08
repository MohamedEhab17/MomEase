import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/baby_track/domain/entities/growth_statistics_entity.dart';

/// Shows growth metric cards (avg weight, avg height, etc.)
class GrowthStatsSummary extends StatelessWidget {
  const GrowthStatsSummary({super.key, required this.statistics});
  final GrowthStatisticsEntity statistics;

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
            'Growth Overview',
            style: context.text.titleSmall!.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.lightTextPrimary,
            ),
          ),
          12.h.height,
          Row(
            children: [
              Expanded(
                child: _GrowthMetric(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Avg Weight',
                  value: '${statistics.averageWeight.toStringAsFixed(1)} kg',
                  color: colors.primaryDark,
                ),
              ),
              Expanded(
                child: _GrowthMetric(
                  icon: Icons.height_rounded,
                  label: 'Avg Height',
                  value: '${statistics.averageHeight.toStringAsFixed(1)} cm',
                  color: colors.primaryAccent,
                ),
              ),
            ],
          ),
          12.h.height,
          Divider(height: 1, color: dividerColor),
          12.h.height,
          Row(
            children: [
              Expanded(
                child: _GrowthMetric(
                  icon: Icons.trending_up_rounded,
                  label: 'Weight Gain',
                  value: '${statistics.weightGainTotal.toStringAsFixed(1)} kg',
                  color: colors.greenText,
                ),
              ),
              Expanded(
                child: _GrowthMetric(
                  icon: Icons.straighten_rounded,
                  label: 'Height Gain',
                  value: '${statistics.heightGainTotal.toStringAsFixed(1)} cm',
                  color: colors.greenText,
                ),
              ),
            ],
          ),
          12.h.height,
          Divider(height: 1, color: dividerColor),
          12.h.height,
          // Status badge row
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 16.sp, color: colors.primaryDark),
              8.w.width,
              Text(
                'Status: ',
                style: context.text.bodySmall!.copyWith(
                  color: colors.lightTextSecondary,
                ),
              ),
              _StatusBadge(
                status: statistics.currentGrowthStatus,
                colors: colors,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GrowthMetric extends StatelessWidget {
  const _GrowthMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18.sp, color: color),
        ),
        8.w.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: context.text.bodySmall!.copyWith(
                color: context.colors.onSurfaceVariant,
                fontSize: 11.sp,
              ),
            ),
            2.h.height,
            Text(
              value,
              style: context.text.titleSmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colors.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.colors});
  final String status;
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    final lower = status.toLowerCase();
    Color bg;
    Color fg;

    if (lower.contains('normal') || lower.contains('good')) {
      bg = colors.backgroundGreen.withValues(alpha: 0.2);
      fg = colors.greenText;
    } else if (lower.contains('poor') || lower.contains('under') ||
        lower.contains('severe')) {
      bg = colors.severityHighBg;
      fg = colors.severityHigh;
    } else {
      bg = colors.primaryExtraLight;
      fg = colors.primaryDark;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: context.text.bodySmall!.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}
