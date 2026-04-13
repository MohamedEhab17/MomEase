import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';

class DrawerLogoutSection extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback? onLogout;

  const DrawerLogoutSection({
    super.key,
    required this.animation,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
    );

    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return AnimatedBuilder(
      animation: curved,
      builder: (context, _) {
        final offsetX = isRTL
            ? 40 * (1 - curved.value)
            : -40 * (1 - curved.value);

        return Transform.translate(
          offset: Offset(offsetX, 0),
          child: Opacity(
            opacity: curved.value.clamp(0.0, 1.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    backgroundColor:
                        context.theme.buttonTheme.colorScheme!.secondary,
                    borderColor: context.ext.colors.primaryDark,
                    icon: Icon(
                      Icons.logout,
                      color: context.ext.colors.primaryDark,
                      size: 20.sp,
                    ),
                    text: context.trContext(TK.commonLogout),
                    textStyle: context.theme.textTheme.titleLarge!.copyWith(
                      color: context.ext.colors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                    onPressed: onLogout ?? () {},
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  context.trContext(TK.commonVersionDisplay, namedArgs: {'version': '1.0.0'}),
                  style: context.text.bodyLarge!.copyWith(
                    color: context.ext.colors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
