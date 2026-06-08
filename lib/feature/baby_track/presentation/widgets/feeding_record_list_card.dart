import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/baby_track/domain/entities/feeding_record_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/delete_confirmation_dialog.dart';

String _feedingFormatDate(DateTime dt) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}, ${dt.year}';
}

class FeedingRecordListCard extends StatelessWidget {
  final FeedingRecordEntity record;
  final VoidCallback onDelete;
  final bool isDeleting;

  const FeedingRecordListCard({
    super.key,
    required this.record,
    required this.onDelete,
    this.isDeleting = false,
  });

  // Future<void> _confirmAndDelete(BuildContext context) async {
  //   final confirm = await showDialog<bool>(
  //     context: context,
  //     builder: (ctx) => DeleteConfirmationDialog(
  //       title: context.trContext(TK.babyFeedingDeleteTitle),
  //       content: context.trContext(TK.babyFeedingDeleteConfirm),
  //     ),
  //   );
  //   if (confirm == true) {
  //     onDelete();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final feedingType = record.feedingType.toLowerCase();

    Color statusColor;
    Color statusBg;
    String statusLabel;
    IconData typeIcon;

    switch (feedingType) {
      case 'normal':
        statusColor = context.ext.colors.greenText;
        statusBg = context.ext.colors.backgroundGreen.withValues(alpha: 0.15);
        statusLabel = 'Normal';
        break;
      case 'obese':
      case 'severeunder':
      case 'severe under':
        statusColor = context.ext.colors.severityHigh;
        statusBg = context.ext.colors.severityHighBg;
        statusLabel = feedingType == 'obese' ? 'Obese' : 'Severe Under';
        break;
      default:
        statusColor = context.ext.colors.primaryDark;
        statusBg = context.ext.colors.primaryExtraLight;
        statusLabel = 'Under';
    }

    final babyType = record.feedingTypeForBaby.toLowerCase();
    if (babyType.contains('breast')) {
      typeIcon = Icons.child_care_rounded;
    } else if (babyType.contains('formula')) {
      typeIcon = Icons.water_drop_rounded;
    } else {
      typeIcon = Icons.restaurant_rounded;
    }

    return Dismissible(
      key: ValueKey(record.recordId),
      direction:  Directionality.of(context) ==  TextDirection.ltr
          ? DismissDirection.endToStart
          :  DismissDirection.startToEnd,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => DeleteConfirmationDialog(
            title: context.trContext(TK.babyFeedingDeleteTitle),
            content: context.trContext(TK.babyFeedingDeleteConfirm),
          ),
        ) ?? false;
      },
      onDismissed: (direction) => onDelete(),
      background: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
          color: context.colors.error,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Icon(
          Icons.delete_forever_rounded,
          color: context.colors.onError,
          size: 24.sp,
        ),
      ),
      child: Skeletonizer(
        enabled: isDeleting,
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: context.colors.outlineVariant.withValues(alpha: 0.4),
              width: 0.8,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Left accent bar + icon ──
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
                      Icon(typeIcon, color: statusColor, size: 22.sp),
                      6.h.height,
                      Text(
                        '${record.feedingTimesPerDay}x',
                        style: context.text.titleSmall!.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        context.trContext(TK.daily),
                        style: context.text.bodySmall!.copyWith(
                          color: statusColor.withValues(alpha: 0.7),
                          fontSize: 9.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Main content ──
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text(
                              record.feedingTypeForBaby,
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
                              _feedingFormatDate(record.feedingDate),
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
                                'Target: ${record.referenceInfo["minTimesPerDay"]}–${record.referenceInfo["maxTimesPerDay"]}x/day',
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
                // Padding(
                //   padding: EdgeInsets.only(right: 8.w),
                //   child: isDeleting
                //       ? Padding(
                //           padding: EdgeInsets.all(12.w),
                //           child: SizedBox(
                //             width: 18.w,
                //             height: 18.w,
                //             child: CircularProgressIndicator(
                //               strokeWidth: 2,
                //               valueColor: AlwaysStoppedAnimation<Color>(
                //                 context.ext.colors.primaryDark,
                //               ),
                //             ),
                //           ),
                //         )
                //       : IconButton(
                //           onPressed: () => _confirmAndDelete(context),
                //           icon: Icon(
                //             Icons.delete_outline_rounded,
                //             color: context.ext.colors.severityHigh,
                //             size: 20.sp,
                //           ),
                //           visualDensity: VisualDensity.compact,
                //         ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
