import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_cubit.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_state.dart';

class FirstTimeMama extends StatelessWidget {
  const FirstTimeMama({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.trContext(TK.babySetupFirstTimeTitle),
              softWrap: true,
              style: context.text.displayMedium!,
              textAlign: TextAlign.center,
            ),
            102.height,
            CustomElevatedButton(
              text: context.trContext(TK.babySetupFirstTimeYes),
              onPressed: () {
                context.read<OnboardingCubit>().setAnswer(
                  'firstTimeMama',
                  true,
                );
                context.read<OnboardingCubit>().nextStep();
                context.push(AppRoutesPaths.babyCount);
              },
              minimumSize: Size(double.infinity, 56.h),
              elevation: 5,
            ),
            24.height,
            CustomElevatedButton(
              text: context.trContext(TK.babySetupFirstTimeNo),
              onPressed: () {
                context.read<OnboardingCubit>().setAnswer(
                  'firstTimeMama',
                  false,
                );
                context.read<OnboardingCubit>().nextStep();
                context.push(AppRoutesPaths.babyCount);
              },
              backgroundColor: context.theme.buttonTheme.colorScheme!.secondary,
              borderColor: context.ext.colors.primaryDark,
              textStyle: context.text.headlineMedium!.copyWith(
                color: context.theme.buttonTheme.colorScheme!.primary,
              ),
              minimumSize: Size(double.infinity, 56.h),
              elevation: 5,
            ),
          ],
        );
      },
    );
  }
}
