import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';

class ChildCard extends StatelessWidget {
  final Child child;
  final VoidCallback onTap;

  const ChildCard({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isBoy = child.isBoy;
    final boyGradient = LinearGradient(
      colors: [context.ext.colors.backgroundBlue, context.ext.colors.backgroundBlueDarker],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final girlGradient = LinearGradient(
      colors: [context.ext.colors.primaryLighter, context.ext.colors.primaryAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.w,
        margin: EdgeInsetsDirectional.only(end: 12.w),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: context.colors.primary.withAlpha(30),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isBoy ? boyGradient : girlGradient,
                boxShadow: [
                  BoxShadow(
                    color: (isBoy
                        ? context.ext.colors.backgroundBlue
                        : context.ext.colors.primaryLighter)
                        .withValues(alpha: 100),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: child.photoUrl != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: child.photoUrl!.startsWith('http')
                            ? child.photoUrl!
                            : 'http://momease.runasp.net${child.photoUrl}',
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _genderIcon(isBoy),
                      ),
                    )
                  : _genderIcon(isBoy),
            ),
            12.height,
            // Name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                child.fullName,
                style: context.text.titleMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colors.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            6.height,
            // Age label
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isBoy
                    ? context.ext.colors.backgroundBlue.withValues(alpha: 60)
                    : context.ext.colors.primaryExtraLight,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                child.ageLabel,
                style: context.text.bodySmall!.copyWith(
                  color: isBoy
                      ? context.ext.colors.primaryDark
                      : context.ext.colors.primaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            8.height,
            // Gender badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: isBoy
                    ? context.ext.colors.backgroundBlue.withValues(alpha: 30)
                    : context.ext.colors.primaryExtraLight.withValues(alpha: 150),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isBoy
                      ? context.ext.colors.backgroundBlue
                      : context.ext.colors.primaryLighter,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isBoy ? '👦' : '👧',
                    style: const TextStyle(fontSize: 12),
                  ),
                  4.width,
                  Text(
                    child.gender,
                    style: context.text.bodySmall!.copyWith(
                      color: isBoy
                          ? context.ext.colors.primaryDark
                          : context.ext.colors.primaryDark,
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderIcon(bool isBoy) {
    return Center(
      child: Text(
        isBoy ? '👦' : '👧',
        style: TextStyle(fontSize: 36.sp),
      ),
    );
  }
}
