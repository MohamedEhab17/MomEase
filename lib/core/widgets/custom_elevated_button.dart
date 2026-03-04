import 'package:flutter/material.dart';
import 'package:new_mama/core/constants/app_colors.dart' show AppColors;
import 'package:new_mama/core/utils/app_styles.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.backgroundColor = AppColors.primarySoft,
    this.minimumSize,
    this.borderRadius = 64,
    this.borderColor,
    this.textStyle,
    this.padding,
    this.maxSize,
  });
  final void Function()? onPressed;
  final String text;
  final Color? backgroundColor;
  final Size? minimumSize;
  final Size? maxSize;
  final double borderRadius;
  final Color? borderColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 42, vertical: 14),
        shadowColor: AppColors.lightTextPrimary.withAlpha(64),
        elevation: 4,
        minimumSize: minimumSize,
        maximumSize: maxSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: borderColor ?? backgroundColor!),
        ),
      ),
      onPressed: onPressed,
      child: Text(text, style: textStyle ?? AppStyles.styleInter20),
    );
  }
}
