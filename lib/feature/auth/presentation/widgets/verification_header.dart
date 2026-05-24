import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/feature/auth/presentation/widgets/custom_circle_avatar.dart';

class VerificationHeader extends StatelessWidget {
  final String email;

  const VerificationHeader({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        64.h.height,
        CustomCircleAvatar(imagePath: AppImages.imagesEmailVerification),
        40.h.height,
        Text(
          context.trContext(TK.authVerificationCodeInstructions),
          style: context.text.titleLarge!,
          textAlign: TextAlign.center,
        ),
        8.h.height,
        Text(
          email,
          style: context.text.bodyLarge!.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
