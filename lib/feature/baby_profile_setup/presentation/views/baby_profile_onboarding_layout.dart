import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_cubit.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_state.dart';

class BabyProfileOnboardingLayout extends StatelessWidget {
  final Widget child;

  const BabyProfileOnboardingLayout({super.key, required this.child});

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20, top: 42.h),
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              return Column(
                children: [
                  LinearProgressIndicator(
                    backgroundColor: AppColors.greyMedium,
                    borderRadius: BorderRadius.circular(6),
                    minHeight: 6.h,
                    color: AppColors.primaryDark,
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
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        )
                      else
                        const SizedBox(width: 48, height: 48),
                      const Spacer(),
                      Text(
                        '${state.currentStep + 1} of ${_stepRoutes.length}',
                        style: AppStyles.styleInter16.copyWith(
                          color: AppColors.darkBackground.withAlpha(179),
                        ),
                      ),
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
