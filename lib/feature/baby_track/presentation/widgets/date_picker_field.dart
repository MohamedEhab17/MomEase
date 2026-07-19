import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String hint;
  final String? label;
  final Color? fillColor;
  const DatePickerField({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    this.hint = 'mm/dd/yyyy',
    this.label,
    this.fillColor,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
      builder: (context, child) => Theme(
        data: context.theme.copyWith(
          colorScheme: context.theme.colorScheme.copyWith(
            primary: context.ext.colors.primaryDark,
            onPrimary: context.colors.onPrimary,
            onSurface: context.colors.onSurface,
          ),
          datePickerTheme: DatePickerThemeData(
            // headerBackgroundColor: context.ext.colors.primaryDark,
            backgroundColor: context.theme.cardColor,
            headerForegroundColor: context.ext.colors.greyPrimary,
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
      crossAxisAlignment: .start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: context.text.bodyLarge!.copyWith(
              color: context.theme.colorScheme.onSecondary,
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
              color: fillColor ?? context.colors.surface,
              borderRadius: BorderRadius.circular(64.r),
              border: Border.all(color: context.ext.colors.primaryDark),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.year}'
                        : hint,
                    style: context.text.titleSmall!.copyWith(
                      color: selectedDate != null
                          ? context.colors.onSurface
                          : context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  AppIcons.iconsCalender,
                  colorFilter: ColorFilter.mode(
                    context.colors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
