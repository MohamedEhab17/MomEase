import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/baby_track/data/models/baby_track_models.dart';

class VaccineRecordCard extends StatelessWidget {
  final VaccineRecord record;
  final int animationIndex;

  const VaccineRecordCard({
    super.key,
    required this.record,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = record.status == VaccineStatus.completed;

    return Container(
      margin: 16.bottomPadding,
      padding: 16.allPadding,
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: context.colors.onSurface.withAlpha(38),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: icon circle
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: isCompleted
                  ? context.ext.colors.backgroundGreen.withAlpha(40)
                  : context.ext.colors.primaryExtraLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted
                  ? Icons.medical_services_rounded
                  : Icons.vaccines_rounded,
              size: 18.sp,
              color: isCompleted
                  ? context.ext.colors.greenText
                  : context.ext.colors.primaryDark,
            ),
          ),
          SizedBox(width: 12.w),
          // Middle: text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.name,
                  style: context.text.titleSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  record.doseInfo,
                  style: context.text.bodyLarge!.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // Right: status badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isCompleted
                  ? context.ext.colors.backgroundGreen.withAlpha(40)
                  : context.ext.colors.primaryExtraLight,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              isCompleted ? 'Completed' : 'Upcoming',
              style: context.text.bodySmall!.copyWith(
                color: isCompleted
                    ? context.ext.colors.greenText
                    : context.ext.colors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
