import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class DrawerItemGroup extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const DrawerItemGroup({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
            child: Text(
              title!.toUpperCase(),
              style: context.theme.textTheme.titleLarge!.copyWith(
                fontSize: 12.sp,
                color: context.ext.colors.lightTextSecondary, // Light grey text
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: context.theme.shadowColor.withAlpha(5),
                blurRadius: 10,
                spreadRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
