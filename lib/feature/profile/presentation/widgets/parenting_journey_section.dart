import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/feature/profile/data/models/profile_model.dart';
import 'package:new_mama/feature/profile/presentation/widgets/parenting_journey_item_tile.dart';

class ParentingJourneySection extends StatelessWidget {
  final ParentingJourney journey;

  const ParentingJourneySection({super.key, required this.journey});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(21),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          8.height,
          ParentingJourneyItemTile(
            leadingIcon: Text(
              journey.lastMoodEmoji,
              style: TextStyle(fontSize: 18.sp),
            ),
            title: "Last Mood",
            statusText: journey.lastMoodStatus,
            statusColor: journey.lastMoodColor,
          ),

          ParentingJourneyItemTile(
            leadingIcon: const Icon(
              Icons.bar_chart_rounded,
              size: 20,
              color: AppColors.greyPrimary,
            ),
            title: "Depression Test",
            statusText: journey.depressionTestStatus,
            statusColor: journey.depressionTestColor,
            onTap: () {
              context.push(AppRoutesPaths.depressionView);
            },
          ),

          ParentingJourneyItemTile(
            leadingIcon: SvgPicture.asset(
              AppIcons.iconsBabyTracing,
              width: 20.w,
              colorFilter: const ColorFilter.mode(
                AppColors.greyPrimary,
                BlendMode.srcIn,
              ),
            ),
            title: "Baby Tracking",
            statusText: journey.babyTrackingStatus,
            statusColor: journey.babyTrackingColor,
            onTap: () {
              // Assuming no specific view is ready yet or navigate to home?
              // For now, let's leave as a placeholder or push to home view if tracking is missing
            },
          ),
          8.height,
        ],
      ),
    );
  }
}
