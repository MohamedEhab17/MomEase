import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class CountBadge extends StatelessWidget {
  final int count;
  final BuildContext context;

  const CountBadge({super.key, required this.count, required this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: context.ext.colors.primaryLighter.withAlpha(89),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: context.text.bodySmall!.copyWith(
          color: context.ext.colors.primaryDark,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
