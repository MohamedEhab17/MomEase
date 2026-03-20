import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class TimePickerField extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final String hint;
  final String? label;

  const TimePickerField({
    super.key,
    this.selectedTime,
    required this.onTimeSelected,
    this.hint = '00:00 am',
    this.label,
  });

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'am' : 'pm';
    return '$h:$m $period';
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
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
    if (picked != null) onTimeSelected(picked);
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
          6.h.height,
        ],
        GestureDetector(
          onTap: () => _pickTime(context),
          child: Container(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(64.r),
              border: Border.all(color: AppColors.primaryDark),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedTime != null ? _formatTime(selectedTime!) : hint,
                    style: AppStyles.styleInter14.copyWith(
                      color: selectedTime != null
                          ? AppColors.lightTextPrimary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                Icon(
                  Icons.access_time_rounded,
                  size: 18.sp,
                  color: AppColors.primaryDark,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
