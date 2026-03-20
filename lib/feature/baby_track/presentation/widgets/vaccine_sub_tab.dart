import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

/// Animated sub-tab button used inside the Vaccine tab
/// to switch between "Baby's Log" and "Official Schedule".
class VaccineSubTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const VaccineSubTab({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: EdgeInsets.all(4.r),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.lightBackground : Colors.transparent,
            borderRadius: BorderRadius.circular(64.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppStyles.styleInter14.copyWith(
              color: isSelected
                  ? AppColors.primaryDark
                  : AppColors.lightTextSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
