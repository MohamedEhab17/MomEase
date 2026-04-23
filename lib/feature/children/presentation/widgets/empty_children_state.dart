import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';

class EmptyChildrenState extends StatelessWidget {
  final VoidCallback onAdd;
  const EmptyChildrenState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: context.ext.colors.lightBackground,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.ext.colors.primaryTint.withValues(alpha: 100),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Text('👶', style: TextStyle(fontSize: 60.sp)),
          ),
          32.height,
          Text(
            context.trContext(TK.childrenNoBabiesYet),
            style: context.text.headlineSmall!.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          16.height,
          Text(
            context.trContext(TK.childrenAddFirstBabySubtitle),
            style: context.text.bodyLarge!.copyWith(
              color: context.ext.colors.lightTextSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          48.height,
          ElevatedButton.icon(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.ext.colors.primaryDark,
              foregroundColor: context.colors.onPrimary,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              elevation: 4,
              shadowColor: context.ext.colors.primaryDark.withValues(alpha: 150),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.r),
              ),
            ),
            icon: Icon(Icons.favorite_rounded, size: 20.sp),
            label: Text(
              context.trContext(TK.childrenAddYourBaby),
              style: context.text.titleMedium!.copyWith(
                color: context.colors.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
