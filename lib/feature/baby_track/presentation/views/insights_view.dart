import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
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
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22.sp,
            color: context.ext.colors.primaryDark,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Baby Activity Insights',
          style: context.text.headlineMedium!.copyWith(
            fontWeight: FontWeight.w600,
            color: context.ext.colors.primaryDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // ── Top stat cards ──
            Row(
              children: [
                InsightsStatCard(
                  icon: Icons.favorite_rounded,
                  iconColor: context.ext.colors.primaryDark,
                  label: 'Health Score',
                  value: 'Feeding',
                  background: context.ext.colors.primaryDark,
                ),
                SizedBox(width: 10.w),
                InsightsStatCard(
                  icon: Icons.mood_rounded,
                  iconColor: Colors.orange,
                  label: 'Mom Mood',
                  value: 'Calm / Tired',
                  background: Colors.orange,
                ),
                SizedBox(width: 10.w),
                InsightsStatCard(
                  icon: Icons.check_circle_rounded,
                  iconColor: context.ext.colors.greenText,
                  label: 'Coping Rate',
                  value: 'Good',
                  background: context.ext.colors.backgroundGreen,
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
