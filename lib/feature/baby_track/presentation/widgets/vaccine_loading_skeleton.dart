import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_entity.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_progress_header.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_record_card.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_section_header.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_sub_tab.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Skeletonizer loading placeholder that mirrors the real vaccine tab layout.
class VaccineLoadingSkeleton extends StatelessWidget {
  const VaccineLoadingSkeleton({super.key});

  static final _dummyVaccine = VaccineEntity(
    childVaccineId: 0,
    childId: 0,
    scheduleId: 0,
    vaccineName: 'Hepatitis B (HepB) Vaccine',
    doseTiming: 'Birth Dose — Loading',
    diseasePrevented: 'Viral Hepatitis B Disease Loading',
    dosage: '0.5 ml',
    vaccinationWay: 'Intramuscular injection',
    ageInMonths: 0,
    scheduledDate: DateTime.now(),
    status: 'pending',
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress header placeholder
            const VaccineProgressHeader(
              completed: 3,
              total: 8,
              nextDueDate: 'Jan 01',
              daysUntilDue: 12,
            ),
            20.h.height,

            // Sub-tab bar placeholder
            Container(
              decoration: BoxDecoration(
                color: context.ext.colors.primaryTint,
                borderRadius: BorderRadius.circular(64.r),
              ),
              child: Row(
                children: [
                  VaccineSubTab(
                    label: context.trContext(TK.babyVaccineLog),
                    isSelected: true,
                    onTap: () {},
                  ),
                  VaccineSubTab(
                    label: context.trContext(TK.babyVaccineSchedule),
                    isSelected: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            16.h.height,

            // Overdue section placeholder
            VaccineSectionHeader(
              title: context.trContext(TK.babyVaccineOverdueMissed),
              count: 1,
              color: context.ext.colors.severityHigh,
            ),
            12.h.height,
            VaccineRecordCard(vaccine: _dummyVaccine),
            16.h.height,

            // Upcoming section placeholder
            VaccineSectionHeader(
              title: context.trContext(TK.babyVaccineUpcoming),
              count: 2,
              color: context.ext.colors.primaryDark,
            ),
            12.h.height,
            VaccineRecordCard(vaccine: _dummyVaccine),
            VaccineRecordCard(vaccine: _dummyVaccine),
          ],
        ),
      ),
    );
  }
}
