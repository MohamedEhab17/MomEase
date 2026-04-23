import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_cubit.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_state.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/step_next_button.dart';

class BabyGender extends StatelessWidget {
  const BabyGender({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              60.height,
              Text(context.trContext(TK.onboardingGenderTitle), style: context.text.displayMedium!),
              16.height,
              Text(
                context.trContext(TK.onboardingGenderSubtitle),
                style: context.text.titleSmall!,
              ),
              60.height,
              Row(
                mainAxisAlignment: .center,
                spacing: 24.w,
                children: [
                  _PremiumGenderCard(
                    label: context.trContext(TK.childrenBoy),
                    emoji: '👦',
                    isSelected: state.answers['babyGender'] == 'Boy',
                    baseColor: context.ext.colors.backgroundBlue,
                    activeColor: context.ext.colors.primaryDark,
                    onTap: () {
                      context.read<OnboardingCubit>().setAnswer(
                        'babyGender',
                        'Boy',
                      );
                    },
                  ),
                  _PremiumGenderCard(
                    label: context.trContext(TK.childrenGirl),
                    emoji: '👧',
                    isSelected: state.answers['babyGender'] == 'Girl',
                    baseColor: context.ext.colors.primaryLighter,
                    activeColor: context.ext.colors.primaryDark,
                    onTap: () {
                      context.read<OnboardingCubit>().setAnswer(
                        'babyGender',
                        'Girl',
                      );
                    },
                  ),
                ],
              ),
              60.height,
              const StepNextButton(stepKey: 'babyGender'),
            ],
          ),
        );
      },
    );
  }
}

class _PremiumGenderCard extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final Color baseColor;
  final Color activeColor;
  final VoidCallback onTap;

  const _PremiumGenderCard({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.baseColor,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        width: 150.w,
        height: isSelected ? 180.h : 160.h,
        decoration: BoxDecoration(
          color: isSelected ? baseColor.withAlpha(50) : context.theme.cardColor,
          borderRadius: BorderRadius.circular(32.r),
          border: Border.all(
            color: isSelected ? activeColor : baseColor.withAlpha(80),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withAlpha(50),
                    blurRadius: 24,
                    spreadRadius: 4,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [
                  BoxShadow(
                    color: context.colors.onSurface.withValues(alpha: 10),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.25 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: Text(emoji, style: TextStyle(fontSize: 60.sp)),
            ),
            16.height,
            Text(
              label,
              style: context.text.headlineMedium!.copyWith(
                color: isSelected
                    ? activeColor
                    : context.colors.onSurface.withAlpha(150),
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
