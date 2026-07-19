import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
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
            label = context.trContext(TK.babyFeedingBreastfeeding);
            break;
          case FeedingType.formulaFeeding:
            label = context.trContext(TK.babyFeedingFormulaFeeding);
            break;
          case FeedingType.solidfood:
            label = context.trContext(TK.childrenSolidFood);
            break;
        }

        return GestureDetector(
          onTap: () => onSelected(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.ext.colors.backgroundPink
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(64.r),
              border: Border.all(
                color: isSelected
                    ? context.ext.colors.primaryDark
                    : context.ext.colors.lightTextDisabled,
              ),
            ),
            child: Text(
              label,
              style: context.text.bodyLarge!.copyWith(
                color: isSelected
                    ? context.ext.colors.primaryDark
                    : context.ext.colors.lightTextDisabled,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
