import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_cubit.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_state.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/step_next_button.dart';

class BabyGender extends StatelessWidget {
  const BabyGender({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final gender = state.answers['babyGender'];

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Is Your Baby a', style: AppStyles.styleInter32),
            16.height,
            Text(
              'This helps us personalize your experience',
              style: AppStyles.styleInter14,
            ),
            83.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 30.w,
              children: [
                CustomElevatedButton(
                  text: 'Boy',
                  onPressed: () {
                    context.read<OnboardingCubit>().setAnswer(
                      'babyGender',
                      'Boy',
                    );
                  },
                  backgroundColor: gender == 'Boy'
                      ? AppColors.backgroundBlueDarker
                      : AppColors.backgroundBlue,
                  borderColor: gender == 'Boy'
                      ? AppColors.backgroundBlueDarker
                      : AppColors.backgroundBlue,
                  textStyle: AppStyles.styleInter20.copyWith(
                    color: gender == 'Boy' ? AppColors.darkTextPrimary : null,
                  ),
                  minimumSize: Size(158.w, 56.h),
                ),
                CustomElevatedButton(
                  text: 'Girl',
                  onPressed: () {
                    context.read<OnboardingCubit>().setAnswer(
                      'babyGender',
                      'Girl',
                    );
                  },
                  backgroundColor: gender == 'Girl'
                      ? AppColors.primaryDark
                      : AppColors.primaryLighter,
                  borderColor: gender == 'Girl'
                      ? AppColors.primaryDark
                      : AppColors.primaryLighter,
                  textStyle: AppStyles.styleInter20.copyWith(
                    color: gender == 'Girl' ? AppColors.darkTextPrimary : null,
                  ),
                  minimumSize: Size(158.w, 56.h),
                ),
              ],
            ),
            const StepNextButton(stepKey: 'babyGender'),
          ],
        );
      },
    );
  }
}
