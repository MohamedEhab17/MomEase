import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/domain/entities/vaccine_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

String _formatDateFull(DateTime dt) {
  final h = dt.hour > 12
      ? dt.hour - 12
      : dt.hour == 0
      ? 12
      : dt.hour;
  final min = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} • $h:$min $period';
}

class VaccineRecordCard extends StatelessWidget {
  final VaccineEntity vaccine;
  final int animationIndex;
  final VoidCallback? onMarkTaken;
  final bool isUpdating;

  const VaccineRecordCard({
    super.key,
    required this.vaccine,
    this.animationIndex = 0,
    this.onMarkTaken,
    this.isUpdating = false,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = vaccine.status.toLowerCase() == 'done';
    final isMissed = vaccine.status.toLowerCase() == 'missed';

    Color statusBgColor;
    Color statusTextColor;
    String statusLabel = vaccine.status;

    if (isCompleted) {
      statusBgColor = context.ext.colors.backgroundGreen.withValues(alpha: 40);
      statusTextColor = context.ext.colors.greenText;
      statusLabel = context.trContext(TK.babyVaccineCompleted);
    } else if (isMissed) {
      statusBgColor = context.ext.colors.severityHighBg;
      statusTextColor = context.ext.colors.severityHigh;
      statusLabel = context.trContext(TK.babyVaccineOverdueMissed);
    } else {
      statusBgColor = context.ext.colors.primaryExtraLight;
      statusTextColor = context.ext.colors.primaryDark;
      statusLabel = context.trContext(TK.babyVaccinePending);
    }

    return Skeletonizer(
      enabled: isUpdating,
      child: Container(
        margin: 16.bottomPadding,
        padding: 16.allPadding,
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow,
              blurRadius: 8,
              blurStyle: BlurStyle.outer,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Theme(
          data: context.theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.only(top: 8.h),
          shape: const Border(),
          collapsedShape: const Border(),
          title: Row(
            crossAxisAlignment: .center,
            children: [
              // Left: icon circle
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: statusBgColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isUpdating
                      ? Skeletonizer(
                          enabled: true,
                          child: Icon(
                            Icons.vaccines_rounded,
                            size: 18.sp,
                            color: statusTextColor,
                          ),
                        )
                      : Icon(
                          isCompleted
                              ? Icons.check_circle_rounded
                              : isMissed
                              ? Icons.warning_rounded
                              : Icons.vaccines_rounded,
                          size: 18.sp,
                          color: statusTextColor,
                        ),
                ),
              ),
             
            12.w.width,
              // Middle: text info
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      vaccine.vaccineName,
                      style: context.text.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.colors.onSurface,
                      ),
                    ),
                    2.h.height,
                    Text(
                      '${vaccine.doseTiming} • ${vaccine.dosage}',
                      style: context.text.bodyMedium!.copyWith(
                        color: context.colors.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              8.w.height,
              // Right: status badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  statusLabel,
                  style: context.text.bodySmall!.copyWith(
                    color: statusTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          children: [
            Divider(
              color: context.ext.colors.primaryLighter.withValues(alpha: 50),
            ),
           4.h.height,
            _buildDetailRow(
              context,
              context.trContext(TK.babyVaccineDiseasePrevented),
              vaccine.diseasePrevented,
            ),
            _buildDetailRow(
              context,
              context.trContext(TK.babyVaccineWayOfInjection),
              vaccine.vaccinationWay,
            ),
            _buildDetailRow(
              context,
              context.trContext(TK.babyVaccineScheduledDate),
              _formatDateFull(vaccine.scheduledDate),
            ),
            if (vaccine.takenDate != null)
              _buildDetailRow(
                context,
                context.trContext(TK.babyVaccineTakenDate),
                _formatDateFull(vaccine.takenDate!),
              ),
            if (!isCompleted && onMarkTaken != null) ...[
              12.h.height,
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: isUpdating ? null : onMarkTaken,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.ext.colors.primaryDark,
                    foregroundColor: context.ext.colors.primaryExtraLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                  ),
                  icon: Icon(Icons.check_rounded, size: 16.sp),
                  label: Text(
                    context.trContext(TK.babyVaccineMarkAsTakenBtn),
                    style: context.text.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.ext.colors.primaryExtraLight,
                    ),
                  ),
                ),
              ),
            ],]
        ),
      ),
    ),
  );
}

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: context.text.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.text.bodyMedium!.copyWith(
                color: context.colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
