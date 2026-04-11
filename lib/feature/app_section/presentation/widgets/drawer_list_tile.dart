import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';

class DrawerListTile extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
  final double? fontSize;

  const DrawerListTile({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.onTap,
    this.titleColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Row(
          children: [
            if (leading != null) ...[leading!, 16.w.width],
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: titleColor ?? Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize ?? 16.sp,
                ),
              ),
            ),
            if (trailing != null) ...[8.w.width, trailing!],
          ],
        ),
      ),
    );
  }
}
