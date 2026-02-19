import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class ArticleCategoryCard extends StatelessWidget {
  const ArticleCategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed('articleCategoryView'),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        width: double.infinity,
        height: 128.h,
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
        child: Row(
          spacing: 10,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.asset(
                AppImages.imagesArticleCategory,
                fit: BoxFit.contain,
                width: 100.w,
                height: 100.h,
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: .center,
                spacing: 6.h,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Postpartum Recovery',
                    style: AppStyles.styleInter12,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'Guides and tips to help mothers recover physically and emotionally after childbirth, including healing, rest, and self-care.',
                    style: AppStyles.styleInter10.copyWith(
                      color: AppColors.lightTextPrimary.withAlpha(179),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
