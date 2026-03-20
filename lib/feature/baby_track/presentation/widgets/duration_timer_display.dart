import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class DurationTimerDisplay extends StatelessWidget {
  final int elapsedSeconds;

  const DurationTimerDisplay({super.key, required this.elapsedSeconds});

  String get _minutes => (elapsedSeconds ~/ 60).toString().padLeft(2, '0');
  String get _seconds => (elapsedSeconds % 60).toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Duration',
          style: AppStyles.styleInter12.copyWith(
            color: AppColors.lightTextPrimary.withAlpha(179),
            fontWeight: FontWeight.w600,
          ),
        ),
        4.h.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _AnimatedDigitsGroup(value: _minutes),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text(
                ':',
                style: AppStyles.styleInter32.copyWith(
                  color: AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _AnimatedDigitsGroup(value: _seconds),
          ],
        ),
      ],
    );
  }
}

class _AnimatedDigitsGroup extends StatelessWidget {
  final String value;
  const _AnimatedDigitsGroup({required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _AnimatedDigit(digit: value[0]),
        _AnimatedDigit(digit: value[1]),
      ],
    );
  }
}

class _AnimatedDigit extends StatelessWidget {
  final String digit;
  const _AnimatedDigit({required this.digit});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: Text(
        digit,
        key: ValueKey(digit),
        style: TextStyle(
          fontSize: 44.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
