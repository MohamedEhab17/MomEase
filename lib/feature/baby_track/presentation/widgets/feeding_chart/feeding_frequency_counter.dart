import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';

class FeedingFrequencyCounter extends StatelessWidget {
  final int count;
  final ValueChanged<int> onChanged;

  const FeedingFrequencyCounter({
    super.key,
    required this.count,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: colors.backgroundPink.withAlpha(51),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: colors.primaryLighter.withAlpha(77),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: colors.backgroundPink,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cookie_outlined,
                  color: colors.primaryDark,
                  size: 20.sp,
                ),
              ),
              8.w.width,
              Text(
                context.trContext(TK.babyFeedingFrequency),
                style: context.text.titleMedium!.copyWith(
                  color: colors.primaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          20.h.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decrement Button
              GestureDetector(
                onTap: count > 1 ? () => onChanged(count - 1) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52.w,
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: count > 1
                        ? context.theme.cardColor
                        : context.theme.cardColor.withAlpha(100),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: count > 1
                          ? colors.primaryDark.withAlpha(128)
                          : colors.lightTextDisabled.withAlpha(50),
                    ),
                  ),
                  child: Icon(
                    Icons.remove_rounded,
                    color: count > 1 ? colors.primaryDark : colors.lightTextDisabled,
                    size: 28.sp,
                  ),
                ),
              ),
              40.w.width,
              // Large Counter Text
              Text(
                '$count',
                style: context.text.headlineLarge!.copyWith(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.w900,
                  color: colors.primaryDark,
                ),
              ),
              40.w.width,
              // Increment Button
              GestureDetector(
                onTap: count < 20 ? () => onChanged(count + 1) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52.w,
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: count < 20
                        ? context.theme.cardColor
                        : context.theme.cardColor.withAlpha(100),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: count < 20
                          ? colors.primaryDark.withAlpha(128)
                          : colors.lightTextDisabled.withAlpha(50),
                    ),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: count < 20 ? colors.primaryDark : colors.lightTextDisabled,
                    size: 28.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
