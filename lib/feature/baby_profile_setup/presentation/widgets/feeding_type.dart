import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/app_lists.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/shared/popup_form/view/custom_drop_down.dart';
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
          'Feeding Type',
          style: AppStyles.styleInter32,
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        16.height,
        Text(
          'Every choice is the right choice for your family',
          style: AppStyles.styleInter14,
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        78.height,

          BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              return CustomDropdown(
                items: AppLists.typesOfFeeding,
                value: state.answers['feedingType'],
                hintText: 'feeding type..',
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
