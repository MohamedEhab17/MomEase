import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    this.onTap,
    required this.firstText,
    required this.secondText,
    this.firstTextColor = AppColors.lightTextPrimary,
    this.secondTextColor = AppColors.primary,
    this.firstTextStyle,
    this.secondTextStyle,
    this.center = true,
  });
  final void Function()? onTap;
  final String firstText;
  final String secondText;
  final Color firstTextColor;
  final Color secondTextColor;
  final TextStyle? firstTextStyle;
  final TextStyle? secondTextStyle;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return center
        ? Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: firstText,
                    style:
                        firstTextStyle ??
                        AppStyles.styleRoboto24.copyWith(color: firstTextColor),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = onTap,

                    text: secondText,
                    style:
                        secondTextStyle ??
                        AppStyles.styleRoboto24.copyWith(
                          color: secondTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
          )
        : RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: firstText,
                  style:
                      firstTextStyle ??
                      AppStyles.styleRoboto24.copyWith(color: firstTextColor),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = onTap,

                  text: secondText,
                  style:
                      secondTextStyle ??
                      AppStyles.styleRoboto24.copyWith(
                        color: secondTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          );
  }
}
