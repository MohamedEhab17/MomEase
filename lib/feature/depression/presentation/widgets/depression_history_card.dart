import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/depression/domain/entities/assessment_result.dart';

class DepressionHistoryCard extends StatelessWidget {
  const DepressionHistoryCard({
    super.key,
    required this.result,
    this.onTap,
  });

  final AssessmentResult result;
  final VoidCallback? onTap;

  Color _getLevelColor(String levelName) {
    final lower = levelName.toLowerCase();
    if (lower.contains('minimal')) return const Color(0xFF4CAF50); // Green
    if (lower.contains('mild')) return const Color(0xFFFFC107); // Amber
    if (lower.contains('moderate')) return const Color(0xFFFF9800); // Orange
    if (lower.contains('severe')) return const Color(0xFFF44336); // Red
    return const Color(0xFF9E9E9E); // Grey
  }

  @override
  Widget build(BuildContext context) {
    final local = DateTime.tryParse(result.completedAt)?.toLocal() ?? DateTime.now();
    final formattedDate =
        '${local.day.toString().padLeft(2, '0')} / ${local.month.toString().padLeft(2, '0')} / ${local.year}  ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';

    final levelColor = _getLevelColor(result.severity);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: levelColor.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: levelColor.withAlpha(30),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: levelColor.withAlpha(20),
          highlightColor: levelColor.withAlpha(10),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: levelColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: levelColor.withAlpha(60)),
                      ),
                      child: Text(
                        result.severity,
                        style: context.text.labelMedium!.copyWith(
                          color: levelColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: context.theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Score: ${result.score}',
                        style: context.text.titleSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.ext.colors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                Text(
                  result.description,
                  style: context.text.bodyMedium!.copyWith(
                    color: context.ext.colors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
                16.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 16.w,
                      color: context.colors.onSurface.withAlpha(110),
                    ),
                    6.horizontalSpace,
                    Text(
                      formattedDate,
                      style: context.text.bodySmall!.copyWith(
                        color: context.colors.onSurface.withAlpha(130),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
