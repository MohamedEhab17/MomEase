import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/feeding_insights_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/sleep_insights_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/view_model/growth_insights_cubit.dart';
import 'package:new_mama/feature/baby_track/presentation/widgets/insights_baby_activity_section.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';
import 'package:new_mama/feature/children/presentation/widgets/premium_child_selector.dart';

class InsightsView extends StatelessWidget {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SleepInsightsCubit>(
      create: (ctx) {
        final cubit = getIt<SleepInsightsCubit>();
        final activeChild = ctx.read<ActiveChildCubit>().state;
        if (activeChild != null) {
          cubit.loadSleepInsights(activeChild.childId);
        }
        return cubit;
      },
      child: BlocProvider<GrowthInsightsCubit>(
        create: (ctx) {
          final cubit = getIt<GrowthInsightsCubit>();
          final activeChild = ctx.read<ActiveChildCubit>().state;
          if (activeChild != null) {
            cubit.loadGrowthInsights(activeChild.childId);
          }
          return cubit;
        },
        child: _InsightsViewBody(),
      ),
    );
  }
}

class _InsightsViewBody extends StatefulWidget {
  @override
  State<_InsightsViewBody> createState() => _InsightsViewBodyState();
}

class _InsightsViewBodyState extends State<_InsightsViewBody> {
  @override
  void initState() {
    super.initState();
    final activeChild = context.read<ActiveChildCubit>().state;
    if (activeChild != null) {
      context.read<FeedingInsightsCubit>().loadFeedingInsights(
        activeChild.childId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActiveChildCubit, Child?>(
      listener: (context, activeChild) {
        if (activeChild != null) {
          context.read<FeedingInsightsCubit>().loadFeedingInsights(
            activeChild.childId,
          );
          context.read<SleepInsightsCubit>().loadSleepInsights(
            activeChild.childId,
          );
          context.read<GrowthInsightsCubit>().loadGrowthInsights(
            activeChild.childId,
          );
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
              24.h.height,

              // ── Sections ──
              const InsightsBabyActivitySection(),
              24.h.height,

              24.h.height,
            ],
          ),
        ),
      ),
    );
  }
}
