import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/data/dummy/baby_track_dummy_data.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/feeding_insights_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/feeding_insights_state.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/feeding_frequency_chart.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_section_card.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/sleep_duration_chart.dart';
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';

class InsightsBabyActivitySection extends StatelessWidget {
  const InsightsBabyActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.trContext(TK.babyActivity),
          style: context.text.titleLarge!.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colors.onSurface,
          ),
        ),
        20.h.height,
        BlocBuilder<FeedingInsightsCubit, FeedingInsightsState>(
          builder: (context, state) {
            if (state is FeedingInsightsLoading || state is FeedingInsightsInitial) {
              return _buildLoadingSkeleton(context);
            } else if (state is FeedingInsightsLoaded) {
              return InsightsSectionCard(
                child: FeedingFrequencyChart(
                  weeklyRecords: state.weeklyRecords,
                  monthlyRecords: state.monthlyRecords,
                  statistics: state.statistics,
                ),
              );
            } else if (state is FeedingInsightsError) {
              return _buildErrorWidget(context, state.errorMessage);
            }
            return const SizedBox.shrink();
          },
        ),
        16.h.height,
        InsightsSectionCard(
          child: SleepDurationChart(points: sleepDurationPoints),
        ),
      ],
    );
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 240.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.ext.colors.severitySevereBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.ext.colors.severitySevere.withAlpha(50)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: context.ext.colors.severitySevere,
            size: 36.sp,
          ),
          8.h.height,
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium!.copyWith(
              color: context.ext.colors.severitySevere,
              fontWeight: FontWeight.w500,
            ),
          ),
          12.h.height,
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.ext.colors.severitySevere,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
            onPressed: () {
              final activeChild = context.read<ActiveChildCubit>().state;
              if (activeChild != null) {
                context.read<FeedingInsightsCubit>().loadFeedingInsights(activeChild.childId);
              }
            },
            icon: Icon(Icons.refresh_rounded, size: 18.sp),
            label: Text(
              'Retry',
              style: context.text.bodyMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
