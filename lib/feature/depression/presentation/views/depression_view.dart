import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/home/presentation/widgets/custom_quick_access_card.dart';

class DepressionView extends StatelessWidget {
  const DepressionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FeaturesHeader(title: context.trContext(TK.depressionAppBarTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        clipBehavior: Clip.none,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppImages.meditation,
              width: 200.w,
              height: 200.h,
              fit: BoxFit.cover,
              colorMapper: AppSvgColorMapper(
                from: Color(0xffFF9BBC),
                to: context.ext.colors.primaryLight,
              ),
            ),
            32.height,
            Text(
              context.trContext(TK.depressionCheckInTitle),
              style: context.text.displayMedium!,
            ),
            32.height,
            Text(
              context.trContext(TK.depressionSafeSpaceDesc),
              style: context.text.titleSmall!,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            32.height,
            CustomQuickAccessCard(
              leadingIcon: AppIcons.iconsPrivate,
              title: context.trContext(TK.depressionPrivateTitle),
              subtitle: context.trContext(TK.depressionPrivateSubtitle),
              backgroundColor: context.ext.colors.primaryLighter,
            ),
            8.height,
            CustomQuickAccessCard(
              leadingIcon: AppIcons.iconsLock,
              title: context.trContext(TK.depressionNoJudgmentTitle),
              subtitle: context.trContext(TK.depressionNoJudgmentSubtitle),
              backgroundColor: context.ext.colors.primaryLighter,
            ),
            8.height,
            CustomQuickAccessCard(
              leadingIcon: AppIcons.iconsAlarm,
              title: context.trContext(TK.depressionQuickTitle),
              subtitle: context.trContext(TK.depressionQuickSubtitle),
              backgroundColor: context.ext.colors.primaryLighter,
            ),
            54.height,
            CustomElevatedButton(
              text: context.trContext(TK.depressionStartCheckIn),
              onPressed: () {
                context.push(AppRoutesPaths.depressionTestView);
              },
              textStyle: context.text.titleMedium!.copyWith(
                color: context.theme.buttonTheme.colorScheme!.onPrimary,
                fontWeight: FontWeight.w600,
              ),
              minimumSize: Size(double.infinity, 48.h),
              backgroundColor: context.theme.buttonTheme.colorScheme!.primary,
            ),
          ],
        ),
      ),
    );
  }
}
