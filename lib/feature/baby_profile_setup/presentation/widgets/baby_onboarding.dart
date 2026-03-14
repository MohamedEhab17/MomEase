import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/step_next_button.dart';

class BabyOnboarding extends StatelessWidget {
  const BabyOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          80.height,
          SvgPicture.asset(AppImages.imagesMama),
          60.height,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Hello,',
                  style: AppStyles.styleInter24.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ' Mama!',
                  style: AppStyles.styleInter24.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          6.height,
          Text(
            ' Let’s Get to know you and your journey',
            style: AppStyles.styleInter14,
          ),
          75.height,
          const StepNextButton(stepKey: null),
        ],
      ),
    );
  }
}
