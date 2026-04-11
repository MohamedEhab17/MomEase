import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

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
            color: context.ext.colors.primaryLighter,
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              begin: .bottomCenter,
              end: .topCenter,
              colors: [
                context.ext.colors.primaryLighter,
                context.ext.colors.primaryTint,
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 9.h,

          left: 5.w,
          child: SvgPicture.asset(
            AppImages.imagesDepression,
            width: 187.w,
            height: 171.h,
            colorMapper: AppSvgColorMapper(
              from: Color(0xffFF9BBC),
              to: context.ext.colors.primaryLight,
            ),
          ),
        ),
        Positioned(
          right: 17.w,
          top: 30.h,
          left: 190.w,
          child: Text(
            'How is your mood today?',
            maxLines: 2,
            style: context.theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Positioned(
          right: 25.w,
          bottom: 30.h,
          child: CustomElevatedButton(
            text: 'Make Depression Test',
            textStyle: context.theme.textTheme.bodySmall!,
            onPressed: () {
              context.push(AppRoutesPaths.depressionView);
            },
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            minimumSize: Size(140.w, 32.h),
            borderColor: context.colors.primary,
            backgroundColor: context.theme.buttonTheme.colorScheme!.secondary,
          ),
        ),
      ],
    );
  }
}
