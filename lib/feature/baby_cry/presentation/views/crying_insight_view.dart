import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/custom_circle_avatar_with_icon.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/custom_instructions_recommendations.dart';
import 'package:new_mama/core/widgets/features_header.dart';

class CryingInsightView extends StatelessWidget {
  CryingInsightView({super.key});
  final List<String> instructions = [
    'Record your baby\'s cry for 5-10 seconds',
    'AI analyzes the sound patterns and pitch',
    'Get insights and gentle suggestions to try',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FeaturesHeader(title: 'Crying Sound analysis'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomCircleAvatarWithIcon(
              height: 56,
              width: 56,
              radius: 52,
              image: AppIcons.iconsSound,
            ),
            32.h.height,
            Text(
              'Understanding Baby\'s Cry',
              style: context.text.displayMedium!,
            ),
            30.h.height,
            Text(
              'Let our AI help you understand what your baby might be trying to communicate through their cry.',
              style: context.text.titleSmall!,
              maxLines: 3,
              textAlign: .center,
              overflow: .ellipsis,
            ),
            32.h.height,
            CustomInstructionsRecommendations(
              title: 'How It Works',
              advices: instructions,
            ),
            56.h.height,
            CustomElevatedButton(
              text: 'Start Recording',
              onPressed: () {
                context.push(AppRoutesPaths.cryingRecordingSessionView);
              },
              minimumSize: Size(double.infinity, 52.h),
            ),
            16.h.height,
            Padding(
              padding: 12.w.hPadding,
              child: Text(
                'This is guidance, not medical advice. Trust your instincts – you know your baby best',
                style: context.text.bodyMedium!.copyWith(
                  color: context.ext.colors.lightTextPrimary.withAlpha(127),
                ),
                textAlign: .center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
