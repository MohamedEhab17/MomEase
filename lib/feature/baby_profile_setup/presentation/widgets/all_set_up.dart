import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/step_next_button.dart';

class AllSetUp extends StatelessWidget {
  const AllSetUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('You’re all set', style: AppStyles.styleRoboto24),
        15.height,
        Text(
          'We’re so glad you’re here, Omar’s mom!',
          style: AppStyles.styleRoboto20,
        ),
        94.height,
        Lottie.asset(AppIcons.iconsSuccess, width: 100.w, height: 100.h),
        100.height,
        const StepNextButton(stepKey: null),
      ],
    );
  }
}
