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
        boxShadow: [
          BoxShadow(
            color: context.ext.colors.lightTextPrimary.withAlpha(38),
            blurRadius: 15,
            offset: const Offset(0, 0),
            spreadRadius: 0,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: context.ext.colors.lightBackground,
        leadingWidth: 24.w,
        scrolledUnderElevation: 0,
        elevation: 0,
        clipBehavior: Clip.none,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 12,
          children: [
            Container(
              width: 56.w,
              height: 56.h,
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: context.ext.colors.primaryLight.withAlpha(51),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.transparent, width: 1.w),
                boxShadow: [
                  BoxShadow(
                    color: context.ext.colors.primaryLight,
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                    spreadRadius: 0,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              child: SvgPicture.asset(
                AppIcons.iconsLuna,
                width: 34.w,
                height: 34.h,
                colorMapper: AppSvgColorMapper(
                  from: const Color(0xffFF9BBC),
                  to: context.ext.colors.primaryLight,
                ),
              ),
            ),
            //icon
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Text(
                  context.trContext('chatbot.title'),
                  style: context.text.titleMedium,
                ),
                Text(
                  context.trContext('chatbot.subtitle'),
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ],
        ),

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.ext.colors.lightTextPrimary,
            size: 24.sp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 65.h);
}
