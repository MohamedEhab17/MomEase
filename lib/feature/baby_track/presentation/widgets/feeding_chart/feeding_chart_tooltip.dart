import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/presentation/extensions/feeding_status_extension.dart';
import 'package:new_mama/feature/baby_track/presentation/models/chart_item.dart';

/// Floating tooltip card shown above a selected bar in the feeding chart.
class FeedingChartTooltip extends StatelessWidget {
  const FeedingChartTooltip({
    super.key,
    required this.item,
    required this.monthName,
  });

  final ChartItem item;

  /// Pre-resolved localised month name for [item.date.month].
  final String monthName;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    final statusColor = item.status.statusColor(context);
    final statusBg = item.status.statusBgColor(context);

    return Card(
      elevation: 6,
      shadowColor: colors.primaryDark.withValues(alpha: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        width: 145.w,
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
              '${item.date.day} $monthName',
              softWrap: true,
              style: context.text.bodySmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.lightTextSecondary,
              ),
            ),
            4.h.height,
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    child: Text(
                      softWrap: true,
                      context.trContext(
                        TK.babyFeedingTimesSuffix,
                        namedArgs: {'count': '${item.timesPerDay}'},
                      ),
                      style: context.text.titleSmall!.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.primaryDark,
                      ),
                    ),
                  ),
                  if (item.timesPerDay > 0)
                    FittedBox(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: FittedBox(
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
                      ),
                    ),
                ],
              ),
            ),
            if (item.timesPerDay > 0) ...[
              4.h.height,
              Text(
                context.trContext(
                  TK.babyFeedingTypePrefix,
                  namedArgs: {'type': item.primaryFeedingType},
                ),
                softWrap: true,
                style: context.text.bodySmall!.copyWith(
                  fontSize: 10.sp,
                  color: colors.lightTextPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
