import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/articles/presentation/widgets/custom_saved_icon.dart';

class CustomArticleCategoryItem extends StatelessWidget {
  const CustomArticleCategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRoutesPaths.articleDetailsView);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 2),
              color: AppColors.lightTextPrimary.withAlpha(38),
              spreadRadius: 0,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: .start,
          spacing: 4,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.asset(
                AppImages.imagesArticleCategoryItems,
                fit: BoxFit.fill,
                width: double.infinity,
                height: 200.h,
              ),
            ),
            16.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Your Healing Journey After Birth: A Gentle Guide for New Mothers',
                style: AppStyles.styleInter12.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Row(
                spacing: 6.w,
                crossAxisAlignment: .center,
                children: [
                  Expanded(
                    child: Text(
                      'This article gently guides new mothers through the postpartum recovery phase, helping them understand their bodies, emotions...',
                      style: AppStyles.styleInter10,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  CustomSavedIcon(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
