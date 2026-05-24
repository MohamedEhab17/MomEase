import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_font_family.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key, this.onMenuPressed});
  final VoidCallback? onMenuPressed;
  @override
  Widget build(BuildContext context) {
    

    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      backgroundColor: context.theme.appBarTheme.backgroundColor,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu, color: context.ext.colors.primaryDark),
        onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        IconButton(
          onPressed: () => context.push(AppRoutesPaths.chatbot),
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
      title: Text(
        'MomEase',
        style: context.theme.textTheme.displayLarge!.copyWith(
          fontSize: 24.sp,
          color: context.ext.colors.primaryDark,
          fontWeight: FontWeight.w700,
          fontFamily: AppFontFamily.scriptMT,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 60.h);
}
