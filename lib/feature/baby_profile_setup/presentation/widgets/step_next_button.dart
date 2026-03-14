import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_cubit.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_state.dart';

class StepNextButton extends StatelessWidget {
  const StepNextButton({super.key, required this.stepKey});

  final String? stepKey;

  static const List<String> _stepRoutes = [
    AppRoutesPaths.babyProfileOnboardingView,
    AppRoutesPaths.firstTimeMama,
    AppRoutesPaths.babyCount,
    AppRoutesPaths.babyName,
    AppRoutesPaths.babyGender,
    AppRoutesPaths.dateOfBirth,
    AppRoutesPaths.feedingType,
    AppRoutesPaths.birthExperience,
    AppRoutesPaths.allSetUp,
  ];

  bool _isNextEnabled(OnboardingState state) {
    if (stepKey == null) return true;
    final answer = state.answers[stepKey];
    if (answer is String) {
      return answer.trim().isNotEmpty;
    }
    return answer != null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final isLastStep = state.currentStep >= _stepRoutes.length - 1;
        final isEnabled = _isNextEnabled(state);

        return Padding(
          padding: EdgeInsets.only(top: 48.h),
          child: CustomElevatedButton(
            text: isLastStep ? 'Start Your Journey' : 'Next',
            onPressed: isEnabled
                ? () {
                    if (isLastStep) {
                      context.go(AppRoutesPaths.appSectionView);
                    } else {
                      context.read<OnboardingCubit>().nextStep();
                      final nextRoute = _stepRoutes[state.currentStep + 1];
                      context.push(nextRoute);
                    }
                  }
                : null,
           backgroundColor: isEnabled 
                    ? AppColors.primaryDark
                    : AppColors.primaryLighter,
            disabledBackgroundColor: AppColors.primaryLighter,
            disabledForegroundColor: AppColors.darkTextPrimary.withAlpha(150),
            textStyle: AppStyles.styleInter20.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            minimumSize: Size(double.infinity, 56.h),
            elevation: isEnabled ? 4 : 0,
          ),
        );
      },
    );
  }
}
