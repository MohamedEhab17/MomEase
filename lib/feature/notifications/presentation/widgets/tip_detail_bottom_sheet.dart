import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';

class TipDetailBottomSheet extends StatelessWidget {
  const TipDetailBottomSheet({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  static Future<void> show(BuildContext context, {required String title, required String body}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TipDetailBottomSheet(title: title, body: body),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = context.ext.colors;
    final primaryColor = themeColors.primaryDark;

    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 36.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 48.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: context.colors.onSurface.withAlpha(30),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          24.h.height,

          // Glowing Icon Header
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: themeColors.primaryLighter.withAlpha(77),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.spa_rounded,
              size: 40.r,
              color: primaryColor,
            ),
          ),
          16.h.height,

          // Localized Title
          Text(
            title,
            style: context.text.headlineMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          12.h.height,

          // Tip Body Content
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest.withAlpha(51),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: context.colors.onSurface.withAlpha(15),
              ),
            ),
            child: Text(
              body,
              style: context.text.titleSmall!.copyWith(
                color: context.colors.onSurface.withAlpha(217),
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          32.h.height,

          // Call to Action Buttons
          Column(
            children: [
              CustomElevatedButton(
                text: context.isAr ? 'تقييم الصحة النفسية' : 'Mental Health Check',
                onPressed: () {
                  context.pop(); // Close bottom sheet
                  context.push(AppRoutesPaths.depressionTestOptionsView);
                },
                backgroundColor: primaryColor,
                minimumSize: Size(double.infinity, 50.h),
              ),
              12.h.height,
              CustomElevatedButton(
                text: context.isAr ? 'إغلاق' : 'Close',
                onPressed: () => context.pop(),
                backgroundColor: Colors.transparent,
                borderColor: primaryColor,
                textColor: primaryColor,
                elevation: 0,
                minimumSize: Size(double.infinity, 50.h),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
