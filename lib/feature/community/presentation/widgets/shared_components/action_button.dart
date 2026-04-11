import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';

class ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final GlobalKey<AnimateFromState<dynamic>>? animateKey;
  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.animateKey,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
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
            animateKey != null
                ? AnimateFrom(
                    key: animateKey!,
                    child: SvgPicture.asset(
                      icon,
                      width: 16,
                      height: 16,
                      colorMapper: AppSvgColorMapper(
                        from: Color(0xffFF3381),
                        to: context.ext.colors.primaryDark,
                      ),
                    ),
                  )
                : SvgPicture.asset(
                    icon,
                    width: 16,
                    height: 16,
                    colorMapper: AppSvgColorMapper(
                      from: Color(0xffFF3381),
                      to: context.ext.colors.primaryDark,
                    ),
                  ),

            6.h.width,
            Text(
              label,
              style: context.text.bodyLarge!.copyWith(
                color: context.ext.colors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
