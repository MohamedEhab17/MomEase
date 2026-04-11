import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/custom_circle_avatar_with_icon.dart';

class CryAnalyzingView extends StatefulWidget {
  const CryAnalyzingView({super.key});

  @override
  State<CryAnalyzingView> createState() => _CryAnalyzingViewState();
}

class _CryAnalyzingViewState extends State<CryAnalyzingView> {
  final List<String> advices = [
    'Take small moments for yourself, even 5 minutes of quiet time.',
    'Connect with loved ones or join a mother\'s support group.',
    'If you\'re concerned, reach out to your healthcare provider.',
    'Remember: asking for help is a sign of strength, not weakness.',
  ];
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.push(AppRoutesPaths.cryingResultView, extra: advices);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Spacer(),
          CustomCircleAvatarWithIcon(
            image: AppIcons.iconsSound,
            radius: 52.r,
            width: 56.w,
            height: 56.h,
          ),
          32.h.height,
          Text(
            'Analyzing Crying Condition',
            style: context.text.displayMedium!,
            softWrap: true,
          ),
          20.h.height,
          Text(
            'Our AI is Carefully examining the Sound',
            style: context.text.titleSmall!,
            softWrap: true,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
