import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class BabyTrackTabBar extends StatefulWidget {
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
  State<BabyTrackTabBar> createState() => _BabyTrackTabBarState();
}

class _BabyTrackTabBarState extends State<BabyTrackTabBar> {
  late List<GlobalKey> _tabKeys;

  @override
  void initState() {
    super.initState();
    _tabKeys = List.generate(widget.tabs.length, (index) => GlobalKey());
    _scrollToSelected();
  }

  @override
  void didUpdateWidget(covariant BabyTrackTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _scrollToSelected();
    }
    if (oldWidget.tabs.length != widget.tabs.length) {
      _tabKeys = List.generate(widget.tabs.length, (index) => GlobalKey());
    }
  }

  void _scrollToSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final key = _tabKeys[widget.selectedIndex];
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.5, // Center the active tab in the viewport
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.ext.colors.primaryTint,
        borderRadius: BorderRadius.circular(64.r),
        border: Border.all(color: context.ext.colors.primaryExtraLight),
      ),
      padding: 6.allPadding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(widget.tabs.length, (i) {
            final isSelected = i == widget.selectedIndex;
            return GestureDetector(
              key: _tabKeys[i],
              onTap: () => widget.onTabSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.theme.cardColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(28.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 10.h,
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: context.text.titleSmall!.copyWith(
                      color: isSelected
                          ? context.ext.colors.primaryDark
                          : context.colors.onSurface.withAlpha(180),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                    child: Text(widget.tabs[i]),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
