import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';

class GenderSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onChanged;

  const GenderSelector({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GenderChip(
          label: context.trContext(TK.childrenBoy),
          emoji: '👦',
          isSelected: selected == 'Boy',
          color: context.ext.colors.backgroundBlue,
          selectedColor: context.ext.colors.primaryDark,
          onTap: () => onChanged('Boy'),
        ),
        16.width,
        GenderChip(
          label: context.trContext(TK.childrenGirl),
          emoji: '👧',
          isSelected: selected == 'Girl',
          color: context.ext.colors.primaryLighter,
          selectedColor: context.ext.colors.primaryDark,
          onTap: () => onChanged('Girl'),
        ),
      ],
    );
  }
}

class GenderChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final Color color;
  final Color selectedColor;
  final VoidCallback onTap;

  const GenderChip({
    super.key,
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.color,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 56.h,
          decoration: BoxDecoration(
            color: isSelected ? color : color.withValues(alpha: 40),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? selectedColor : color.withValues(alpha: 80),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: TextStyle(fontSize: 20.sp)),
              8.width,
              Text(
                label,
                style: context.text.titleMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isSelected ? selectedColor : context.colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
