import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';

class ChatbotMessageWidget extends StatelessWidget {
  const ChatbotMessageWidget({
    super.key,
    required this.text,
    required this.alignment,
  });

  final String text;
  final MainAxisAlignment alignment;

  bool get isUser => alignment == MainAxisAlignment.end;

  @override
  Widget build(BuildContext context) {
    final lines = '\n'.allMatches(text).length + 2;
    double calculateRadius() {
      const maxRadius = 64.0;
      const minRadius = 12.0;
      final radius = (maxRadius - (lines) * 12).clamp(minRadius, maxRadius);
      return radius;
    }

    final radius = calculateRadius().r;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isUser ? context.ext.colors.primary : context.ext.colors.primaryLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
            bottomLeft: Radius.circular(radius), // notch
            bottomRight: Radius.circular(radius), // notch
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            if (!isUser) ...[
              SvgPicture.asset(
                AppIcons.iconsLunaBlue,
                width: 24.w,
                height: 24.h,
                colorMapper: AppSvgColorMapper(
                  from: const Color(0xff7AA2C2),
                  to: context.ext.colors.primaryLight,
                ),
              ),
              // Icon(icon, color: AppColors.primary, size: 20.sp),
              SizedBox(width: 8.w),
            ],
            Flexible(
              child: Text(
                text,
                style: context.text.titleLarge!.copyWith(
                  color: isUser
                      ? context.ext.colors.lightBackground
                      : context.ext.colors.lightTextPrimary,
                ).forText(text),
              ),
            ),
            // if (isUser) ...[
            //   SizedBox(width: 8.w),
            //   Icon(Icons.person, color: Colors.white, size: 20.sp),
            // ],
          ],
        ),
      ),
    );
  }
}
