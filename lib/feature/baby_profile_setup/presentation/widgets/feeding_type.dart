import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/app_lists.dart';
import 'package:new_mama/core/widgets/custom_drop_down.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_cubit.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_state.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/step_next_button.dart';

class FeedingType extends StatelessWidget {
  const FeedingType({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.trContext(TK.babySetupFeedingTitle),
          style: context.text.displayMedium!,
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        16.height,
        Text(
          context.trContext(TK.babySetupFeedingSubtitle),
          style: context.text.titleSmall!,
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        78.height,

          BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              return CustomDropdown(
                items: AppLists.typesOfFeeding,
                value: state.answers['feedingType'],
                hintText: context.trContext(TK.babySetupFeedingHint),
                itemLabelBuilder: (item) => item == 'Breastfeeding' 
                    ? context.trContext(TK.babySetupBreast) 
                    : item == 'Formula' 
                        ? context.trContext(TK.babySetupFormula) 
                        : context.trContext(TK.babySetupMixed),
                onChanged: (String? value) {
                  context.read<OnboardingCubit>().setAnswer('feedingType', value);
                },
              );
            },
          ),
          const StepNextButton(stepKey: 'feedingType'),
        ],
      );
    }
  }
