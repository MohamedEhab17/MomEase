import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/depression/presentation/widgets/custom_mental_health_recommendations.dart';

class DepressionResultView extends StatelessWidget {
  DepressionResultView({super.key});
  final List<String> advices = [
    'Take small moments for yourself, even 5 minutes of quiet time.',
    'Connect with loved ones or join a mother\'s support group.',
    'If you\'re concerned, reach out to your healthcare provider.',
    'Remember: asking for help is a sign of strength, not weakness.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FeaturesHeader(title: 'Healthy check-In'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 33.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 33, vertical: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: AppColors.lightGreenBackground.withAlpha(77),
              ),

              child: Column(
                spacing: 12.h,
                children: [
                  Text('Emotional Well-being', style: AppStyles.styleInter12),
                  Text(
                    'Minimal',
                    style: AppStyles.styleInter24.copyWith(
                      color: AppColors.greenText,
                    ),
                  ),
                ],
              ),
            ),
            41.h.height,
            Text(
              'You\'re doing well emotionally',
              style: AppStyles.styleInter24,
            ),
            30.h.height,
            Text(
              'Your responses suggest minimal signs of depression. It\'s wonderful that you\'re taking time to check in with yourself.',
              style: AppStyles.styleInter14,
              textAlign: .center,
              softWrap: true,
            ),
            33.h.height,
            CustomMentalHealthRecommendations(advices: advices),
            53.h.height,

            CustomElevatedButton(
              text: 'Retake Check-In',
              textStyle: AppStyles.styleInter20.copyWith(
                color: AppColors.lightBackground,
              ),
              onPressed: () {},
              backgroundColor: AppColors.primaryHard,
              minimumSize: Size(double.infinity, 52.h),
            ),

            24.h.height,
            CustomElevatedButton(
              text: 'Back to Home',
              textStyle: AppStyles.styleInter20.copyWith(
                color: AppColors.primaryHard,
              ),
              onPressed: () {},
              borderColor: AppColors.primaryHard,
              backgroundColor: AppColors.lightBackground,
              minimumSize: Size(double.infinity, 52.h),
            ),
          ],
        ),
      ),
    );
  }
}
