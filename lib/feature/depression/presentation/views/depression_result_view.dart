import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/core/widgets/custom_instructions_recommendations.dart';

class DepressionResultView extends StatelessWidget {
  final int totalScore;

  DepressionResultView({super.key, required this.totalScore});
  final List<String> _adviceKeys = [
    TK.babyCryTip1,
    TK.babyCryTip2,
    TK.babyCryTip3,
    TK.babyCryTip4,
  ];
  String _severityResult(BuildContext context) {
    if (totalScore <= 4) return context.trContext(TK.depressionSeverityMinimal);
    if (totalScore <= 9) return context.trContext(TK.depressionSeverityMild);
    if (totalScore <= 14) return context.trContext(TK.depressionSeverityModerate);
    if (totalScore <= 19) return context.trContext(TK.depressionSeverityModSevere);
    return context.trContext(TK.depressionSeveritySevere);
  }

  Color _severityColor(BuildContext context) {
    if (totalScore <= 4) {
      return context.ext.colors.greenText;
    }
    if (totalScore <= 9) return Colors.blue;
    if (totalScore <= 14) return Colors.orange;
    if (totalScore <= 19) return Colors.deepOrange;
    return Colors.red;
  }

  Color _severityBackgroundColor(BuildContext context) {
    if (totalScore <= 9) {
      return context.ext.colors.backgroundGreen.withAlpha(77);
    }
    if (totalScore <= 14) return Colors.orange.withAlpha(77);
    return Colors.red.withAlpha(77);
  }

  String _description(BuildContext context) {
    if (totalScore <= 4) {
      return context.trContext(TK.depressionResultMinimal);
    } else if (totalScore <= 9) {
      return context.trContext(TK.depressionResultMild);
    } else if (totalScore <= 14) {
      return context.trContext(TK.depressionResultModerate);
    } else if (totalScore <= 19) {
      return context.trContext(TK.depressionResultModSevere);
    } else {
      return context.trContext(TK.depressionResultSevere);
    }
  }

  @override
  Widget build(BuildContext context) {
    final advices = _adviceKeys.map((k) => context.trContext(k)).toList();

    return Scaffold(
      appBar: FeaturesHeader(
        title: context.trContext(TK.depressionAppBarTitle),
        onPressed: () {
          while (context.canPop()) {
            context.pop();
          }
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 33.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 33, vertical: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: _severityBackgroundColor(context),
              ),

              child: Column(
                spacing: 12.h,
                children: [
                  Text(context.trContext(TK.depressionWellbeing), style: context.text.bodyMedium!),
                  Text(
                    _severityResult(context),
                    style: context.text.displayMedium!.copyWith(
                      color: _severityColor(context),
                    ),
                  ),
                  Text(
                    context.trContext(
                      TK.depressionScoreDisplay,
                      namedArgs: {'score': '$totalScore'},
                    ),
                    style: context.text.bodyMedium!.copyWith(
                      color: context.text.bodyMedium!.color!.withAlpha(178),
                    ),
                  ),
                ],
              ),
            ),
            41.h.height,
            Text(
              context.trContext(TK.depressionDoingWell),
              style: context.text.displayMedium!,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            30.h.height,
            Text(
              _description(context),
              style: context.text.titleSmall!,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            33.h.height,
            CustomInstructionsRecommendations(
              title: context.trContext(TK.depressionRecommendations),
              advices: advices,
            ),
            53.h.height,

            CustomElevatedButton(
              text: context.trContext(TK.depressionRetake),
              textStyle: context.text.headlineMedium!.copyWith(
                color: context.theme.buttonTheme.colorScheme!.onPrimary,
              ),
              onPressed: () {
                while (context.canPop()) {
                  context.pop();
                }
                context.push('/depressionTestView');
              },
              backgroundColor: context.theme.buttonTheme.colorScheme!.primary,
              minimumSize: Size(double.infinity, 52.h),
            ),

            24.h.height,
            CustomElevatedButton(
              text: context.trContext(TK.depressionBackHome),
              textStyle: context.text.headlineMedium!.copyWith(
                color: context.theme.buttonTheme.colorScheme!.primary,
              ),
              onPressed: () {
                while (context.canPop()) {
                  context.pop();
                }
              },
              borderColor: context.ext.colors.primaryDark,
              backgroundColor: context.theme.buttonTheme.colorScheme!.secondary,
              minimumSize: Size(double.infinity, 52.h),
            ),
          ],
        ),
      ),
    );
  }
}
