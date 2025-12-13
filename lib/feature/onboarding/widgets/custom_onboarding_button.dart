import 'package:flutter/material.dart';
import 'package:new_mama/core/constants/app_colors.dart' show AppColors;
import 'package:new_mama/core/utils/app_styles.dart';

class CustomOnboardingButton extends StatelessWidget {
  const CustomOnboardingButton({
    super.key,
    this.onPressed,
    required this.text,
    this.backgroundColor = AppColors.primarySoft,
    this.minimumSize,
  });
  final void Function()? onPressed;
  final String text;
  final Color? backgroundColor;
  final Size? minimumSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 42, vertical: 14),
        minimumSize: minimumSize,
      ),
      onPressed: onPressed,
      child: Text(text, style: AppStyles.styleInter20),
    );
  }
}
