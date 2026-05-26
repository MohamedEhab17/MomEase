import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/feeding_insights_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_baby_activity_section.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_health_section.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_helpful_suggestions_section.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_mother_wellness_section.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_stat_card.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';
import 'package:new_mama/feature/children/presentation/widgets/premium_child_selector.dart';

class InsightsView extends StatefulWidget {
  const InsightsView({super.key});

  @override
  State<InsightsView> createState() => _InsightsViewState();
}

class _InsightsViewState extends State<InsightsView> {
  @override
  void initState() {
    super.initState();
    final activeChild = context.read<ActiveChildCubit>().state;
    if (activeChild != null) {
      context.read<FeedingInsightsCubit>().loadFeedingInsights(activeChild.childId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActiveChildCubit, Child?>(
      listener: (context, activeChild) {
        if (activeChild != null) {
          context.read<FeedingInsightsCubit>().loadFeedingInsights(activeChild.childId);
        }
      },
      child: Scaffold(
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
            context.trContext(TK.babyInsightsTitle),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PremiumChildSelector(),
              12.h.height,
              // ── Top stat cards ──
              Row(
                children: [
                  InsightsStatCard(
                    icon: Icons.favorite_rounded,
                    iconColor: context.ext.colors.primaryDark,
                    label: context.trContext(TK.babyHealthScore),
                    value: context.trContext(TK.babyFeedingLabel),
                    background: context.ext.colors.primaryDark,
                  ),
                  SizedBox(width: 10.w),
                  InsightsStatCard(
                    icon: Icons.mood_rounded,
                    iconColor: Colors.orange,
                    label: context.trContext(TK.babyMomMood),
                    value: context.trContext(TK.babyCalm),
                    background: Colors.orange,
                  ),
                  SizedBox(width: 10.w),
                  InsightsStatCard(
                    icon: Icons.check_circle_rounded,
                    iconColor: context.ext.colors.greenText,
                    label: context.trContext(TK.babyCopingRate),
                    value: context.trContext(TK.babyGood),
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
      ),
    );
  }
}
