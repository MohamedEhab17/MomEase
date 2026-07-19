import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/step_next_button.dart';

class AllSetUp extends StatelessWidget {
  const AllSetUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.trContext(TK.onboardingAllSetTitle),
          style: context.text.displaySmall!,
        ),
        15.height,
        Text(
          context.trContext(TK.onboardingAllSetSubtitle),
          style: context.text.headlineMedium!,
          textAlign: TextAlign.center,
        ),
        94.height,
        Lottie.asset(AppIcons.iconsSuccess, width: 100.w, height: 100.h),
        100.height,
        const StepNextButton(stepKey: null),
      ],
    );
  }
}
