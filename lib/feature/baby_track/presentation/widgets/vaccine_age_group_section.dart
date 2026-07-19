import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_entity.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_group_entity.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_record_card.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/vaccine_section_header.dart';

class VaccineAgeGroupSection extends StatelessWidget {
  final VaccineGroupEntity group;
  final int childId;
  final int? updatingVaccineId;
  final void Function(VaccineEntity) onMarkTaken;

  const VaccineAgeGroupSection({
    super.key,
    required this.group,
    required this.childId,
    required this.updatingVaccineId,
    required this.onMarkTaken,
  });

  @override
  Widget build(BuildContext context) {
    final localizedAgeLabel = group.ageInMonths == 0
        ? context.trContext(TK.babyVaccineAtBirth)
        : context.trContext(
            TK.babyVaccineMonthsSuffix,
            namedArgs: {'months': group.ageInMonths.toString()},
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
          child: Row(
            children: [
              Icon(
                Icons.hourglass_empty_rounded,
                size: 16.sp,
                color: context.ext.colors.primaryDark,
              ),
              8.width,
              VaccineSectionHeader(
                title: localizedAgeLabel,
                count: group.vaccines.length,
                color: context.ext.colors.primaryDark,
              ),
            ],
          ),
        ),
        ...group.vaccines.map(
          (vaccine) => VaccineRecordCard(
            key: ValueKey('group_${vaccine.childVaccineId}'),
            vaccine: vaccine,
            isUpdating: updatingVaccineId == vaccine.childVaccineId,
            onMarkTaken: () => onMarkTaken(vaccine),
          ),
        ),
        12.h.height,
      ],
    );
  }
}
