
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class ArticlesSliverHeader extends StatelessWidget {
  const ArticlesSliverHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leadingWidth: 50.w,
    
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20, top: 24),
        child: CircleAvatar(
          backgroundColor: AppColors.darkTextPrimary,
          child: Transform.translate(
            offset: const Offset(-4, -1),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.primaryHard,
                size: 20.sp,
              ),
            ),
          ),
        ),
      ),
      expandedHeight: 250.h,
      pinned: true,
      flexibleSpace: Stack(
        clipBehavior: Clip.none,
    
        children: [
          Image.asset(
            AppImages.imagesArticleCategoryItems,
            width: double.infinity,
            height: 250.h,
            fit: BoxFit.fill,
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
    );
  }
}
