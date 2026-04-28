import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/theme/app_colors.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/custom_instructions_recommendations.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/depression/domain/entities/assessments.dart';
import 'package:new_mama/feature/depression/presentation/view_model/assessment_result_cubit/assessment_result_cubit.dart';
import 'package:new_mama/feature/depression/presentation/view_model/assessment_result_cubit/assessment_result_state.dart';

class DepressionResultView extends StatelessWidget {
  final Assessments assessment;

  const DepressionResultView({super.key, required this.assessment});

  /// Maps the score to the themed foreground severity color.
  Color _severityColor(AppColors colors, int score) {
    if (score <= 4) return colors.severityMinimal;
    if (score <= 9) return colors.severityMild;
    if (score <= 14) return colors.severityModerate;
    if (score <= 19) return colors.severityHigh;
    return colors.severitySevere;
  }

  /// Maps the score to the themed background severity color.
  Color _severityBackgroundColor(AppColors colors, int score) {
    if (score <= 4) return colors.severityMinimalBg;
    if (score <= 9) return colors.severityMildBg;
    if (score <= 14) return colors.severityModerateBg;
    if (score <= 19) return colors.severityHighBg;
    return colors.severitySevereBg;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssessmentResultCubit, AssessmentResultState>(
      builder: (context, state) {
        if (state is AssessmentResultLoading) {
          return const Scaffold(body: Center(child: CustomLoadingIndicator()));
        }
        if (state is AssessmentResultError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }
        if (state is AssessmentResultSuccess) {
          final result = state.result;
          final description = result.description;
          final themeColors = context.ext.colors;
          final fgColor = _severityColor(themeColors, result.score);
          final bgColor = _severityBackgroundColor(themeColors, result.score);

          return Scaffold(
            appBar: FeaturesHeader(
              title: context.trContext(TK.depressionAppBarTitle),
              onPressed: () {
                context.go(AppRoutesPaths.appSectionView);
              },
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 33.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Score & Severity Card ───────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 33,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: bgColor,
                    ),
                    child: Column(
                      children: [
                        Text(assessment.name, style: context.text.bodyMedium!),
                        12.h.height,
                        // Severity from API
                        Text(
                          result.severity,
                          style: context.text.displayMedium!.copyWith(
                            color: fgColor,
                          ),
                        ),
                        12.h.height,
                        // Percentage Score (Calculating based on total questions * 3 max points)
                        Text(
                          context.trContext(
                            TK.depressionScoreDisplay,
                            namedArgs: {
                              'percentage':
                                  ((result.score / (assessment.maxScore)) * 100)
                                      .toStringAsFixed(0),
                            },
                          ),
                          style: context.text.bodyMedium!.copyWith(
                            color: context.text.bodyMedium!.color!.withAlpha(
                              178,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  41.h.height,
                  Text(
                    result.severity,
                    style: context.text.displayMedium!,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  30.h.height,

                  // ── Advice / Description from API ───────────────────────────────
                  Text(
                    description,
                    style: context.text.titleSmall!,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  33.h.height,

                  CustomInstructionsRecommendations(
                    advices: result.recommendations,
                    title: context.trContext(TK.depressionRecommendations),
                  ),
                  53.h.height,
                  // ── Actions ─────────────────────────────────────────────────────
                  CustomElevatedButton(
                    text: context.trContext(TK.depressionRetake),
                    textStyle: context.text.headlineMedium!.copyWith(
                      color: context.theme.buttonTheme.colorScheme!.onPrimary,
                    ),
                    onPressed: () {
                      context.pushReplacement(
                        AppRoutesPaths.depressionTestView,
                        extra: assessment,
                      );
                    },
                    backgroundColor:
                        context.theme.buttonTheme.colorScheme!.primary,
                    minimumSize: Size(double.infinity, 52.h),
                  ),

                  24.h.height,
                  CustomElevatedButton(
                    text: context.trContext(TK.depressionBackHome),
                    textStyle: context.text.headlineMedium!.copyWith(
                      color: context.theme.buttonTheme.colorScheme!.primary,
                    ),
                    onPressed: () {
                      context.go(AppRoutesPaths.appSectionView);
                    },
                    borderColor: context.ext.colors.primaryDark,
                    backgroundColor:
                        context.theme.buttonTheme.colorScheme!.secondary,
                    minimumSize: Size(double.infinity, 52.h),
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(body: SizedBox.shrink());
      },
    );
  }
}
