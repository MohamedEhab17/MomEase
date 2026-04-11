import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class AccountActionItemTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String? trailingText;
  final VoidCallback? onTap;

  const AccountActionItemTile({
    super.key,
    required this.title,
    required this.iconData,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        padding: 16.w.allPadding,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.ext.colors.lighterBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(iconData, color: iconColor, size: 20),
            ),
            12.width,
            Expanded(
              child: Text(
                title,
                style: context.text.titleSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface.withAlpha(200),
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: context.text.bodyLarge!.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              8.width,
            ],
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: context.colors.onSurfaceVariant.withAlpha(150),
            ),
          ],
        ),
      ),
    );
  }
}
