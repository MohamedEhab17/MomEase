import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/baby_track/data/models/baby_track_models.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/baby_track_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/date_picker_field.dart';
import 'package:new_mama/core/widgets/time_picker_field.dart';

class SleepTabView extends StatefulWidget {
  const SleepTabView({super.key});

  @override
  State<SleepTabView> createState() => _SleepTabViewState();
}

class _SleepTabViewState extends State<SleepTabView> {
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _save(BabyTrackCubit cubit) {
    if (_selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all required fields'),
          backgroundColor: AppColors.primaryDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    cubit.saveSleepRecord(
      SleepSession(
        id: DateTime.now().toIso8601String(),
        date: _selectedDate!,
        startTime: _startTime!,
        endTime: _endTime!,
        notes: _notesController.text,
      ),
    );
    _notesController.clear();
    setState(() {
      _selectedDate = null;
      _startTime = null;
      _endTime = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Sleep record saved! 😴'),
        backgroundColor: AppColors.greenText,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BabyTrackCubit>();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sleeping Date
          Text(
            'Sleeping Date',
            style: AppStyles.styleInter16.copyWith(fontWeight: FontWeight.w600),
          ),
          8.h.height,
          DatePickerField(
            selectedDate: _selectedDate,
            onDateSelected: (d) => setState(() => _selectedDate = d),
          ),
          20.h.height,

          // Time row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Time',
                      style: AppStyles.styleInter16.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.h.height,
                    TimePickerField(
                      selectedTime: _startTime,
                      hint: '7:12 am',
                      onTimeSelected: (t) => setState(() => _startTime = t),
                    ),
                  ],
                ),
              ),
              16.w.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'End Time',
                      style: AppStyles.styleInter16.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.h.height,
                    TimePickerField(
                      selectedTime: _endTime,
                      hint: '10:52 am',
                      onTimeSelected: (t) => setState(() => _endTime = t),
                    ),
                  ],
                ),
              ),
            ],
          ),
          20.h.height,

          // Notes
          Text(
            'Notes',
            style: AppStyles.styleInter16.copyWith(fontWeight: FontWeight.w600),
          ),
          8.h.height,
          TextFormFieldHelper(
            controller: _notesController,
            hint: 'How was your baby\'s sleep?',
            maxLines: 10,
            minLines: 3,
            enableShadow: false,
            fillColor: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(16.r),
            borderColor: AppColors.primaryDark,
          ),
          28.h.height,

          // Save button
          CustomElevatedButton(
            text: 'Save Sleeping record',
            onPressed: () => _save(cubit),
            backgroundColor: AppColors.primaryDark,
            minimumSize: Size(double.infinity, 52.h),
            textStyle: AppStyles.styleInter16.copyWith(
              color: AppColors.lightBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
