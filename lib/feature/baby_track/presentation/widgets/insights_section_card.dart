import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

/// A white card with rounded corners and a subtle shadow,
/// used to wrap each section in the Insights tab.
class InsightsSectionCard extends StatelessWidget {
  final Widget child;

  const InsightsSectionCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: 16.r.allPadding,
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.ext.colors.primaryExtraLight),
        boxShadow: [
          BoxShadow(
            color: context.ext.colors.primaryLighter.withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
