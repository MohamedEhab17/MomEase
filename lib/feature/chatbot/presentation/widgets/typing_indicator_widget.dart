import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';

class TypingIndicatorWidget extends StatefulWidget {
  const TypingIndicatorWidget({super.key});

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bubbleColor = isDark
        ? context.ext.colors.primaryExtraLight
        : context.ext.colors.primaryLight;

    Widget bubble = Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.r), // notch pointing to avatar
          topRight: Radius.circular(20.r),
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AnimatedDot(controller: _controller, delay: 0),
          SizedBox(width: 4.w),
          _AnimatedDot(controller: _controller, delay: 0.2),
          SizedBox(width: 4.w),
          _AnimatedDot(controller: _controller, delay: 0.4),
        ],
      ),
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr, // Keep avatar on the left, bubble on the right
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.ext.colors.primaryExtraLight,
                border: Border.all(
                  color: context.ext.colors.primary.withAlpha(40),
                  width: 1.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.ext.colors.primary.withAlpha(20),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(6.w),
              child: SvgPicture.asset(
                AppIcons.iconsLunaBlue,
                colorMapper: AppSvgColorMapper(
                  from: const Color(0xff7AA2C2),
                  to: context.ext.colors.primaryDark,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Flexible(child: bubble),
          ],
        ),
      ),
    );
  }
}

class _AnimatedDot extends StatelessWidget {
  const _AnimatedDot({required this.controller, required this.delay});

  final AnimationController controller;
  final double delay;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = (controller.value - delay) % 1.0;
        final opacity = value < 0.5 ? value * 2 : (1 - value) * 2;
        return Opacity(
          opacity: opacity.clamp(0.3, 1.0),
          child: Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: context.ext.colors.primary,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
