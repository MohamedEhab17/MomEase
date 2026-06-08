import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';

class ChatbotAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatbotAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.ext.colors.lightBackground,
        border: Border(
          bottom: BorderSide(
            color: context.ext.colors.primary.withAlpha(20),
            width: 1.w,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: context.ext.colors.lightBackground,
        leadingWidth: 56.w, // Generous tap target for back button
        scrolledUnderElevation: 0,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 42.w,
                  height: 42.w,
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    color: context.ext.colors.primaryExtraLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.ext.colors.primary.withAlpha(40),
                      width: 1.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: context.ext.colors.primary.withAlpha(15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    AppIcons.iconsLunaBlue,
                    colorMapper: AppSvgColorMapper(
                      from: const Color(0xff7AA2C2),
                      to: context.ext.colors.primaryDark,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 11.w,
                    height: 11.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ADE80), // Active green glow
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.ext.colors.lightBackground,
                        width: 1.5.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4ADE80).withAlpha(120),
                          blurRadius: 4,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.trContext('chatbot.title'),
                  style: context.text.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.ext.colors.lightTextPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  context.trContext('chatbot.subtitle'),
                  style: context.text.bodySmall!.copyWith(
                    color: context.ext.colors.lightTextSecondary,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.ext.colors.lightTextPrimary,
            size: 20.sp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 72.h);
}
