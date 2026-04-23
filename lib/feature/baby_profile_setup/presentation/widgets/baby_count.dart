import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_cubit.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_state.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/step_next_button.dart';

class BabyCount extends StatelessWidget {
  const BabyCount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final count = state.answers['babyCount'] ?? 1;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state.answers['babyCount'] == null) {
            context.read<OnboardingCubit>().setAnswer('babyCount', 1);
          }
        });

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.trContext(TK.babySetupCountTitle),
              style: context.text.displayMedium!,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            49.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 45.w,
              children: [
                AddMinusButton(
                  icon: Icons.remove,
                  onTap: () {
                    if (count > 1) {
                      context.read<OnboardingCubit>().setAnswer(
                        'babyCount',
                        count - 1,
                      );
                    }
                  },
                ),
                Text(
                  '$count',
                  style: context.text.displayMedium!.copyWith(fontSize: 36.sp),
                ),
                AddMinusButton(
                  icon: Icons.add,
                  onTap: () {
                    context.read<OnboardingCubit>().setAnswer(
                      'babyCount',
                      count + 1,
                    );
                  },
                ),
              ],
            ),
            const StepNextButton(stepKey: 'babyCount'),
          ],
        );
      },
    );
  }
}

class AddMinusButton extends StatelessWidget {
  const AddMinusButton({super.key, required this.icon, this.onTap});
  final IconData icon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 20),
        decoration: BoxDecoration(
          color: context.ext.colors.primaryLighter,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: context.ext.colors.primaryDark,
          size: 23.sp,
          weight: 700,
        ),
      ),
    );
  }
}
