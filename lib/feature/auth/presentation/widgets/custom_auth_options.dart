import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';

class CustomAuthOptions extends StatelessWidget {
  const CustomAuthOptions({
    super.key,
    required this.googleOnPressed,
  });

  final VoidCallback googleOnPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: googleOnPressed,
        borderRadius: BorderRadius.circular(64.r),
        child: Container(
          height: 52.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(64.r),
            border: Border.all(
              color: context.colors.primary.withValues(alpha: 0.15),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: context.theme.colorScheme.onSurface.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.iconsGoogle,
                width: 24.w,
                height: 24.h,
              ),
              12.w.width,
              Text(
                context.trContext(TK.authContinueWithGoogle),
                style: context.text.titleMedium?.copyWith(
                  color: context.theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ).forText(context.trContext(TK.authContinueWithGoogle)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
