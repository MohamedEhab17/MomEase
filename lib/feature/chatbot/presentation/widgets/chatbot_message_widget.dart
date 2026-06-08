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

    Widget bubble = Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isUser ? context.ext.colors.primary : context.ext.colors.primaryLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isUser ? radius : 4.r), // notch pointing to avatar
          topRight: Radius.circular(radius),
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(isUser ? 4.r : radius), // notch pointing to user side
        ),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      child: Text(
        text,
        style: context.text.titleLarge!.copyWith(
          color: isUser
              ? context.ext.colors.lightBackground
              : context.ext.colors.lightTextPrimary,
        ).forText(text),
      ),
    );

    if (!isUser) {
      bubble = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.ext.colors.primaryExtraLight,
              border: Border.all(
                color: context.ext.colors.primary.withAlpha(40),
                width: 1.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.ext.colors.primary.withAlpha(20),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(6.w),
            child: SvgPicture.asset(
              AppIcons.iconsLunaBlue,
              colorMapper: AppSvgColorMapper(
                from: const Color(0xff7AA2C2),
                to: context.ext.colors.primaryDark,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(child: bubble),
        ],
      );
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: bubble,
      ),
    );
  }
}
