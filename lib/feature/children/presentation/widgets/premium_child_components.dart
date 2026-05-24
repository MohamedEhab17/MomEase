import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class InfoItem {
  final String icon;
  final String label;
  final String value;
  final Color accentColor;

  const InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });
}

class PremiumInfoCard extends StatelessWidget {
  final InfoItem item;
  const PremiumInfoCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor.withValues(alpha: 200),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: context.theme.cardColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: item.accentColor.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: 16.w.allPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: 10.w.allPadding,
            decoration: BoxDecoration(
              color: item.accentColor.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Text(item.icon, style: TextStyle(fontSize: 22.sp)),
          ),
          16.height,
          Text(
            item.label,
            style: context.text.bodySmall!.copyWith(
              color: context.ext.colors.lightTextDisabled,
              fontWeight: FontWeight.w600,
            ),
          ),
          2.height,
          Text(
            item.value,
            style: context.text.titleMedium!.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class PremiumActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const PremiumActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: 18.h.vPadding,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withAlpha(80),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: context.colors.onPrimary, size: 24.sp),
            12.width,
            Text(
              label,
              style: context.text.titleMedium!.copyWith(
                color: context.colors.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
