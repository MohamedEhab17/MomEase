import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class VaccineEmptyCard extends StatelessWidget {
  final String message;

  const VaccineEmptyCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 24.h),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: context.ext.colors.primaryLighter.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.vaccines_outlined,
              size: 48.sp,
              color: context.ext.colors.primaryLight,
            ),
            16.h.height,
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.text.bodyLarge!.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
