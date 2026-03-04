import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_circle_avatar_with_icon.dart';
import 'package:new_mama/core/widgets/features_header.dart';

class CryAnalyzingView extends StatelessWidget {
  const CryAnalyzingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FeaturesHeader(title: 'Crying Sound analysis'),
      body: Center(
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
              style: AppStyles.styleInter24,
              softWrap: true,
            ),
            20.h.height,
            Text(
              'Our AI is Carefully examining the Sound',
              style: AppStyles.styleInter14,
              softWrap: true,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
