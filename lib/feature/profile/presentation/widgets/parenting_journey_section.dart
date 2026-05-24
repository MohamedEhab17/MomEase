import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/feature/profile/presentation/widgets/parenting_journey_item_tile.dart';

class ParentingJourneySection extends StatelessWidget {
  final String? lastMoodEmoji;
  final String? lastMoodStatus;
  final String? depressionTestStatus;
  final String? babyTrackingStatus;

  const ParentingJourneySection({
    super.key,
    this.lastMoodEmoji,
    this.lastMoodStatus,
    this.depressionTestStatus,
    this.babyTrackingStatus,
  });

  String _getLocalizedStatus(BuildContext context, String? status) {
    if (status == null || status.isEmpty) return '---';
    switch (status) {
      case "Calm":
        return context.trContext(TK.babyCalm);
      case "Completed":
        return context.trContext(TK.babyCompletedStatus);
      case "Updated today":
        return context.trContext(TK.profileUpdatedToday);
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.ext.colors.primaryBackground,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withAlpha(21),
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
              lastMoodEmoji ?? "😊",
              style: TextStyle(fontSize: 18.sp),
            ),
            title: context.trContext(TK.profileLastMood),
            statusText: _getLocalizedStatus(context, lastMoodStatus),
            statusColor: context.colors.primary,
          ),
          ParentingJourneyItemTile(
            leadingIcon: Icon(
              Icons.bar_chart_rounded,
              size: 20,
              color: context.ext.colors.greyPrimary,
            ),
            title: context.trContext(TK.profileDepression),
            statusText: _getLocalizedStatus(context, depressionTestStatus),
            statusColor: context.colors.primary,
            onTap: () {
              context.push(AppRoutesPaths.depressionView);
            },
          ),
          ParentingJourneyItemTile(
            leadingIcon: SvgPicture.asset(
              AppIcons.iconsBabyTracing,
              width: 20.w,
              colorFilter: ColorFilter.mode(
                context.ext.colors.greyPrimary,
                BlendMode.srcIn,
              ),
            ),
            title: context.trContext(TK.profileTracking),
            statusText: _getLocalizedStatus(context, babyTrackingStatus),
            statusColor: context.colors.primary,
            onTap: () {
              context.push(AppRoutesPaths.babyTrackView);
            },
          ),
          8.height,
        ],
      ),
    );
  }
}
