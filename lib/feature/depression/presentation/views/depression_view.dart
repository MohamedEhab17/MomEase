import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/home/presentation/widgets/custom_quick_access_card.dart';

class DepressionView extends StatelessWidget {
  const DepressionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FeaturesHeader(title: 'Healthy check-In'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        clipBehavior: Clip.none,
        child: Column(
          crossAxisAlignment: .center,
          children: [
            SvgPicture.asset(
              AppImages.meditation,
              width: 200.w,
              height: 200.h,
              fit: BoxFit.cover,
            ),
            32.height,
            Text('Let\'s Check In Together ', style: AppStyles.styleInter24),
            32.height,
            Text(
              ' This is a safe, private space to reflect on how you\'ve been feeling. There are no wrong answers.',
              style: AppStyles.styleInter14,
              maxLines: 3,
              textAlign: .center,
              overflow: TextOverflow.ellipsis,
            ),
            32.height,
            CustomQuickAccessCard(
              leadingIcon: AppIcons.iconsPrivate,
              title: 'Completely Private',
              subtitle: 'Your responses are confidential and never shared',
              backgroundColor: AppColors.primaryLighter,
            ),
            8.height,
            CustomQuickAccessCard(
              leadingIcon: AppIcons.iconsLock,
              title: 'No Judgment',
              subtitle: 'This is guidance, not diagnosis. You\'re safe here',
              backgroundColor: AppColors.primaryLighter,
            ),
            8.height,
            CustomQuickAccessCard(
              leadingIcon: AppIcons.iconsAlarm,
              title: 'Quick',
              subtitle:
                  'It takes about 2 minutes and includes 5 gentle questions',
              backgroundColor: AppColors.primaryLighter,
            ),
            54.height,
            CustomElevatedButton(
              text: 'Start Check-In',
              onPressed: () {
                context.push(AppRoutesPaths.depressionTestView);
              },
              backgroundColor: AppColors.primaryDark,
              minimumSize: Size(double.infinity, 52),
              textStyle: AppStyles.styleInter20.copyWith(
                color: AppColors.lightBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
