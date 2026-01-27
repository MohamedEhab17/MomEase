import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/auth/widgets/custom_rich_text.dart';

class EmptyChatbotWidget extends StatelessWidget {
  const EmptyChatbotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppImages.imagesLuna, height: 256.h),
          49.height,

          CustomRichText(
            firstText: "Hi, ",
            secondText: "Mama!",
            firstTextStyle: AppStyles.styleInter32,
            secondTextStyle: AppStyles.styleScriptMT32,
          ),
          21.height,
          Text(
            "What can I help you with?",
            style: AppStyles.styleInter20.copyWith(
              color: AppColors.lightTextPrimary.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}
