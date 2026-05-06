import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';

/// Renders the doctor advice text in a nicely styled card.
class SkinDiagnosisAdviceCard extends StatelessWidget {
  const SkinDiagnosisAdviceCard({super.key, required this.advice});

  final String advice;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_services_outlined,
                size: 18.w,
                color: context.ext.colors.primaryDark,
              ),
              8.horizontalSpace,
              Text(
                context.trContext(TK.skinCareTips),
                style: context.text.titleSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.ext.colors.primaryDark,
                ),
              ),
            ],
          ),
          12.verticalSpace,
          Text(
            advice,
            style: context.text.bodyMedium!.copyWith(
              color: context.colors.onSurface.withAlpha(200),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
