import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_circle_avatar_with_icon.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/custom_instructions_recommendations.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/children/presentation/widgets/premium_child_selector.dart';

class InsightViewScaffold extends StatelessWidget {
  final String appBarTitle;
  final String icon;
  final String headline;
  final String subtitle;
  final List<String> instructions;
  final String instructionsTitle;
  final String ctaText;
  final VoidCallback onCtaPressed;

  const InsightViewScaffold({
    super.key,
    required this.appBarTitle,
    required this.icon,
    required this.headline,
    required this.subtitle,
    required this.instructions,
    required this.instructionsTitle,
    required this.ctaText,
    required this.onCtaPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FeaturesHeader(title: appBarTitle),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const PremiumChildSelector(),
            20.h.height,
            CustomCircleAvatarWithIcon(
              height: 56,
              width: 56,
              radius: 52,
              image: icon,
            ),
            32.h.height,
            Text(headline, style: context.text.displayMedium!),
            15.h.height,
            Text(
              subtitle,
              style: context.text.titleSmall!,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            32.h.height,
            CustomInstructionsRecommendations(
              title: instructionsTitle,
              advices: instructions,
            ),
            56.h.height,
            CustomElevatedButton(
              text: ctaText,
              onPressed: onCtaPressed,
              minimumSize: Size(double.infinity, 52.h),
            ),
            16.h.height,
            Padding(
              padding: 12.w.hPadding,
              child: Text(
                context.trContext(TK.commonGuidance),
                style: context.text.bodyMedium!.copyWith(
                  color: context.ext.colors.lightTextPrimary.withAlpha(128),
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
