import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

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
          margin: 4.r.allPadding,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? context.theme.cardColor : Colors.transparent,
            borderRadius: BorderRadius.circular(64.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.text.titleSmall!.copyWith(
              color: isSelected
                  ? context.ext.colors.primaryDark
                  : context.colors.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
