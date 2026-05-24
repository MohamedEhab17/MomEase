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
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';
import 'package:new_mama/core/helper/app_toast.dart';

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

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Frequency Counter Card
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: context.ext.colors.backgroundPink.withAlpha(51),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: context.ext.colors.primaryLighter.withAlpha(77),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: context.ext.colors.backgroundPink,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.cookie_outlined,
                            color: context.ext.colors.primaryDark,
                            size: 20.sp,
                          ),
                        ),
                        8.w.width,
                        Text(
                          context.trContext(TK.babyFeedingFrequency),
                          style: context.text.titleMedium!.copyWith(
                            color: context.ext.colors.primaryDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    20.h.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Decrement Button
                        GestureDetector(
                          onTap: _feedingTimesPerDay > 1
                              ? () => setState(() => _feedingTimesPerDay--)
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 52.w,
                            height: 52.h,
                            decoration: BoxDecoration(
                              color: _feedingTimesPerDay > 1
                                  ? context.theme.cardColor
                                  : context.theme.cardColor.withAlpha(100),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _feedingTimesPerDay > 1
                                    ? context.ext.colors.primaryDark.withAlpha(128)
                                    : context.ext.colors.lightTextDisabled.withAlpha(50),
                              ),
                            ),
                            child: Icon(
                              Icons.remove_rounded,
                              color: _feedingTimesPerDay > 1
                                  ? context.ext.colors.primaryDark
                                  : context.ext.colors.lightTextDisabled,
                              size: 28.sp,
                            ),
                          ),
                        ),
                        40.w.width,
                        // Large Counter Text
                        Text(
                          '$_feedingTimesPerDay',
                          style: context.text.headlineLarge!.copyWith(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.w900,
                            color: context.ext.colors.primaryDark,
                          ),
                        ),
                        40.w.width,
                        // Increment Button
                        GestureDetector(
                          onTap: _feedingTimesPerDay < 20
                              ? () => setState(() => _feedingTimesPerDay++)
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 52.w,
                            height: 52.h,
                            decoration: BoxDecoration(
                              color: _feedingTimesPerDay < 20
                                  ? context.theme.cardColor
                                  : context.theme.cardColor.withAlpha(100),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _feedingTimesPerDay < 20
                                    ? context.ext.colors.primaryDark.withAlpha(128)
                                    : context.ext.colors.lightTextDisabled.withAlpha(50),
                              ),
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              color: _feedingTimesPerDay < 20
                                  ? context.ext.colors.primaryDark
                                  : context.ext.colors.lightTextDisabled,
                              size: 28.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
            ],
          ),
        );
      },
    );
  }
}
