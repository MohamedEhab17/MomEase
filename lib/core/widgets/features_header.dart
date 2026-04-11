import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';

class FeaturesHeader extends StatelessWidget implements PreferredSizeWidget {
  const FeaturesHeader({super.key, required this.title, this.onPressed});
  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: context.theme.appBarTheme.backgroundColor,
      title: Text(
        title,
        style: context.text.headlineMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: context.ext.colors.primaryDark,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed:
            onPressed ??
            () {
              context.pop();
            },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 24.sp,
          color: context.ext.colors.primaryDark,
        ),
      ),

      actions: [
        IconButton(
          onPressed: () {},
          icon: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: context.ext.colors.primaryTint.withAlpha(128),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.ext.colors.primaryTint,
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(0, 0),
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: SvgPicture.asset(
              AppIcons.iconsLuna,
              colorMapper: AppSvgColorMapper(
                from: Color(0xffFF9BBC),
                to: context.ext.colors.primaryLight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
