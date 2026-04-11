import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class VaccineProgressHeader extends StatelessWidget {
  final int completed;
  final int total;
  final String nextDueDate;
  final int daysUntilDue;

  const VaccineProgressHeader({
    super.key,
    required this.completed,
    required this.total,
    required this.nextDueDate,
    required this.daysUntilDue,
  });

  @override
  Widget build(BuildContext context) {
    final progress = completed / total;
    final percentage = (progress * 100).round();

    return Container(
      padding: 16.allPadding,
      decoration: BoxDecoration(
        color: context.ext.colors.primaryTint,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.ext.colors.primaryExtraLight),
      ),
      child: Row(
        crossAxisAlignment: .center,
        mainAxisAlignment: .start,

        children: [
          // Completed stats
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text('Completed:', style: context.text.bodyMedium!),
                4.h.height,
                Row(
                  crossAxisAlignment: .baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$completed/$total',
                      style: context.text.displaySmall!.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    10.width,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: context.ext.colors.primaryDark,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '$percentage%',
                        style: context.text.bodySmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                8.h.height,
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6.h,
                    backgroundColor: context.theme.cardColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.ext.colors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          20.w.width,
          // Divider
          SizedBox(
            height: 60.h,
            child: VerticalDivider(
              color: context.ext.colors.primaryLight,
              thickness: 1.w,
            ),
          ),

          SizedBox(width: 20.w),
          // Next due
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'Next Due',
                style: context.text.bodyLarge!.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                nextDueDate,
                style: context.text.displaySmall!.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'In $daysUntilDue days',
                style: context.text.bodyLarge!.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
