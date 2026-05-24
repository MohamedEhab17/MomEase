import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/baby_track/data/models/baby_track_models.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/baby_track_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/date_picker_field.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/duration_timer_display.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/feeding_type_chip_selector.dart';

class FeedingTabView extends StatefulWidget {
  const FeedingTabView({super.key});

  @override
  State<FeedingTabView> createState() => _FeedingTabViewState();
}

class _FeedingTabViewState extends State<FeedingTabView> {
  FeedingType _selectedType = FeedingType.breastfeeding;

  DateTime? _selectedDate;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _save(BabyTrackCubit cubit) {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.trContext(TK.babyFeedingSelectDate)),
          backgroundColor: context.ext.colors.primaryDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    cubit.saveFeedingSession(
      FeedingSession(
        id: DateTime.now().toIso8601String(),
        type: _selectedType,
        date: _selectedDate!,
        durationSeconds: cubit.elapsedSeconds,
        notes: _notesController.text,
      ),
    );
    _notesController.clear();
    setState(() => _selectedDate = null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.trContext(TK.babyFeedingSaved)),
        backgroundColor: context.ext.colors.greenText,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BabyTrackCubit, BabyTrackState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<BabyTrackCubit>();
        final elapsed = state is FeedingTimerState ? state.elapsedSeconds : 0;
        final isRunning = state is FeedingTimerState ? state.isRunning : false;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timer
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: context.ext.colors.primaryLighter.withAlpha(51),
                  borderRadius: BorderRadius.circular(16.r),

                  border: Border.all(
                    color: context.ext.colors.primaryLighter.withAlpha(77),
                  ),
                ),
                child: Column(
                  children: [
                    Center(
                      child: DurationTimerDisplay(elapsedSeconds: elapsed),
                    ),
                    20.h.height,
                    // Start/Stop button with spinner
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 12.w,
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              text: isRunning
                                  ? context.trContext(TK.babyFeedingStopSession)
                                  : context.trContext(TK.babyFeedingStartSession),
                              onPressed: () {
                                if (isRunning) {
                                  cubit.stopFeedingTimer();
                                } else {
                                  cubit.startFeedingTimer();
                                }
                              },
                              backgroundColor: isRunning
                                  ? context
                                        .theme
                                        .buttonTheme
                                        .colorScheme!
                                        .tertiary
                                  : context
                                        .theme
                                        .buttonTheme
                                        .colorScheme!
                                        .primary,
                              // minimumSize: Size(220.w, 48.h),
                              textStyle: context.text.titleLarge!.copyWith(
                                color: context
                                    .theme
                                    .buttonTheme
                                    .colorScheme!
                                    .onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              icon: isRunning
                                  ? Icon(
                                      Icons.stop_rounded,
                                      color: context
                                          .theme
                                          .buttonTheme
                                          .colorScheme!
                                          .onPrimary,
                                      size: 20.sp,
                                    )
                                  : Icon(
                                      Icons.play_arrow_rounded,
                                      color: context
                                          .theme
                                          .buttonTheme
                                          .colorScheme!
                                          .onPrimary,
                                      size: 20.sp,
                                    ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () => cubit.resetFeedingTimer(),
                            child: Container(
                              padding: 10.allPadding,
                              decoration: BoxDecoration(
                                color: context.theme.cardColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.ext.colors.textDisabledLighter
                                      .withAlpha(77),
                                ),
                              ),
                              child: SvgPicture.asset(
                                AppIcons.iconsRestart,
                                width: 24.w,
                                height: 24.h,
                                colorFilter: ColorFilter.mode(
                                  context.colors.onSurface,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              28.h.height,

              // Feeding Type
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

              // Feeding Date
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
                text: context.trContext(TK.babyFeedingSaveSession),
                onPressed: () => _save(cubit),
                backgroundColor: context.theme.buttonTheme.colorScheme!.primary,
                // context.ext.colors.primaryDark,
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
