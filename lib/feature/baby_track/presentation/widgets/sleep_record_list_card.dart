import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_record_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

String _sleepFormatDate(DateTime dt) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}, ${dt.year}';
}

/// Parses "HH:mm:ss" into readable "Xh Ym"
String _formatDuration(String raw) {
  try {
    final parts = raw.split(':');
    final h = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  } catch (_) {
    return raw;
  }
}

class SleepRecordListCard extends StatelessWidget {
  final SleepRecordEntity record;
  final VoidCallback onDelete;
  final bool isDeleting;

  const SleepRecordListCard({
    super.key,
    required this.record,
    required this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = record.status.toLowerCase();

    Color statusColor;
    Color statusBg;
    String statusLabel;

    if (statusText == 'good' || statusText == 'normal' || statusText == 'healthy') {
      statusColor = context.ext.colors.greenText;
      statusBg = context.ext.colors.backgroundGreen.withValues(alpha: 0.15);
      statusLabel = 'Good';
    } else {
      statusColor = context.ext.colors.severityHigh;
      statusBg = context.ext.colors.severityHighBg;
      statusLabel = 'Poor';
    }

    final duration = record.sleepHoursTotalFormatted.isNotEmpty
        ? record.sleepHoursTotalFormatted
        : _formatDuration(record.sleepHoursTotal);

    return Skeletonizer(
      enabled: isDeleting,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: context.colors.outlineVariant.withValues(alpha: 0.4),
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            // ── Left accent panel ──
            Container(
              width: 64.w,
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 18.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.nights_stay_rounded,
                    color: statusColor,
                    size: 22.sp,
                  ),
                  6.h.height,
                  Text(
                    duration,
                    style: context.text.titleSmall!.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 11.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // ── Main content ──
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sleep Record',
                          style: context.text.titleSmall!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colors.onSurface,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            statusLabel,
                            style: context.text.bodySmall!.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    4.h.height,
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 11.sp,
                          color: context.colors.onSurfaceVariant,
                        ),
                        4.w.width,
                        Text(
                          _sleepFormatDate(record.sleepDate),
                          style: context.text.bodySmall!.copyWith(
                            color: context.colors.onSurfaceVariant,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                    if (record.referenceInfo != null) ...[
                      6.h.height,
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 11.sp,
                            color: context.colors.onSurfaceVariant,
                          ),
                          4.w.width,
                          Text(
                            'Target: ${record.referenceInfo!.sleepMinHoursFormatted}–${record.referenceInfo!.sleepMaxHoursFormatted} (${record.referenceInfo!.ageRange})',
                            style: context.text.bodySmall!.copyWith(
                              color: context.colors.onSurfaceVariant,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (record.notes.trim().isNotEmpty) ...[
                      6.h.height,
                      Text(
                        record.notes,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.bodySmall!.copyWith(
                          color: context.colors.onSurfaceVariant.withValues(alpha: 0.7),
                          fontStyle: FontStyle.italic,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── Delete button ──
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: isDeleting
                  ? Padding(
                      padding: EdgeInsets.all(12.w),
                      child: SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            context.ext.colors.primaryDark,
                          ),
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: context.ext.colors.severityHigh,
                        size: 20.sp,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
