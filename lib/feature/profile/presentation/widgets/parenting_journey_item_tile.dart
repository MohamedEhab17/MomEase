import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class ParentingJourneyItemTile extends StatelessWidget {
  final Widget leadingIcon;
  final String title;
  final String statusText;
  final Color statusColor;
  final VoidCallback? onTap;

  const ParentingJourneyItemTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.statusText,
    required this.statusColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Row(
          children: [
            leadingIcon,
            12.horizontalSpace,
            Expanded(
              child: Text(
                title,
                style: context.text.titleSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: context.colors.onSurface.withAlpha(200),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: statusColor.withAlpha(20),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                statusText,
                style: context.text.bodyLarge!.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
