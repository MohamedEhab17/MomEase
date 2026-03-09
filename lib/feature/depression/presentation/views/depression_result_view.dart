import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/core/widgets/custom_instructions_recommendations.dart';

class DepressionResultView extends StatelessWidget {
  final int totalScore;

  DepressionResultView({super.key, required this.totalScore});
  final List<String> advices = [
    'Take small moments for yourself, even 5 minutes of quiet time.',
    'Connect with loved ones or join a mother\'s support group.',
    'If you\'re concerned, reach out to your healthcare provider.',
    'Remember: asking for help is a sign of strength, not weakness.',
  ];

  String get _severityResult {
    if (totalScore <= 4) return 'Minimal';
    if (totalScore <= 9) return 'Mild';
    if (totalScore <= 14) return 'Moderate';
    if (totalScore <= 19) return 'Moderately Severe';
    return 'Severe';
  }

  Color get _severityColor {
    if (totalScore <= 4) return AppColors.greenText;
    if (totalScore <= 9) return Colors.blue;
    if (totalScore <= 14) return Colors.orange;
    if (totalScore <= 19) return Colors.deepOrange;
    return Colors.red;
  }

  Color get _severityBackgroundColor {
    if (totalScore <= 9) return AppColors.backgroundGreen.withAlpha(77);
    if (totalScore <= 14) return Colors.orange.withAlpha(77);
    return Colors.red.withAlpha(77);
  }

  String get _description {
    if (totalScore <= 4) {
      return 'Your responses suggest minimal signs of depression. It\'s wonderful that you\'re taking time to check in with yourself.';
    } else if (totalScore <= 9) {
      return 'Your responses suggest mild signs of depression. Try applying some self-care techniques or reflecting on what triggers these feelings.';
    } else if (totalScore <= 14) {
      return 'Your responses suggest moderate signs of depression. Taking proactive steps, like talking to someone you trust, can be a great help.';
    } else if (totalScore <= 19) {
      return 'Your responses suggest moderately severe signs of depression. We strongly encourage reaching out to a healthcare professional for support.';
    } else {
      return 'Your responses suggest severe signs of depression. Please immediately contact a professional or call a helpline. You do not have to go through this alone.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FeaturesHeader(
        title: 'Healthy check-In',
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
                color: _severityBackgroundColor,
              ),

              child: Column(
                spacing: 12.h,
                children: [
                  Text('Emotional Well-being', style: AppStyles.styleInter12),
                  Text(
                    _severityResult,
                    style: AppStyles.styleInter24.copyWith(
                      color: _severityColor,
                    ),
                  ),
                ],
              ),
            ),
            41.h.height,
            Text(
              'You\'re doing well emotionally',
              style: AppStyles.styleInter24,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            30.h.height,
            Text(
              _description,
              style: AppStyles.styleInter14,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            33.h.height,
            CustomInstructionsRecommendations(
              title: 'Gentle Recommendations',
              advices: advices,
            ),
            53.h.height,

            CustomElevatedButton(
              text: 'Retake Check-In',
              textStyle: AppStyles.styleInter20.copyWith(
                color: AppColors.lightBackground,
              ),
              onPressed: () {
                while (context.canPop()) {
                  context.pop();
                }
                context.push('/depressionTestView');
              },
              backgroundColor: AppColors.primaryDark,
              minimumSize: Size(double.infinity, 52.h),
            ),

            24.h.height,
            CustomElevatedButton(
              text: 'Back to Home',
              textStyle: AppStyles.styleInter20.copyWith(
                color: AppColors.primaryDark,
              ),
              onPressed: () {
                while (context.canPop()) {
                  context.pop();
                }
              },
              borderColor: AppColors.primaryDark,
              backgroundColor: AppColors.lightBackground,
              minimumSize: Size(double.infinity, 52.h),
            ),
          ],
        ),
      ),
    );
  }
}
