import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';

class ActionButton extends StatelessWidget {
  final String? icon;
  final IconData? iconData;
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final GlobalKey<AnimateFromState<dynamic>>? animateKey;
  final Color? color;

  const ActionButton({
    super.key,
    this.icon,
    this.iconData,
    required this.label,
    required this.onTap,
    this.onLongPress,
    this.animateKey,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? context.ext.colors.primaryDark;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 113.w,
        height: 30.h,
        padding: 7.vPadding,
        decoration: BoxDecoration(
          color: context.ext.colors.primaryLighter.withAlpha(77),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconData != null)
              Icon(iconData, size: 16, color: activeColor)
            else if (icon != null)
              animateKey != null
                  ? AnimateFrom(
                      key: animateKey!,
                      child: SvgPicture.asset(
                        icon!,
                        width: 16,
                        height: 16,
                        colorMapper: AppSvgColorMapper(
                          from: const Color(0xffFF3381),
                          to: activeColor,
                        ),
                      ),
                    )
                  : SvgPicture.asset(
                      icon!,
                      width: 16,
                      height: 16,
                      colorMapper: AppSvgColorMapper(
                        from: const Color(0xffFF3381),
                        to: activeColor,
                      ),
                    ),

            6.h.width,
            Text(
              label,
              style: context.text.bodyLarge!.copyWith(
                color: activeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
