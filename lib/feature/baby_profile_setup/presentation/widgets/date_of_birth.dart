import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/view_model/cubit/onboarding_cubit.dart';
import 'package:new_mama/feature/baby_profile_setup/presentation/widgets/step_next_button.dart';

class DateOfBirth extends StatefulWidget {
  const DateOfBirth({super.key});

  @override
  State<DateOfBirth> createState() => _DateOfBirthState();
}

class _DateOfBirthState extends State<DateOfBirth> {
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    final initialDate = context.read<OnboardingCubit>().state.answers['dateOfBirth'] ?? '';
    _dateController = TextEditingController(text: initialDate);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'When were they born?',
          style: AppStyles.styleInter32,
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        16.height,
        Text(
          'Or their expected due date if not yet arrived',
          textAlign: TextAlign.center,
          softWrap: true,
          style: AppStyles.styleInter14,
        ),
        87.height,
        TextFormFieldHelper(
          controller: _dateController,
          borderColor: AppColors.primaryDark,
          fillColor: AppColors.lightBackground,
          borderRadius: BorderRadius.circular(64.r),
          hint: 'mm/dd/yyyy',
          hintStyle: AppStyles.styleInter12.copyWith(
            color: AppColors.lightTextDisabled,
          ),
          suffixWidget: Icon(
            Icons.calendar_today_outlined,
            color: AppColors.primaryDark,
          ),
          isReadOnly: true,
          onTap: _pickDate,
        ),
        const StepNextButton(stepKey: 'dateOfBirth'),
      ],
    );
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 270)),
    );

    if (picked != null) {
      final dateStr = "${picked.month}/${picked.day}/${picked.year}";
      setState(() {
        _dateController.text = dateStr;
      });
      if (mounted) {
        context.read<OnboardingCubit>().setAnswer('dateOfBirth', dateStr);
      }
    }
  }
}
