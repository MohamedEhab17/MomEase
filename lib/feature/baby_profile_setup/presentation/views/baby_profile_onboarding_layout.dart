import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/feature/auth/data/datasources/auth_local_data_source_contract.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_cubit.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_state.dart';

class BabyProfileOnboardingLayout extends StatelessWidget {
  final Widget child;

  const BabyProfileOnboardingLayout({super.key, required this.child});

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
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        body: Padding(
          padding: EdgeInsetsDirectional.only(start: 20.w, end: 20, top: 42.h),
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              final isLastStep = state.currentStep >= _stepRoutes.length - 1;
              return Column(
                children: [
                  LinearProgressIndicator(
                    backgroundColor: context.ext.colors.greyMedium,
                    borderRadius: BorderRadius.circular(6),
                    minHeight: 6.h,
                    color: context.ext.colors.primaryDark,
                    value: state.progress,
                  ),
                  16.height,
                  Row(
                    children: [
                      if (state.currentStep > 0)
                        IconButton(
                          onPressed: () {
                            context.read<OnboardingCubit>().previousStep();
                            context.pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: context.colors.onSurface,
                          ),
                        )
                      else
                        const SizedBox(width: 48, height: 48),
                      const Spacer(),
                      Text(
                        context.trContext(
                          TK.onboardingStepProgress,
                          namedArgs: {
                            'current': '${state.currentStep + 1}',
                            'total': '${_stepRoutes.length}',
                          },
                        ),
                        style: context.text.titleLarge!.copyWith(
                          color: context.colors.surface.withAlpha(179),
                        ),
                      ),
                      const Spacer(),
                      if (!isLastStep)
                        const _SkipButton()
                      else
                        const SizedBox(width: 48, height: 48),
                    ],
                  ),
                  Expanded(child: child),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        try {
          await getIt<AuthLocalDataSource>().setBabySetupCompleted();
        } catch (_) {}
        if (context.mounted) {
          context.go(AppRoutesPaths.appSectionView);
        }
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        context.trContext(TK.onboardingSkip),
        style: context.text.titleMedium!.copyWith(
          color: context.ext.colors.primaryDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
