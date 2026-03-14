import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_cubit.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_state.dart';

class FirstTimeMama extends StatelessWidget {
  const FirstTimeMama({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final isFirstTime = state.answers['firstTimeMama'];

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Is It Your First Time As Mama?',
              softWrap: true,
              style: AppStyles.styleInter32,
              textAlign: TextAlign.center,
            ),
            102.height,
            CustomElevatedButton(
              text: 'Yes, It’s My First Time',
              onPressed: () {
                context.read<OnboardingCubit>().setAnswer('firstTimeMama', true);
                context.read<OnboardingCubit>().nextStep();
                context.push(AppRoutesPaths.babyCount);
              },
              backgroundColor: isFirstTime == true ? AppColors.primaryDark : AppColors.lightBackground,
              borderColor: AppColors.primaryDark,
              textStyle: AppStyles.styleInter20.copyWith(
                color: isFirstTime == true ? AppColors.darkTextPrimary : AppColors.primaryDark,
              ),
              minimumSize: Size(double.infinity, 56.h),
              elevation: 0,
            ),
            24.height,
            CustomElevatedButton(
              text: 'No, I’m experienced',
              onPressed: () {
                context.read<OnboardingCubit>().setAnswer('firstTimeMama', false);
                context.read<OnboardingCubit>().nextStep();
                context.push(AppRoutesPaths.babyCount);
              },
              backgroundColor: isFirstTime == false ? AppColors.primaryDark : AppColors.lightBackground,
              borderColor: AppColors.primaryDark,
              textStyle: AppStyles.styleInter20.copyWith(
                color: isFirstTime == false ? AppColors.darkTextPrimary : AppColors.primaryDark,
              ),
              minimumSize: Size(double.infinity, 56.h),
              elevation: 0,
            ),
          ],
        );
      },
    );
  }
}
