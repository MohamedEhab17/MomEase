import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/custom_instructions_recommendations.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/skin_diagnosis/domain/entities/skin_analysis.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/widgets/skin_diagnosis_confidence_badge.dart';

class SkinDiagnosisResultView extends StatelessWidget {
  const SkinDiagnosisResultView({super.key, required this.analysis});

  final SkinAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    // Split the advice into bullet points for the care tips widget
    final advicePoints = analysis.advice
        .split('.')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return Scaffold(
      appBar: FeaturesHeader(
        title: context.trContext(TK.skinResultTitle),
        onPressed: () => context.go(AppRoutesPaths.appSectionView),
        trailingAction: const SizedBox.shrink(),
      ),
      body: SingleChildScrollView(
        padding: 20.vhPadding,
        child: Column(
          children: [
            // ── Success animation ──────────────────────────────────────────
            Lottie.asset(AppIcons.iconsSuccess, width: 100.w, height: 100.h),
            24.h.height,

            // ── Likely Condition label ─────────────────────────────────────
            Text(
              context.trContext(TK.skinLikelyCondition),
              style: context.text.displayMedium!,
            ),
            12.h.height,

            // ── Disease name ───────────────────────────────────────────────
            Text(
              analysis.diseaseName,
              style: context.text.displayMedium!.copyWith(
                color: const Color(0xffFFC107),
              ),
              textAlign: TextAlign.center,
            ),
            16.h.height,

            // ── Confidence badge ───────────────────────────────────────────
            SkinDiagnosisConfidenceBadge(confidence: analysis.confidence),
            32.h.height,

            // ── Gentle Care Tips (same beautiful widget as before) ─────────
            CustomInstructionsRecommendations(
              advices: advicePoints,
              title: context.trContext(TK.skinCareTips),
            ),
            24.h.height,

            // ── Medical disclaimer ─────────────────────────────────────────
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
                      context.trContext(TK.skinDisclaimerText),
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

            // ── Analyze another ────────────────────────────────────────────
            CustomElevatedButton(
              text: context.trContext(TK.skinAnalyzeAnother),
              minimumSize: Size(double.infinity, 52.h),
              onPressed: () =>
                  context.pushReplacement(AppRoutesPaths.skinDiagnosisInsightView),
            ),
            24.h.height,
          ],
        ),
      ),
    );
  }
}
