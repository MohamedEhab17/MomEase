import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_circle_avatar_with_icon.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/custom_instructions_recommendations.dart';
import 'package:new_mama/core/widgets/features_header.dart';

class SkinDiagnosisInsightView extends StatelessWidget {
  const SkinDiagnosisInsightView({super.key});
  static const List<String> instructions = [
    'Take a clear photo of the affected skin area',
    'AI analyzes the image for common conditions',
    'Receive gentle care tips and recommendations',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FeaturesHeader(title: 'Skin Diagnosis'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
        child: Column(
          children: [
            CustomCircleAvatarWithIcon(
              height: 56,
              width: 56,
              radius: 52,
              image: AppIcons.iconsScan,
            ),
            32.h.height,
            Text('Gentle Skin Guidance', style: AppStyles.styleInter24),
            15.h.height,
            Text(
              'Get AI-powered insights about common baby skin conditions and gentle care tips.',
              style: AppStyles.styleInter14,
              maxLines: 3,
              textAlign: .center,
              overflow: TextOverflow.ellipsis,
            ),
            32.h.height,
            CustomInstructionsRecommendations(
              title: 'How It Works',
              advices: instructions,
            ),
            56.h.height,
            CustomElevatedButton(
              text: 'Take or upload photo',
              onPressed: () {
                context.push(AppRoutesPaths.skinDiagnosisPhotoView);
              },
              backgroundColor: AppColors.primaryHard,
              minimumSize: Size(double.infinity, 52.h),
              textStyle: AppStyles.styleInter20.copyWith(
                color: AppColors.lightBackground,
              ),
            ),
            16.h.height,
            Text(
              'This is guidance, not medical advice.Trust your instincts – you know your baby best',
              style: AppStyles.styleInter12.copyWith(
                color: AppColors.darkBackground.withAlpha(128),
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
