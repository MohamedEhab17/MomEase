import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';

class ReportDialogTextField extends StatelessWidget {
  final TextEditingController controller;

  const ReportDialogTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormFieldHelper(
      controller: controller,
      hint: "Write your reason here...",
      hintStyle: context.text.titleLarge!.copyWith(
        fontSize: 14.sp,
        color: context.colors.onSurface.withAlpha(128),
      ),
      maxLines: 4,
      minLines: 2,
      fillColor: Colors.white,
      borderColor: context.colors.primary,
      borderRadius: BorderRadius.circular(16.r),
    );
  }
}
