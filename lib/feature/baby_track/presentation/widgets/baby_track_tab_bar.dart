import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class BabyTrackTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const BabyTrackTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryTint,
        borderRadius: BorderRadius.circular(64.r),
        border: Border.all(color: AppColors.primaryExtraLight),
      ),
      padding: 10.allPadding,
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.lightBackground
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(28.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.lightTextPrimary.withAlpha(50),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                padding: 10.h.vPadding,
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: AppStyles.styleInter14.copyWith(
                      color: isSelected
                          ? AppColors.primaryDark
                          : AppColors.lightTextSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                    child: Text(tabs[i]),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
