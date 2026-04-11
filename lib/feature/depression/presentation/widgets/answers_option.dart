import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

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
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: isSelected
                ? context.ext.colors.primaryLighter
                : context.theme.buttonTheme.colorScheme!.secondary,
            borderRadius: BorderRadius.circular(16.r),

            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 4),
                spreadRadius: 0,
                color: context.colors.onSurface.withAlpha(38),
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
                        ? context.theme.buttonTheme.colorScheme!.primary
                        : context.ext.colors.greyMedium,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                Expanded(
                  child: Text(
                    answer,
                    style: context.text.titleLarge!.copyWith(
                      color: context.theme.buttonTheme.colorScheme!.onSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
