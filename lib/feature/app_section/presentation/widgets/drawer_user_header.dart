import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class DrawerUserHeader extends StatelessWidget {
  final Animation<double> animation;

  const DrawerUserHeader({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
    );

    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return AnimatedBuilder(
      animation: curved,
      builder: (context, _) {
        final offsetX = isRTL
            ? 40 * (1 - curved.value)
            : -40 * (1 - curved.value);

        return Transform.translate(
          offset: Offset(offsetX, 0),
          child: Opacity(
            opacity: curved.value.clamp(0.0, 1.0),
            child: Container(
              padding: EdgeInsetsDirectional.only(
                top: MediaQuery.of(context).padding.top + 24.h,
                bottom: 24.h,
                start: 24.w,
                end: 24.w,
              ),
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(30.r),
                  bottomStart: Radius.circular(30.r),
                ),
                gradient: LinearGradient(
                  colors: [
                    context.colors.primary,
                    context.ext.colors.primaryLight,
                  ],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.theme.shadowColor.withAlpha(63),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundImage: const NetworkImage(
                          'https://i.pravatar.cc/150?img=11',
                        ),
                        backgroundColor: context.theme.cardColor,
                      ),
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: context.theme.cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 12.sp,
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ana Soso',
                          style: context.text.displaySmall!.copyWith(
                            color: context.ext.colors.lightTextPrimary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'ana.soso@example.com',
                          style: context.text.titleSmall!.copyWith(
                            color: context.ext.colors.lightTextPrimary,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
