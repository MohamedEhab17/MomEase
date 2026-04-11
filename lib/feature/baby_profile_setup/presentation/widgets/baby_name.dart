import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/validation_methods.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_cubit.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/step_next_button.dart';

class BabyName extends StatefulWidget {
  const BabyName({super.key});

  @override
  State<BabyName> createState() => _BabyNameState();
}

class _BabyNameState extends State<BabyName> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final initialName =
        context.read<OnboardingCubit>().state.answers['babyName'] ?? '';
    _nameController = TextEditingController(text: initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: MediaQuery.of(context).viewInsets.bottom > 0
            ? EdgeInsets.zero
            : EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Text(
              'What’s Your Current Baby’s Name?',
              softWrap: true,
              style: context.text.displayMedium!,
              textAlign: TextAlign.center,
            ),
            81.height,
            TextFormFieldHelper(
              controller: _nameController,
              hint: 'We’d love to know his/her name..',
              hintStyle: context.text.bodyLarge!.copyWith(
                color: context.ext.colors.lightTextDisabled,
              ),
              onValidate: validateRequired,
              fillColor: context.theme.cardColor,
              borderRadius: BorderRadius.circular(64.r),
              borderColor: context.ext.colors.primaryDark,
              onChanged: (value) {
                context.read<OnboardingCubit>().setAnswer(
                  'babyName',
                  value == null || value.isEmpty ? null : value,
                );
              },
            ),
            const StepNextButton(stepKey: 'babyName'),
          ],
        ),
      ),
    );
  }
}
