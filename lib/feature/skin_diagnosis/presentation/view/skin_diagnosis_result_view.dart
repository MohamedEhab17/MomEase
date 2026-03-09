import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/custom_instructions_recommendations.dart';
import 'package:new_mama/core/widgets/features_header.dart';

class SkinDiagnosisResultView extends StatelessWidget {
  const SkinDiagnosisResultView({super.key, required this.advices});

  final List<String> advices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FeaturesHeader(
        title: 'Skin Diagnosis',
        onPressed: () {
          while (context.canPop()) {
            context.pop();
          }
        },
      ),
      body: SingleChildScrollView(
        padding: 20.vhPadding,
        child: Column(
          children: [
            Lottie.asset(AppIcons.iconsSuccess, width: 100.w, height: 100.h),
            24.h.height,
            Text('Likely Condition', style: AppStyles.styleInter24),
            12.h.height,
            Text(
              'Eczema',
              style: AppStyles.styleInter24.copyWith(color: Color(0xffFFC107)),
            ),
            40.h.height,
            Text(
              'Yellowish, greasy, scaly patches on the scalp. May also appear on eyebrows or behind ears. Very common in infants.',
              style: AppStyles.styleInter16.copyWith(
                color: AppColors.lightTextPrimary.withAlpha(178),
              ),
              textAlign: .center,
              softWrap: true,
            ),
            32.h.height,
            CustomInstructionsRecommendations(
              advices: advices,
              title: 'Gentle Care Tips',
            ),
            44.h.height,
            CustomElevatedButton(
              text: 'Analyze another Photo',
              backgroundColor: AppColors.primaryDark,
              minimumSize: Size(double.infinity, 52.h),
              onPressed: () {
                while (context.canPop()) {
                  context.pop();
                }
                context.push(AppRoutesPaths.skinDiagnosisInsightView);
              },
              textStyle: AppStyles.styleInter20.copyWith(
                color: AppColors.darkTextPrimary,
              ),
            ),
            24.h.height,
          ],
        ),
      ),
    );
  }
}
