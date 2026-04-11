import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/feature/baby_track/data/dummy/baby_track_dummy_data.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/feeding_frequency_chart.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_section_card.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/sleep_duration_chart.dart';

/// The "Baby Activity Overview" section of the Insights tab,
/// showing Feeding Frequency and Sleep Duration charts.
class InsightsBabyActivitySection extends StatelessWidget {
  const InsightsBabyActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Baby Activity Overview',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        20.h.height,
        InsightsSectionCard(
          child: FeedingFrequencyChart(data: feedingFrequencyData),
        ),
        16.h.height,
        InsightsSectionCard(
          child: SleepDurationChart(points: sleepDurationPoints),
        ),
      ],
    );
  }
}
