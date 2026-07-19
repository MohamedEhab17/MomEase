import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
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
          context.trContext(TK.babyHealthInsights),
          style: context.text.titleLarge!.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colors.onSurface,
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
                label: context.trContext(TK.babySleepLabel),
                value: '7.5h avg', // TODO: Localize or dynamic
              ),
              HealthInsightItem(
                icon: Icons.local_drink_rounded,
                iconColor: Colors.orange,
                iconBackground: Colors.orange.withAlpha(25),
                label: context.trContext(TK.babyFeedingLabel),
                value: context.trContext(TK.babyFeedingConsistent),
              ),
              HealthInsightItem(
                icon: Icons.vaccines_rounded,
                iconColor: context.ext.colors.greenText,
                iconBackground: context.ext.colors.backgroundGreen.withAlpha(
                  40,
                ),
                label: context.trContext(TK.babyVaccinesLabel),
                value: context.trContext(TK.babyVaccinesUpToDate),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
