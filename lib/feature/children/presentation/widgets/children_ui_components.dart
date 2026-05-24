import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';

class ChildBackgroundDecoration extends StatelessWidget {
  final List<Color> colors;
  final double blurSigma;

  const ChildBackgroundDecoration({
    super.key,
    required this.colors,
    this.blurSigma = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PositionedDirectional(
          top: -100.h,
          end: -50.w,
          child: Container(
            width: 300.w,
            height: 300.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors[0].withAlpha(150),
            ),
          ),
        ),
        PositionedDirectional(
          top: 200.h,
          start: -100.w,
          child: Container(
            width: 250.w,
            height: 250.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors[1].withAlpha(150),
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}

class GenderEmoji extends StatelessWidget {
  final Child child;
  final double fontSize;

  const GenderEmoji({
    super.key,
    required this.child,
    this.fontSize = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        child.isBoy ? '👦' : '👧',
        style: TextStyle(fontSize: fontSize.sp),
      ),
    );
  }
}

class FormSectionLabel extends StatelessWidget {
  final String label;

  const FormSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.text.titleSmall!.copyWith(
        fontWeight: FontWeight.w600,
        color: context.colors.onSurface.withAlpha(180),
      ),
    );
  }
}
