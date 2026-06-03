import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/baby_track/data/models/add_sleep_record_request_model.dart';
import 'package:new_mama/feature/baby_track/domain/entities/sleep_record_entity.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/baby_track_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/date_picker_field.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/sleep_record_list_card.dart';
import 'package:new_mama/core/widgets/time_picker_field.dart';
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
      AppToast.warning(
        context,
        message: context.trContext(TK.babySleepRequired),
      );
      return;
    }

    final activeChild = context.read<ActiveChildCubit>().state;
    if (activeChild == null) {
      AppToast.warning(
        context,
        message: context.trContext(TK.babyVaccineSelectChildMsg),
      );
      return;
    }

    // Calculate total sleep hours formatted as "HH:mm:ss"
    int startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    int endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    int diffMinutes = endMinutes - startMinutes;
    if (diffMinutes < 0) {
      diffMinutes += 24 * 60; // Spanning midnight
    }

    // Enforce that duration is greater than 0 and does not exceed 16 hours.
    // This allows natural overnight sleep (e.g. 10 PM to 6 AM = 8 hours)
    // but flags mistakes like (Start: 4 PM, End: 2 PM = 22 hours).
    if (diffMinutes == 0 || diffMinutes > 16 * 60) {
      AppToast.warning(
        context,
        message: context.trContext(TK.babySleepInvalidDuration),
      );
      return;
    }

    final String startTimeStr = '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}';
    final String endTimeStr = '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}';

    cubit.saveSleepRecord(
      childId: activeChild.childId,
      request: AddSleepRecordRequestModel(
        childId: activeChild.childId,
        sleepDate: _selectedDate!,
        sleepStartTime: startTimeStr,
        sleepEndTime: endTimeStr,
        quality: 'Good',
        notes: _notesController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BabyTrackCubit, BabyTrackState>(
      listener: (context, state) {
        if (state is SleepRecordSaved) {
          _notesController.clear();
          setState(() {
            _selectedDate = null;
            _startTime = null;
            _endTime = null;
          });
          AppToast.success(
            context,
            message: context.trContext(TK.babySleepSaved),
          );
        } else if (state is SleepRecordError) {
          AppToast.error(
            context,
            message: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<BabyTrackCubit>();
        final isLoading = state is SleepRecordLoading;
        final activeChild = context.read<ActiveChildCubit>().state;
        final isAr = context.read<LanguageCubit>().state.languageCode == 'ar';

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sleeping Date
              Text(
                context.trContext(TK.babySleepDate),
                style: context.text.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              8.h.height,
              DatePickerField(
                selectedDate: _selectedDate,
                onDateSelected: (d) => setState(() => _selectedDate = d),
                fillColor: context.theme.cardColor,
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
                          context.trContext(TK.babySleepStart),
                          style: context.text.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        8.h.height,
                        TimePickerField(
                          selectedTime: _startTime,
                          hint: '7:12 am',
                          onTimeSelected: (t) => setState(() => _startTime = t),
                          fillColor: context.theme.cardColor,
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
                          context.trContext(TK.babySleepEnd),
                          style: context.text.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        8.h.height,
                        TimePickerField(
                          selectedTime: _endTime,
                          hint: '10:52 am',
                          onTimeSelected: (t) => setState(() => _endTime = t),
                          fillColor: context.theme.cardColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              20.h.height,

              // Notes
              Text(
                context.trContext(TK.commonNotes),
                style: context.text.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              8.h.height,
              TextFormFieldHelper(
                controller: _notesController,
                hint: context.trContext(TK.babySleepNotes),
                maxLines: 10,
                minLines: 3,
                enableShadow: false,
                fillColor: context.theme.cardColor,
                borderRadius: BorderRadius.circular(16.r),
                borderColor: context.ext.colors.primaryDark,
              ),
              28.h.height,

              // Save button
              CustomElevatedButton(
                text: isLoading ? 'Saving...' : context.trContext(TK.babySleepSaveRecord),
                onPressed: isLoading ? null : () => _save(cubit),
                backgroundColor: context.theme.buttonTheme.colorScheme!.primary,
                minimumSize: Size(double.infinity, 52.h),
                textStyle: context.text.titleMedium!.copyWith(
                  color: context.theme.buttonTheme.colorScheme!.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              32.h.height,
              const Divider(),
              16.h.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'السجلات الأخيرة' : 'Recent Records',
                    style: context.text.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (cubit.sleepRecords.isNotEmpty)
                    Text(
                      '${cubit.sleepRecords.length}',
                      style: context.text.bodyMedium!.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              16.h.height,

              if (state is SleepRecordsLoading && cubit.sleepRecords.isEmpty)
                Skeletonizer(
                  enabled: true,
                  child: Column(
                    children: List.generate(
                      3,
                      (index) => SleepRecordListCard(
                        record: SleepRecordEntity(
                          recordId: index,
                          childId: 0,
                          childName: 'Baby',
                          sleepDate: DateTime.now(),
                          sleepHoursTotal: '08:00:00',
                          sleepHoursTotalFormatted: '8h 0m',
                          notes: 'Loading notes...',
                          status: 'Good',
                        ),
                        onDelete: () {},
                      ),
                    ),
                  ),
                )
              else if (state is SleepRecordsError && cubit.sleepRecords.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      state.errorMessage,
                      style: context.text.bodyMedium!.copyWith(
                        color: context.ext.colors.severityHigh,
                      ),
                    ),
                  ),
                )
              else if (cubit.sleepRecords.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Column(
                      children: [
                        Icon(
                          Icons.nights_stay_rounded,
                          size: 48.sp,
                          color: context.colors.onSurfaceVariant.withOpacity(0.3),
                        ),
                        12.h.height,
                        Text(
                          isAr ? 'لا توجد سجلات بعد' : 'No records yet',
                          style: context.text.bodyMedium!.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  children: cubit.sleepRecords.map((record) {
                    return SleepRecordListCard(
                      record: record,
                      isDeleting: cubit.deletingSleepRecordId == record.recordId,
                      onDelete: () {
                        if (activeChild != null) {
                          cubit.deleteSleepRecord(
                            childId: activeChild.childId,
                            recordId: record.recordId,
                          );
                        }
                      },
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }
}
