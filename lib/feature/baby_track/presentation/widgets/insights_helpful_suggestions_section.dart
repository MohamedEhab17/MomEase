import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insight_suggestion_card.dart';

/// The "Helpful Suggestions" section of the Insights tab.
class InsightsHelpfulSuggestionsSection extends StatelessWidget {
  const InsightsHelpfulSuggestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Helpful Suggestions',
          style: AppStyles.styleInter16.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.lightTextPrimary,
          ),
        ),
        16.h.height,
        const InsightSuggestionCard(
          icon: Icons.nightlight_round,
          title: 'Earlier Bedtime Suggestion',
          body:
              'Baby slept less than usual yesterday. Consider an earlier bedtime today to avoid over-tiredness.',
        ),
        12.h.height,
        const InsightSuggestionCard(
          icon: Icons.local_drink_rounded,
          title: 'Feeding Interval Reminder',
          body:
              'Your feeding intervals have been consistent. Keep up the great work, mama!',
        ),
      ],
    );
  }
}
