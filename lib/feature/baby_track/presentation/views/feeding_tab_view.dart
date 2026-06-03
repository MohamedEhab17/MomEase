import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/baby_track/data/models/add_feeding_record_request_model.dart';
import 'package:new_mama/feature/baby_track/data/models/baby_track_models.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/baby_track_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/date_picker_field.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/feeding_type_chip_selector.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/feeding_chart/feeding_frequency_counter.dart';
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/localization/cubit/language_cubit.dart';
import 'package:new_mama/feature/baby_track/domain/entities/feeding_record_entity.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/feeding_record_list_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FeedingTabView extends StatefulWidget {
  const FeedingTabView({super.key});

  @override
  State<FeedingTabView> createState() => _FeedingTabViewState();
}

class _FeedingTabViewState extends State<FeedingTabView> {
  FeedingType _selectedType = FeedingType.breastfeeding;
  DateTime? _selectedDate;
  int _feedingTimesPerDay = 1;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _mapFeedingTypeToString(FeedingType type) {
    switch (type) {
      case FeedingType.breastfeeding:
        return 'Breastfeeding';
      case FeedingType.formulaFeeding:
        return 'Formula';
      case FeedingType.solidfood:
        return 'SolidFood';
    }
  }

  void _save(BabyTrackCubit cubit) {
    if (_selectedDate == null) {
      AppToast.warning(
        context,
        message: context.trContext(TK.babyFeedingSelectDate),
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

    if (_feedingTimesPerDay < 1 || _feedingTimesPerDay > 20) {
      AppToast.warning(
        context,
        message: 'Feeding times per day must be between 1 and 20.',
      );
      return;
    }

    cubit.saveFeedingRecord(
      childId: activeChild.childId,
      request: AddFeedingRecordRequestModel(
        feedingDate: _selectedDate!,
        feedingTimesPerDay: _feedingTimesPerDay,
        feedingTypeForBaby: _mapFeedingTypeToString(_selectedType),
        notes: _notesController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BabyTrackCubit, BabyTrackState>(
      listener: (context, state) {
        if (state is FeedingRecordSaved) {
          _notesController.clear();
          setState(() {
            _selectedDate = null;
            _feedingTimesPerDay = 1;
            _selectedType = FeedingType.breastfeeding;
          });
          AppToast.success(
            context,
            message: context.trContext(TK.babyFeedingSaved),
          );
        } else if (state is FeedingRecordError) {
          AppToast.error(
            context,
            message: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<BabyTrackCubit>();
        final isLoading = state is FeedingRecordLoading;
        final activeChild = context.read<ActiveChildCubit>().state;
        final isAr = context.read<LanguageCubit>().state.languageCode == 'ar';

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Frequency Counter Card
              FeedingFrequencyCounter(
                count: _feedingTimesPerDay,
                onChanged: (val) => setState(() => _feedingTimesPerDay = val),
              ),

              28.h.height,

              // Feeding Type Section
              Text(
                context.trContext(TK.babyFeedingType),
                style: context.text.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              10.h.height,
              FeedingTypeChipSelector(
                selectedType: _selectedType,
                onSelected: (t) => setState(() => _selectedType = t),
              ),
              20.h.height,

              // Feeding Date Section
              Text(
                context.trContext(TK.babyFeedingDate),
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

              // Notes Section
              Text(
                context.trContext(TK.commonNotes),
                style: context.text.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              8.h.height,
              TextFormFieldHelper(
                controller: _notesController,
                hint: context.trContext(TK.babyFeedingNotesHint),
                maxLines: 10,
                minLines: 3,
                enableShadow: false,
                borderRadius: BorderRadius.circular(16.r),
                fillColor: context.theme.cardColor,
                borderColor: context.ext.colors.primaryDark,
              ),
              28.h.height,

              // Save button
              CustomElevatedButton(
                text: isLoading ? 'Saving...' : context.trContext(TK.babyFeedingSaveSession),
                onPressed: isLoading ? null : () => _save(cubit),
                backgroundColor: context.theme.buttonTheme.colorScheme!.primary,
                minimumSize: Size(double.infinity, 52.h),
                textStyle: context.text.titleLarge!.copyWith(
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
                  if (cubit.feedingRecords.isNotEmpty)
                    Text(
                      '${cubit.feedingRecords.length}',
                      style: context.text.bodyMedium!.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              16.h.height,

              if (state is FeedingRecordsLoading && cubit.feedingRecords.isEmpty)
                Skeletonizer(
                  enabled: true,
                  child: Column(
                    children: List.generate(
                      3,
                      (index) => FeedingRecordListCard(
                        record: FeedingRecordEntity(
                          recordId: index,
                          childId: 0,
                          childName: 'Baby',
                          feedingDate: DateTime.now(),
                          feedingTimesPerDay: 8,
                          feedingTypeForBaby: 'Breastfeeding',
                          feedingType: 'Normal',
                          notes: 'Loading notes...',
                          referenceInfo: const {
                            "minTimesPerDay": 8,
                            "maxTimesPerDay": 12,
                            "ageRange": "0-6 months"
                          },
                        ),
                        onDelete: () {},
                      ),
                    ),
                  ),
                )
              else if (state is FeedingRecordsError && cubit.feedingRecords.isEmpty)
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
              else if (cubit.feedingRecords.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Column(
                      children: [
                        Icon(
                          Icons.restaurant_rounded,
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
                  children: cubit.feedingRecords.map((record) {
                    return FeedingRecordListCard(
                      record: record,
                      isDeleting: cubit.deletingFeedingRecordId == record.recordId,
                      onDelete: () {
                        if (activeChild != null) {
                          cubit.deleteFeedingRecord(
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
