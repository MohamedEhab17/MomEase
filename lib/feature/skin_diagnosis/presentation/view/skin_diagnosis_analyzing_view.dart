import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/custom_circle_avatar_with_icon.dart';
import 'package:new_mama/core/widgets/features_header.dart';

class SkinDiagnosisAnalyzingView extends StatefulWidget {
  const SkinDiagnosisAnalyzingView({super.key});

  @override
  State<SkinDiagnosisAnalyzingView> createState() =>
      _SkinDiagnosisAnalyzingViewState();
}

class _SkinDiagnosisAnalyzingViewState
    extends State<SkinDiagnosisAnalyzingView> {
  final List<String> advices = [
    'Gently massage baby\'s scalp with your fingers',
    'Wash hair regularly with gentle baby shampoo',
    'Use a soft brush to loosen flakes',
    'Apply baby oil before washing if very crusty',
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      context.pushReplacement(
        AppRoutesPaths.skinDiagnosisResultView,
        extra: advices,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: FeaturesHeader(
        title: 'Skin Diagnosis',
        onPressed: () {
          while (context.canPop()) {
            context.pop();
          }
        },
      ),
      body: Center(
        child: Column(
          children: [
            Spacer(),
            CustomCircleAvatarWithIcon(
              image: AppIcons.iconsScan,
              radius: 52.r,
              width: 56.w,
              height: 56.h,
            ),
            32.h.height,
            Text(
              'Analyzing Skin Condition',
              style: context.text.displayMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            12.h.height,
            Text(
              'Our AI is carefully examining the image...',
              style: context.text.titleSmall!.copyWith(
                color: context.colors.onSurface.withAlpha(128),
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            48.h.height,
            Container(
              padding: 16.w.allPadding,
              decoration: BoxDecoration(
                color: context.ext.colors.primaryDark.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: SpinKitFadingCircle(
                color: context.ext.colors.primaryDark,
                size: 48.w,
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
