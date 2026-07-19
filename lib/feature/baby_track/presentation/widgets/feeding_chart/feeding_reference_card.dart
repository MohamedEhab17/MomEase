import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/domain/entities/feeding_statistics_entity.dart';
import 'package:new_mama/core/extensions/feeding_status_extension.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/sleep_chart/sleep_stat_label.dart';

/// Pediatrician / reference card showing recommended range, overall average,
/// most common feeding type, and last-7-days average.
class FeedingReferenceCard extends StatelessWidget {
  const FeedingReferenceCard({
    super.key,
    required this.statistics,
  });

  final FeedingStatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final status = statistics.currentFeedingStatus;
    final statusColor = status.statusColor(context);
    final statusBg = status.statusBgColor(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: statusBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: statusColor.withValues(alpha: 40),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(context, status, statusColor),
          12.h.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SleepStatLabel(
                label: context.trContext(TK.babySleepRecommendedRange),
                value:
                    '${statistics.comparisonWithReference.recommendedMin} - ${statistics.comparisonWithReference.recommendedMax} t/d',
              ),
              SleepStatLabel(
                label: context.trContext(TK.babyFeedingOverallAvg),
                value: '${statistics.averageTimesPerDay.toStringAsFixed(1)} t/d',
              ),
            ],
          ),
          12.h.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SleepStatLabel(
                label: context.trContext(TK.babyFeedingMostCommon),
                value: statistics.mostCommonFeedingType,
              ),
              SleepStatLabel(
                label: context.trContext(TK.babyFeedingLast7DaysAvg),
                value: '${statistics.last7DaysAverage.toStringAsFixed(1)} t/d',
              ),
            ],
          ),
          if (statistics.comparisonWithReference.message.isNotEmpty) ...[
            12.h.height,
            _ReferenceMessageBox(
              message: statistics.comparisonWithReference.message,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCardHeader(
    BuildContext context,
    String status,
    Color statusColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.health_and_safety_rounded,
              color: statusColor,
              size: 20.sp,
            ),
            8.w.width,
            Text(
              context.trContext(TK.babySleepPediatricianRef),
              style: context.text.titleSmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ],
        ),
        _StatusBadge(status: status, statusColor: statusColor),
      ],
    );
  }
}

/// Inline badge showing the feeding status in uppercase.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.statusColor});

  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        status.statusLabel(context).toUpperCase(),
        style: context.text.bodySmall!.copyWith(
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          color: context.theme.cardColor,
        ),
      ),
    );
  }
}

/// The reference/comparison message box shown at the bottom of the card.
class _ReferenceMessageBox extends StatelessWidget {
  const _ReferenceMessageBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: context.theme.cardColor.withValues(alpha: 150),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              message,
              style: context.text.bodySmall!.copyWith(
                color: colors.lightTextPrimary,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
