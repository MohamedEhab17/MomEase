import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
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

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Is Your Baby a', style: context.text.displayMedium!),
            16.height,
            Text(
              'This helps us personalize your experience',
              style: context.text.titleSmall!,
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
                  backgroundColor: context.ext.colors.backgroundBlue,

                  textStyle: context.text.headlineMedium!.copyWith(
                    color: context.ext.colors.lightTextPrimary,
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
                  backgroundColor: context.ext.colors.primaryLight,

                  textStyle: context.text.headlineMedium!.copyWith(
                    color: context.ext.colors.lightTextPrimary,
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
