import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/depression/presentation/view_model/assessments_cubit/assessments_state.dart';
import 'package:new_mama/feature/depression/presentation/view_model/assessments_cubit/assessments_cubit.dart';
import 'package:new_mama/feature/depression/presentation/widgets/depression_test_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DepressionTestOptionsView extends StatelessWidget {
  const DepressionTestOptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FeaturesHeader(
        title: context.trContext(TK.depressionAppBarTitle),
        onPressed: () {
          context.go(AppRoutesPaths.appSectionView);
        },
        trailingAction: IconButton(
          onPressed: () {
            context.push(AppRoutesPaths.depressionHistoryView);
          },
          icon: Icon(
            Icons.history_rounded,
            color: context.ext.colors.primaryDark,
            size: 26.w,
          ),
          tooltip: context.trContext(TK.skinHistoryTitle),
        ),
      ),
      body: BlocBuilder<AssessmentsCubit, AssessmentsState>(
        builder: (context, state) {
          if (state is AssessmentsLoading) {
            return Skeletonizer(
              enabled: true,
              child: _buildList(
                context,
                itemCount: 4,
                itemBuilder: (context, index) => DepressionTestCard(
                  cardImage: AppIcons.iconsPrivate,
                  depressionTestTitle: 'Skeleton Loading Title',
                  depressionTestSubtitle:
                      'Skeleton Loading Description text that is usually longer',
                  questionCount: 4,
                  onPressed: () {},
                ),
              ),
            );
          } else if (state is AssessmentsLoaded) {
            final assessments = state.assessments;
            return _buildList(
              context,
              itemCount: assessments.length,
              itemBuilder: (context, index) {
                final assessment = assessments[index];
                return DepressionTestCard(
                  cardImage: AppIcons.iconsPrivate,
                  depressionTestTitle: assessment.name,
                  depressionTestSubtitle: assessment.description,
                  questionCount: assessment.totalQuestions,
                  onPressed: () {
                    context.push(
                      AppRoutesPaths.depressionTestView,
                      extra: assessment,
                    );
                  },
                );
              },
            );
          } else if (state is AssessmentsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }


  Widget _buildList(
    BuildContext context, {
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return ScrollConfiguration(
   
      behavior: ScrollConfiguration.of(context).copyWith(
        overscroll: false,
        scrollbars: false,
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // --- Header section (title + description) ---
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: 22,
                end: 22,
                top: 22,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.trContext(TK.depressionTestTitle),
                    style: context.text.displayMedium!.copyWith(
                      color: context.text.bodyMedium!.color!.withAlpha(178),
                    ),
                    softWrap: true,
                    textAlign: TextAlign.start,
                  ),
                  12.h.height,
                  Text(
                    context.trContext(TK.depressionTestsDesc),
                    style: context.text.titleMedium!.copyWith(
                      color: context.text.titleMedium!.color!.withAlpha(178),
                    ),
                    softWrap: true,
                    textAlign: TextAlign.start,
                  ),
                  32.h.height,
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsetsDirectional.only(
              start: 22,
              end: 22,
              bottom: 22,
            ),
            sliver: SliverList.separated(
              itemCount: itemCount,
              separatorBuilder: (context, index) => 16.h.height,
              itemBuilder: itemBuilder,
            ),
          ),
        ],
      ),
    );
  }
}
