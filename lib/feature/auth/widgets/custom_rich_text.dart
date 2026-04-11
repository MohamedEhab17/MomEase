import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    this.onTap,
    required this.firstText,
    required this.secondText,
    this.firstTextColor,
    this.secondTextColor,
    this.firstTextStyle,
    this.secondTextStyle,
    this.center = true,
  });
  final void Function()? onTap;
  final String firstText;
  final String secondText;
  final Color? firstTextColor;
  final Color? secondTextColor;
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
                        context.text.displaySmall!.copyWith(
                          color: firstTextColor ?? context.colors.onSurface,
                        ),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = onTap,

                    text: secondText,
                    style:
                        secondTextStyle ??
                        context.text.headlineLarge!.copyWith(
                          color:
                              secondTextColor ?? context.ext.colors.primaryDark,
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
                      context.text.displaySmall!.copyWith(
                        color: firstTextColor ?? context.colors.onSurface,
                      ),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = onTap,

                  text: secondText,
                  style:
                      secondTextStyle ??
                      context.text.headlineLarge!.copyWith(
                        color:
                            secondTextColor ?? context.ext.colors.primaryDark,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          );
  }
}
