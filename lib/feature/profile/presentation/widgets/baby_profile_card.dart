import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/profile/data/models/profile_model.dart';

class BabyProfileCard extends StatelessWidget {
  final BabyProfile baby;

  const BabyProfileCard({super.key, required this.baby});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
      padding: 20.vhPadding,
      decoration: BoxDecoration(
        color: AppColors.primaryExtraLight.withAlpha(128),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(21),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundImage: NetworkImage(baby.avatarUrl),
          ),
          16.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baby.name,
                  style: AppStyles.styleInter16.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary.withAlpha(200),
                  ),
                ),
                4.height,
                Text(
                  baby.ageString,
                  style: AppStyles.styleInter12.copyWith(
                    color: AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.push(AppRoutesPaths.allSetUp);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(24.r),
                color: Colors.white,
              ),
              child: Text(
                "View Baby Data",
                style: AppStyles.styleInter12.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
