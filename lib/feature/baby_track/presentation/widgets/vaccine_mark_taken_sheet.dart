import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_entity.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/vaccinations_cubit/vaccinations_cubit.dart';

String _formatDate(DateTime dt) =>
    '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

/// Bottom sheet to confirm marking a vaccine as taken with a date picker.
class VaccineMarkTakenSheet extends StatefulWidget {
  final VaccineEntity vaccine;
  final int childId;
  final VaccinationsCubit cubit;

  const VaccineMarkTakenSheet({
    super.key,
    required this.vaccine,
    required this.childId,
    required this.cubit,
  });

  static void show(
    BuildContext context, {
    required VaccineEntity vaccine,
    required int childId,
    required VaccinationsCubit cubit,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.theme.cardColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      builder: (_) => VaccineMarkTakenSheet(
        vaccine: vaccine,
        childId: childId,
        cubit: cubit,
      ),
    );
  }

  @override
  State<VaccineMarkTakenSheet> createState() => _VaccineMarkTakenSheetState();
}

class _VaccineMarkTakenSheetState extends State<VaccineMarkTakenSheet> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 28.h,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 28.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: context.ext.colors.primaryLighter,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          16.h.height,

          // Title
          Text(
            context.trContext(TK.babyVaccineMarkTakenTitle),
            style: context.text.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.onSurface,
            ),
          ),
          8.h.height,

          // Description
          Text(
            context.trContext(
              TK.babyVaccineMarkTakenDesc,
              namedArgs: {'vaccine': widget.vaccine.vaccineName},
            ),
            style: context.text.bodyMedium!.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          20.h.height,

          // Date label
          Text(
            context.trContext(TK.babyVaccineDate),
            style: context.text.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.onSurface,
            ),
          ),
          8.h.height,

          // Date picker trigger
          InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                builder: (context, child) => Theme(
                  data: context.theme.copyWith(
                    colorScheme: context.theme.colorScheme.copyWith(
                      primary: context.ext.colors.primaryDark,
                      onPrimary: context.colors.onPrimary,
                      onSurface: context.colors.onSurface,
                    ),
                    datePickerTheme: DatePickerThemeData(
                      headerBackgroundColor: context.ext.colors.primaryDark,
                      headerForegroundColor: context.colors.onPrimary,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: context.ext.colors.primaryLighter),
                borderRadius: BorderRadius.circular(16.r),
                color: context.ext.colors.primaryExtraLight,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(_selectedDate),
                    style: context.text.bodyLarge!.copyWith(
                      color: context.colors.onSurface,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_rounded,
                    color: context.ext.colors.primaryDark,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
          24.h.height,

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: context.ext.colors.primaryLighter),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    context.trContext(TK.babyVaccineCancel),
                    style: context.text.bodyMedium!.copyWith(
                      color: context.colors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              16.w.width,
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.cubit.markVaccineAsTaken(
                      widget.childId,
                      widget.vaccine.childVaccineId,
                      status: 'done',
                      takenDate: _selectedDate,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.ext.colors.primaryDark,
                    foregroundColor: context.ext.colors.primaryExtraLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    context.trContext(TK.babyVaccineConfirm),
                    style: context.text.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.ext.colors.primaryExtraLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
