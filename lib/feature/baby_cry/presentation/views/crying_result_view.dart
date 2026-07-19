import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/custom_instructions_recommendations.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import '../../domain/entities/cry_analysis.dart';
import '../widgets/crying_confidence_badge.dart';

class CryingResultView extends StatelessWidget {
  const CryingResultView({super.key, required this.analysis});

  final CryAnalysis analysis;

  Color _colorForReasonScore(double score) {
    if (score >= 70) return const Color(0xFF4CAF50); // green
    if (score >= 30) return const Color(0xFFFFC107); // amber
    return const Color(0xFFFF5722); // orange-red
  }

  @override
  Widget build(BuildContext context) {
    // Split the advice into bullet points for the recommendations widget
    final advicePoints = analysis.advice
        .split('.')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // Sort scores descendingly if present
    final List<MapEntry<String, double>> sortedScores = [];
    if (analysis.allScores != null && analysis.allScores!.isNotEmpty) {
      sortedScores.addAll(analysis.allScores!.entries);
      sortedScores.sort((a, b) => b.value.compareTo(a.value));
    }

    return Scaffold(
      appBar: FeaturesHeader(
        title: context.trContext(TK.babyCryResultTitle),
        onPressed: () {
          context.go(AppRoutesPaths.appSectionView);
        },
        trailingAction: const SizedBox.shrink(),
      ),
      body: SingleChildScrollView(
        padding: 20.vhPadding,
        child: Column(
          children: [
            Lottie.asset(AppIcons.iconsSuccess, width: 100.w, height: 100.h),
            24.h.height,
            Text(
              context.trContext(TK.babyCryBabyMightBe),
              style: context.text.displayMedium!,
            ),
            12.h.height,
            Text(
              analysis.result,
              style: context.text.displayMedium!.copyWith(
                color: const Color(0xffFFC107),
              ),
              textAlign: TextAlign.center,
            ),
            16.h.height,
            CryingConfidenceBadge(confidence: analysis.confidence),
            32.h.height,

            //  Crying Reasons Breakdown Chart 
            if (sortedScores.isNotEmpty) ...[
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  context.trContext(TK.babyCryAnalysisBreakdown),
                  style: context.text.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.ext.colors.lightTextPrimary,
                  ),
                ),
              ),
              12.h.height,
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: context.ext.colors.primaryDark.withAlpha(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.ext.colors.primaryDark.withAlpha(8),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: sortedScores.map((entry) {
                    final key = entry.key;
                    final score = entry.value;

                    // Translate key
                    String label = key;
                    if (key == 'belly_pain') {
                      label = context.trContext(TK.babyCryBellyPain);
                    } else if (key == 'burping') {
                      label = context.trContext(TK.babyCryBurping);
                    } else if (key == 'discomfort') {
                      label = context.trContext(TK.babyCryDiscomfortReason);
                    } else if (key == 'hungry') {
                      label = context.trContext(TK.babyCryHungry);
                    } else if (key == 'laugh') {
                      label = context.trContext(TK.babyCryLaugh);
                    }

                    final color = _colorForReasonScore(score);

                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                label,
                                style: context.text.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${score.toStringAsFixed(1)}%',
                                style: context.text.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          6.h.height,
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: LinearProgressIndicator(
                              value: score / 100,
                              backgroundColor: color.withAlpha(25),
                              color: color,
                              minHeight: 8.h,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              32.h.height,
            ],

            CustomInstructionsRecommendations(
              advices: advicePoints,
              title: context.trContext(TK.babyCryRecommendSteps),
            ),
            24.h.height,

            // Medical disclaimer
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: context.ext.colors.primaryDark.withAlpha(18),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: context.ext.colors.primaryDark.withAlpha(50),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18.w,
                    color: context.ext.colors.primaryDark,
                  ),
                  8.width,
                  Expanded(
                    child: Text(
                      context.trContext(TK.babyCryDisclaimerText),
                      style: context.text.bodySmall!.copyWith(
                        color: context.colors.onSurface.withAlpha(170),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            32.h.height,

            CustomElevatedButton(
              text: context.trContext(TK.babyCryAnalyzeAnother),
              backgroundColor: context.ext.colors.primaryDark,
              minimumSize: Size(double.infinity, 52.h),
              onPressed: () {
                context.pushReplacement(AppRoutesPaths.cryingInsightView);
              },
              textStyle: context.text.headlineMedium!.copyWith(
                color: context.theme.buttonTheme.colorScheme!.onPrimary,
              ),
            ),
            24.h.height,
          ],
        ),
      ),
    );
  }
}
