
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class AnswersOptions extends StatelessWidget {
  const AnswersOptions({
    super.key,
    required this.answer,
    this.onTap,
    required this.isSelected,
  });

  final String answer;
  final void Function()? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLighter : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 2),
              spreadRadius: 0,
              color: AppColors.lightTextPrimary.withAlpha(38),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            spacing: 12.w,
            crossAxisAlignment: .stretch,
            children: [
              Container(
                width: 4.w,

                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.greyMedium,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              Expanded(child: Text(answer, style: AppStyles.styleInter16)),
            ],
          ),
        ),
      ),
    );
  }
}
