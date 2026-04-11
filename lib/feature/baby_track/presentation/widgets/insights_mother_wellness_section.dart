import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/baby_track/data/dummy/baby_track_dummy_data.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_section_card.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/mood_trend_chart.dart';

/// The "Mother Wellness" section of the Insights tab,
/// showing the mood trend chart, current mood, and depression test status.
class InsightsMotherWellnessSection extends StatelessWidget {
  const InsightsMotherWellnessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mother Wellness',
          style: context.text.titleLarge!.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colors.onSurface,
          ),
        ),
        16.h.height,
        InsightsSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MoodTrendChart(points: moodTrendPoints),
              16.h.height,
              _WellnessRow(
                icon: Icons.emoji_emotions_rounded,
                iconColor: Colors.amber,
                label: 'Current Mood',
                trailing: Text(
                  'Calm',
                  style: context.text.titleSmall!.copyWith(
                    color: context.ext.colors.primaryDark,
                    fontWeight: .w600,
                  ),
                  textAlign: .center,
                ),
              ),
              12.h.height,
              _WellnessRow(
                icon: Icons.assignment_rounded,
                iconColor: context.ext.colors.greenText,
                label: 'Depression Test',
                trailing: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: context.ext.colors.backgroundGreen.withAlpha(50),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'COMPLETED',
                    style: context.text.bodySmall!.copyWith(
                      color: context.ext.colors.greenText,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A reusable label + trailing row used inside Mother Wellness section.
class _WellnessRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Widget trailing;

  const _WellnessRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18.sp, color: iconColor),
            SizedBox(width: 8.w),
            Text(label, style: context.text.titleSmall!),
          ],
        ),
        Padding(padding: 6.hPadding, child: trailing),
      ],
    );
  }
}
