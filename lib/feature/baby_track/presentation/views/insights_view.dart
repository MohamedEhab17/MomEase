import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_baby_activity_section.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_health_section.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_helpful_suggestions_section.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_mother_wellness_section.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_stat_card.dart';

class InsightsView extends StatelessWidget {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22.sp,
            color: AppColors.primaryDark,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Baby Activity Insights',
          style: AppStyles.styleInter20.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top stat cards ──
            Row(
              children: [
                InsightsStatCard(
                  icon: Icons.favorite_rounded,
                  iconColor: AppColors.primaryDark,
                  label: 'Health Score',
                  value: 'Feeding',
                  background: AppColors.primaryExtraLight,
                ),
                SizedBox(width: 10.w),
                InsightsStatCard(
                  icon: Icons.mood_rounded,
                  iconColor: Colors.orange,
                  label: 'Mom Mood',
                  value: 'Calm / Tired',
                  background: Colors.orange.withAlpha(25),
                ),
                SizedBox(width: 10.w),
                InsightsStatCard(
                  icon: Icons.check_circle_rounded,
                  iconColor: AppColors.greenText,
                  label: 'Coping Rate',
                  value: 'Good',
                  background: AppColors.backgroundGreen.withAlpha(40),
                ),
              ],
            ),
            24.h.height,

            // ── Sections ──
            const InsightsBabyActivitySection(),
            24.h.height,

            const InsightsHealthSection(),
            24.h.height,

            const InsightsMotherWellnessSection(),
            24.h.height,

            const InsightsHelpfulSuggestionsSection(),
            20.h.height,
          ],
        ),
      ),
    );
  }
}
