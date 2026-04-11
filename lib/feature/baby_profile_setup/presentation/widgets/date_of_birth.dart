import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
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
    final initialDate =
        context.read<OnboardingCubit>().state.answers['dateOfBirth'] ?? '';
    _dateController = TextEditingController(text: initialDate);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'When were they born?',
              style: context.text.displayMedium!,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            16.height,
            Text(
              'Or their expected due date if not yet arrived',
              textAlign: TextAlign.center,
              softWrap: true,
              style: context.text.titleSmall!,
            ),
            87.height,
            TextFormFieldHelper(
              controller: _dateController,
              borderColor: context.ext.colors.primaryDark,
              fillColor: context.theme.cardColor,
              borderRadius: BorderRadius.circular(64.r),
              hint: 'mm/dd/yyyy',
              hintStyle: context.text.bodyLarge!.copyWith(
                color: context.ext.colors.lightTextDisabled,
              ),
              suffixWidget: Icon(
                Icons.calendar_today_outlined,
                color: context.ext.colors.primaryDark,

              ),
              isReadOnly: true,
              onTap: _pickDate,
            ),
            const StepNextButton(stepKey: 'dateOfBirth'),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 270)),
      builder: (context, child) {
        return Theme(
          data: context.theme.copyWith(
            colorScheme: ColorScheme.light(
              primary: context.ext.colors.primaryDark,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
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
