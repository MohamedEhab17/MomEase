import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class MentionTextEditingController extends TextEditingController {
  final String? mentionedName;

  MentionTextEditingController({this.mentionedName, super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final String currentText = text;

    // If no mention or text doesn't start with @, return normal text
    if (mentionedName == null || !currentText.startsWith('@')) {
      return TextSpan(text: currentText, style: style);
    }

    // Build the mention string
    final String mention = '@$mentionedName';

    // Check if text starts with the mention
    if (currentText.startsWith(mention)) {
      final String remainingText = currentText.substring(mention.length);

      return TextSpan(
        children: [
          TextSpan(
            text: mention,
            style: AppStyles.styleInter10.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.mentionBlue,
            ),
          ),
          if (remainingText.isNotEmpty)
            TextSpan(text: remainingText, style: style),
        ],
      );
    }

    return TextSpan(text: currentText, style: style);
  }
}
