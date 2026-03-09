import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';

class DepressionTestWidget extends StatelessWidget {
  const DepressionTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 164.h,
          decoration: BoxDecoration(
            color: AppColors.primaryTint,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        Positioned(
          bottom: 9.h,

          left: 5.w,
          child: SvgPicture.asset(
            AppImages.imagesDepression,
            width: 187.w,
            height: 171.h,
          ),
        ),
        Positioned(
          right: 17.w,
          top: 39.h,
          left: 190.w,
          child: Text(
            'How is your mood today?',
            maxLines: 2,
            style: AppStyles.styleInter16.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Positioned(
          right: 30.w,
          bottom: 25.h,
          child: CustomElevatedButton(
            text: 'Make Depression Test',
            textStyle: AppStyles.styleInter10,
            onPressed: () {
              context.push(AppRoutesPaths.depressionView);
            },
            padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.h),
            minimumSize: Size(148.w, 32.h),
            borderColor: AppColors.primary,
            backgroundColor: AppColors.lightBackground,
          ),
        ),
      ],
    );
  }
}
