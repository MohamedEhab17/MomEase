import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class TimePickerField extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final String hint;
  final String? label;
  final Color? fillColor;

  const TimePickerField({
    super.key,
    this.selectedTime,
    required this.onTimeSelected,
    this.hint = '00:00 am',
    this.label, this.fillColor,
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
        data: context.theme.copyWith(
          colorScheme: ColorScheme.light(
            primary: context.ext.colors.primaryDark,
            onPrimary: Colors.white,
            onSurface: context.colors.onSurface,
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
            style: context.text.bodyLarge!.copyWith(
              color: context.colors.onSurfaceVariant,
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
              color: fillColor ?? context.colors.surface,
              borderRadius: BorderRadius.circular(64.r),
              border: Border.all(color: context.ext.colors.primaryDark),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedTime != null ? _formatTime(selectedTime!) : hint,
                    style: context.text.titleSmall!.copyWith(
                      color: selectedTime != null
                          ? context.colors.onSurface
                          : context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(
                  Icons.access_time_rounded,
                  size: 18.sp,
                  color: context.ext.colors.primaryDark,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
