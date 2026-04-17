import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/feature/auth/presentation/widgets/custom_circle_avatar.dart';

class ResetPasswordHeader extends StatelessWidget {
  const ResetPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCircleAvatar(imagePath: AppImages.imagesForgetPassword),
        24.h.height,
        Text(
          'Verification Code',
          style: context.text.titleLarge!,
          textAlign: TextAlign.center,
        ),
        8.h.height,
        Text(
          'Please enter the 4-digit code sent to your email to reset your password.',
          textAlign: TextAlign.center,
          style: context.text.bodyMedium!.copyWith(
            color: context.ext.colors.lightTextDisabled,
          ),
        ),
      ],
    );
  }
}
