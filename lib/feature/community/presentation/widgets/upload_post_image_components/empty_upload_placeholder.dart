import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/animated_dotted_container.dart';

class EmptyUploadPlaceholder extends StatelessWidget {
  const EmptyUploadPlaceholder({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedDottedContainer(
        color: AppColors.primary,
        dashPattern: const [16, 12],
        borderRadius: BorderRadius.circular(16),
        strokeWidth: 3.w,
        child: Container(
          height: 184.h,
          width: double.infinity,
          color: AppColors.lightBackground2,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 42.r,
                backgroundColor: AppColors.lightBackground,
                child: Transform.translate(
                  offset: const Offset(2, 0),
                  child: SvgPicture.asset(AppIcons.iconsAddPhoto, width: 38.w),
                ),
              ),
              SizedBox(height: 20.h),
              Text("Add Photos", style: AppStyles.styleInter20),
            ],
          ),
        ),
      ),
    );
  }
}
