import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class ArticlesHeader extends StatelessWidget implements PreferredSizeWidget {
  final AnimateToController? controller;
  final bool showSaveIcon;

  const ArticlesHeader({super.key, this.controller, this.showSaveIcon = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      actionsPadding: EdgeInsets.only(right: 15.w),
      actions: [
        if (showSaveIcon)
          GestureDetector(
            onTap: () {
              context.push(AppRoutesPaths.savedArticlesView);
            },
            child: controller != null
                ? AnimateTo(
                    controller: controller!,
                    child: SvgPicture.asset(
                      AppIcons.iconsFilledSave,
                      width: 25.w,
                      height: 25.h,
                    ),
                  )
                : SvgPicture.asset(
                    AppIcons.iconsFilledSave,
                    width: 25.w,
                    height: 25.h,
                  ),
          ),
      ],
      centerTitle: true,
      backgroundColor: AppColors.lightBackground,
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.primaryDark,
          size: 25.sp,
        ),
      ),
      title: Text(
        'Articles',
        style: AppStyles.styleInter20.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
