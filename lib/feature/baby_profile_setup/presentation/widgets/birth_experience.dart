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

class BirthExperience extends StatelessWidget {
  const BirthExperience({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Text(
          context.trContext(TK.babySetupBirthTitle),
          style: context.text.displayMedium!,
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        16.height,
        Text(
          context.trContext(TK.babySetupBirthSub),
          style: context.text.titleSmall!,
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        78.height,

        BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            return CustomDropdown(
              items: AppLists.birthExperience,
              value: state.answers['birthExperience'],
              hintText: context.trContext(TK.babySetupBirthHint),
              itemLabelBuilder: (item) => item == 'Normal'
                  ? context.trContext(TK.childrenNormal)
                  : context.trContext(TK.childrenCesarean),
              onChanged: (String? value) {
                context.read<OnboardingCubit>().setAnswer(
                  'birthExperience',
                  value,
                );
              },
            );
          },
        ),
        const StepNextButton(stepKey: 'birthExperience'),
      ],
    );
  }
}
