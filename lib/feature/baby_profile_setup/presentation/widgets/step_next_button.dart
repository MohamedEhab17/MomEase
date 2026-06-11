import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/feature/auth/data/datasources/auth_local_data_source_contract.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_cubit.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_state.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_cubit.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_state.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/step_components/step_validation_helper.dart';

class StepNextButton extends StatelessWidget {
  const StepNextButton({super.key, required this.stepKey});

  final String? stepKey;

  static const List<String> _stepRoutes = [
    AppRoutesPaths.babyProfileOnboardingView,
    AppRoutesPaths.firstTimeMama,
    AppRoutesPaths.babyName,
    AppRoutesPaths.babyGender,
    AppRoutesPaths.dateOfBirth,
    AppRoutesPaths.feedingType,
    AppRoutesPaths.birthExperience,
    AppRoutesPaths.allSetUp,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final isLastStep = state.currentStep >= _stepRoutes.length - 1;
        final isEnabled = StepValidationHelper.isNextEnabled(state, stepKey);

        return Padding(
          padding: EdgeInsets.only(top: 48.h),
          child: BlocConsumer<ChildrenCubit, ChildrenState>(
            listener: (context, childState) async {
              final onboardingState = context.read<OnboardingCubit>().state;
              final isLast = onboardingState.currentStep >= _stepRoutes.length - 1;
              if (!isLast) return;

              if (childState is ChildActionSuccess) {
                // Check if there are more children to create
                final nextChild = context.read<OnboardingCubit>().consumeNextPendingChild();
                if (nextChild != null) {
                  // Still have more children — keep creating, don't navigate yet
                  context.read<ChildrenCubit>().createChild(nextChild);
                } else {
                  // All children created — mark setup done and go to app
                  await getIt<AuthLocalDataSource>().setBabySetupCompleted();
                  if (context.mounted) {
                    context.go(AppRoutesPaths.appSectionView);
                  }
                }
              } else if (childState is ChildrenError) {
                AppToast.error(context, message: childState.message);
                context.read<ChildrenCubit>().restoreLoaded();
              }
            },
            builder: (context, childState) {
              final isLoading = childState is ChildrenActionLoading;

              return CustomElevatedButton(
                text: isLastStep
                    ? context.trContext(TK.onboardingStartJourney)
                    : context.trContext(TK.onboardingNext),
                onPressed: (isEnabled && !isLoading)
                    ? () {
                        if (isLastStep) {
                          StepValidationHelper.submitToApi(context, state);
                        } else {
                          context.read<OnboardingCubit>().nextStep();
                          final nextRoute = _stepRoutes[state.currentStep + 1];
                          context.push(nextRoute);
                        }
                      }
                    : null,
                minimumSize: Size(double.infinity, 56.h),
                elevation: (isEnabled && !isLoading) ? 4 : 0,
                icon: isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.colors.onPrimary,
                        ),
                      )
                    : null,
              );
            },
          ),
        );
      },
    );
  }
}
