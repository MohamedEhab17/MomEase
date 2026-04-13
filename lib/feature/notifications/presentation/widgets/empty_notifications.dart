import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: 16.hPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.iconsInActiveNotification,
              width: 80.r,
              height: 80.r,
              colorFilter: ColorFilter.mode(
                context.ext.colors.textDisabledLighter,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              context.trContext(TK.notificationsEmptyTitle),
              style: context.text.titleMedium!.copyWith(
                fontWeight: FontWeight.w500,
                color: context.colors.onSurface,
              ),
               textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              context.trContext(TK.notificationsEmptySubtitle),
              style: context.text.titleSmall!.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
