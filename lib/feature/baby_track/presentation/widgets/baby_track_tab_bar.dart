import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

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
        color: context.ext.colors.primaryTint,
        borderRadius: BorderRadius.circular(64.r),
        border: Border.all(color: context.ext.colors.primaryExtraLight),
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
                      ? context.theme.cardColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(28.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: context.colors.onSurface.withAlpha(50),
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
                    style: context.text.titleSmall!.copyWith(
                      color: isSelected
                          ? context.ext.colors.primaryDark
                          : context.colors.onSurface,
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
