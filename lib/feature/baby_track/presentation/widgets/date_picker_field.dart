import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String hint;
  final String? label;

  const DatePickerField({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    this.hint = 'mm/dd/yyyy',
    this.label,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: now.add(const Duration(days: 365 * 2)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryDark,
            onPrimary: Colors.white,
            onSurface: AppColors.lightTextPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onDateSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppStyles.styleInter12.copyWith(
              color: AppColors.lightTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
        ],
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            height: 50.h,
            padding: 20.w.hPadding,
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(64.r),
              border: Border.all(color: AppColors.primaryDark),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.year}'
                        : hint,
                    style: AppStyles.styleInter14.copyWith(
                      color: selectedDate != null
                          ? AppColors.lightTextPrimary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                SvgPicture.asset(AppIcons.iconsCalender),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
