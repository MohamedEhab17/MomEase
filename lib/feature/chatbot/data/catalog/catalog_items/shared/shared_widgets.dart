import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genui/genui.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';

/// Standardized entrance animation that fades and slides widgets up.
class GenUIEntranceAnimation extends StatefulWidget {
  const GenUIEntranceAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
  });

  final Widget child;
  final Duration duration;

  @override
  State<GenUIEntranceAnimation> createState() => _GenUIEntranceAnimationState();
}

class _GenUIEntranceAnimationState extends State<GenUIEntranceAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Unified Premium Card for Chatbot GenUI items.
class GenUICard extends StatelessWidget {
  const GenUICard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.hasShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool hasShadow;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    final fallbackBorderRadius = BorderRadius.circular(16.r);

    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.primaryTint,
        borderRadius: borderRadius ?? fallbackBorderRadius,
        border: Border.all(
          color: borderColor ?? colors.primaryExtraLight,
          width: 1.2.w,
        ),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: colors.primary.withAlpha(12),
                  blurRadius: 12.r,
                  offset: const Offset(0, 4),
                  spreadRadius: 1.r,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

/// Unified Empty State Widget for GenUI Collections.
class GenUIEmptyState extends StatelessWidget {
  const GenUIEmptyState({
    super.key,
    required this.message,
    this.icon,
  });

  final String message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.hourglass_empty_rounded,
              color: colors.greyPrimary.withAlpha(128),
              size: 40.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: AppStyles.styleRoboto16.copyWith(
                color: colors.greyPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Encapsulated Action & Context resolution to eliminate code redundancy.
abstract class GenUIActionHelper {
  static void dispatch({
    required BuildContext context,
    required JsonMap action,
    required String widgetId,
    required DispatchEventCallback dispatchEvent,
    required DataContext dataContext,
    Map<String, Object?>? additionalContext,
  }) {
    try {
      final String? actionName = action['name'] as String?;
      if (actionName == null || actionName.isEmpty) return;

      final List<Object?> contextDefinition =
          (action['context'] as List<Object?>?) ?? <Object?>[];

      final JsonMap resolvedContext = resolveContext(
        dataContext,
        contextDefinition,
      );

      if (additionalContext != null) {
        resolvedContext.addAll(additionalContext);
      }

      dispatchEvent(
        UserActionEvent(
          name: actionName,
          sourceComponentId: widgetId,
          context: resolvedContext,
        ),
      );
    } catch (e) {
      debugPrint('Error dispatching GenUI event inside $widgetId: $e');
    }
  }
}
