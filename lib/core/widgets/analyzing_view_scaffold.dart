import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/widgets/custom_circle_avatar_with_icon.dart';
import 'package:new_mama/core/widgets/features_header.dart';

class AnalyzingViewScaffold extends StatelessWidget {
  final String ? appBarTitle;
  final String icon;
  final String headline;
  final String subtitle;
  final Widget? indicator;
  final VoidCallback? onBackPressed;

  const AnalyzingViewScaffold({
    super.key,
    required this.icon,
    required this.headline,
    required this.subtitle,
    this.appBarTitle,
    this.indicator,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar:appBarTitle == null ? null : FeaturesHeader(
        title: appBarTitle!,
        onPressed: onBackPressed,
        trailingAction: const SizedBox.shrink(),
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            CustomCircleAvatarWithIcon(
              image: icon,
              radius: 52.r,
              width: 56.w,
              height: 56.h,
            ),
            32.h.height,
            Text(
              headline,
              style: context.text.displayMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            12.h.height,
            Text(
              subtitle,
              style: context.text.titleSmall!.copyWith(
                color: context.colors.onSurface.withAlpha(128),
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            if (indicator != null) ...[
              48.h.height,
              indicator!,
            ],
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
