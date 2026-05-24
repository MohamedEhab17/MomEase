import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
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
          context.trContext(TK.babyHelpfulSuggestions),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        16.h.height,
        InsightSuggestionCard(
          icon: Icons.nightlight_round,
          title: context.trContext(TK.babyBedtimeSugTitle),
          body: context.trContext(TK.babyBedtimeSugBody),
        ),
        12.h.height,
        InsightSuggestionCard(
          icon: Icons.local_drink_rounded,
          title: context.trContext(TK.babyFeedingSugTitle),
          body: context.trContext(TK.babyFeedingSugBody),
        ),
      ],
    );
  }
}
