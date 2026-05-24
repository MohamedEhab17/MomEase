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

class CryingResultView extends StatelessWidget {
  const CryingResultView({super.key, required this.advices});

  final List<String> advices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FeaturesHeader(
        title: context.trContext(TK.babyCryResultTitle),
        onPressed: () {
          context.go(AppRoutesPaths.appSectionView);
        },
      ),
      body: SingleChildScrollView(
        padding: 20.vhPadding,
        child: Column(
          children: [
            Lottie.asset(AppIcons.iconsSuccess, width: 100.w, height: 100.h),
            24.h.height,
            Text(context.trContext(TK.babyCryBabyMightBe), style: context.text.displayMedium!),
            12.h.height,
            Text(
              context.trContext(TK.babyCryDiscomfort),
              style: context.text.displayMedium!.copyWith(
                color: Color(0xffFFC107),
              ),
            ),
            40.h.height,
            Text(
              context.trContext(TK.babyCryDiscomfortDesc),
              style: context.text.titleMedium!.copyWith(
                color: context.text.titleMedium!.color!.withAlpha(178),
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            32.h.height,
            CustomInstructionsRecommendations(
              advices: advices,
              title: context.trContext(TK.babyCryRecommendSteps),
            ),
            44.h.height,
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
