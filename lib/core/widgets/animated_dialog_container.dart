import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';

class AnimatedDialogContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  const AnimatedDialogContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: MediaQuery.of(context).viewInsets,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight * 0.85,
                ),
                margin: margin ?? EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: borderRadius ?? BorderRadius.circular(40.r),
                  border: Border.all(color: AppColors.primarySoft5, width: 1),
                ),
                child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  child: Padding(
                    padding:
                        padding ??
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 36.h),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
