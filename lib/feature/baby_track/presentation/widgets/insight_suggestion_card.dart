import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class InsightSuggestionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const InsightSuggestionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: context.ext.colors.primaryTint,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: context.ext.colors.primaryExtraLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: context.ext.colors.primaryDark.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: context.ext.colors.primaryDark,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.text.titleSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  body,
                  style: context.text.bodyLarge!.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  child: Text(
                    'Read more ›',
                    style: context.text.bodyLarge!.copyWith(
                      color: context.ext.colors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
