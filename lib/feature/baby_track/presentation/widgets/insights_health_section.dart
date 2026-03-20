import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/health_insight_item.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_section_card.dart';

/// The "Health Insights" section of the Insights tab,
/// displaying Sleep, Feeding, and Vaccine status rows.
class InsightsHealthSection extends StatelessWidget {
  const InsightsHealthSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Insights',
          style: AppStyles.styleInter16.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.lightTextPrimary,
          ),
        ),
        16.h.height,
        InsightsSectionCard(
          child: Column(
            children: [
              HealthInsightItem(
                icon: Icons.bedtime_rounded,
                iconColor: Colors.blue,
                iconBackground: Colors.blue.withAlpha(25),
                label: 'SLEEP',
                value: '7.5h avg',
              ),
              HealthInsightItem(
                icon: Icons.local_drink_rounded,
                iconColor: Colors.orange,
                iconBackground: Colors.orange.withAlpha(25),
                label: 'FEEDING',
                value: 'Consistent',
              ),
              HealthInsightItem(
                icon: Icons.vaccines_rounded,
                iconColor: AppColors.greenText,
                iconBackground: AppColors.backgroundGreen.withAlpha(40),
                label: 'VACCINES',
                value: 'Up to date',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
