import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/feature/baby_track/data/dummy/baby_track_dummy_data.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/baby_track_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_progress_header.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_record_card.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_sub_tab.dart';

class VaccineTabView extends StatelessWidget {
  const VaccineTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BabyTrackCubit, BabyTrackState>(
      builder: (context, state) {
        final cubit = context.read<BabyTrackCubit>();
        final tabIdx = state is VaccineTabState
            ? state.tabIndex
            : cubit.vaccineTabIndex;
        final records = tabIdx == 0
            ? dummyVaccineRecords
            : dummyOfficialScheduleRecords;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress header
              const VaccineProgressHeader(
                completed: 8,
                total: 12,
                nextDueDate: 'Oct 15',
                daysUntilDue: 13,
              ),
              20.h.height,

              // Sub-tab switcher: Baby's Log / Official Schedule
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(64.r),
                ),
                child: Row(
                  children: [
                    VaccineSubTab(
                      label: "Baby's Log",
                      isSelected: tabIdx == 0,
                      onTap: () => cubit.switchVaccineTab(0),
                    ),
                    VaccineSubTab(
                      label: 'Official Schedule',
                      isSelected: tabIdx == 1,
                      onTap: () => cubit.switchVaccineTab(1),
                    ),
                  ],
                ),
              ),
              16.h.height,

              // Records list with staggered animation
              ...List.generate(
                records.length,
                (i) => TweenAnimationBuilder<double>(
                  key: ValueKey('${tabIdx}_$i'),
                  duration: Duration(milliseconds: 200 + i * 60),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOut,
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 20),
                      child: child,
                    ),
                  ),
                  child: VaccineRecordCard(
                    record: records[i],
                    animationIndex: i,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
