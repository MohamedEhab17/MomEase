import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class ArticleDetailsView extends StatelessWidget {
  const ArticleDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        AppImages.imagesArticleCategoryItems,
                        width: double.infinity,
                        height: 250.h,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        top: 20.h,
                        right: 30.w,
                        child: CircleAvatar(
                          backgroundColor: AppColors.darkTextPrimary,
                          radius: 20.r,
                          child: SvgPicture.asset(
                            AppIcons.iconsSearch,
                            width: 16.w,
                            height: 16.h,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primaryHard,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20.h,
                        left: 30.w,
                        child: CircleAvatar(
                          backgroundColor: AppColors.darkTextPrimary,
                          radius: 20.r,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: AppColors.primaryHard,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 30,
                        right: 28,
                        child: Text(
                          'Your Healing Journey After Birth: A Gentle Guide for New Mothers',
                          style: AppStyles.styleInter20.copyWith(
                            color: AppColors.darkTextPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
