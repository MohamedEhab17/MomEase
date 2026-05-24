import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/custom_circle_avatar_with_icon.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';

class DepressionTestCard extends StatelessWidget {
  const DepressionTestCard({
    super.key,
    required this.depressionTestTitle,
    required this.depressionTestSubtitle,
    required this.cardImage,
    required this.questionCount,
    this.onPressed,
  });
  final String depressionTestTitle;
  final String depressionTestSubtitle;
  final String cardImage;
  final int questionCount;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      // margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 33, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: context.theme.cardColor,
        
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
            blurStyle: BlurStyle.outer,
            color: context.colors.onSurface.withAlpha(38),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: .start,
        children: [
          CustomCircleAvatarWithIcon(
            image: cardImage,
            radius: 25.r,
            width: 24.w,
            height: 24.h,
          ),
          24.h.height,
          Text(depressionTestTitle, style: context.text.headlineSmall!),
          Text(depressionTestSubtitle, style: context.text.titleLarge!),
          24.h.height,
          FittedBox(
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.iconsQuestions,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: ColorFilter.mode(
                    context.colors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                10.w.width,
                Text(
                  '$questionCount',
                  style: context.text.titleMedium!.copyWith(
                    color: context.ext.colors.lightTextPrimary,
                  ),
                ),
                150.w.width,
                FittedBox(
                  child: CustomElevatedButton(
                    text: context.trContext(TK.onboardingStart),

                    onPressed: onPressed,
                    backgroundColor:
                        context.theme.buttonTheme.colorScheme!.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
