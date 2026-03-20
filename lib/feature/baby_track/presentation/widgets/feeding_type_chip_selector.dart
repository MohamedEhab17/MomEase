import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/baby_track/data/models/baby_track_models.dart';

class FeedingTypeChipSelector extends StatelessWidget {
  final FeedingType selectedType;
  final ValueChanged<FeedingType> onSelected;

  const FeedingTypeChipSelector({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: FeedingType.values.map((type) {
        final isSelected = selectedType == type;

        String label = '';
        switch (type) {
          case FeedingType.breastfeeding:
            label = 'Breastfeeding';
            break;
          case FeedingType.formulaFeeding:
            label = 'Formula Feeding';
            break;
          case FeedingType.mixedFeeding:
            label = 'Mixed';
            break;
        }

        return GestureDetector(
          onTap: () => onSelected(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.backgroundPink : Colors.transparent,
              borderRadius: BorderRadius.circular(64.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryDark
                    : AppColors.lightTextDisabled,
              ),
            ),
            child: Text(
              label,
              style: AppStyles.styleInter12.copyWith(
                color: isSelected
                    ? AppColors.primaryDark
                    : AppColors.lightTextDisabled,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
