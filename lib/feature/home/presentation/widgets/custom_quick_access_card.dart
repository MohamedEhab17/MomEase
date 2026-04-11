import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';

class CustomQuickAccessCard extends StatelessWidget {
  const CustomQuickAccessCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    this.onTap,
    this.backgroundColor,
    this.showTrailing,
  });
  final String title;
  final String subtitle;
  final void Function()? onTap;
  final String leadingIcon;
  final Color? backgroundColor;
  final bool? showTrailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
            blurStyle: BlurStyle.outer,
            color: context.colors.onSurface.withAlpha(38),
          ),
        ],
      ),

      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        leading: CircleAvatar(
          radius: 22.r,
          backgroundColor: backgroundColor ?? context.ext.colors.primaryLighter,
          child: SvgPicture.asset(
            leadingIcon,
            colorFilter: ColorFilter.mode(
              context.ext.colors.primaryDark,
              BlendMode.srcIn,
            ),
          ),
        ),
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: context.text.titleSmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: context.ext.colors.lightTextPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: context.text.bodyMedium!.copyWith(
            color: context.ext.colors.lightTextPrimary.withAlpha(178),
          ),
        ),
        trailing: showTrailing == true
            ? SvgPicture.asset(
                AppIcons.iconsForwardArrow,
                colorFilter: ColorFilter.mode(
                  context.ext.colors.primaryDark,
                  BlendMode.srcIn,
                ),
              )
            : null,
      ),
    );
  }
}
