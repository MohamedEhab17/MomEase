import 'package:flutter/material.dart';

import '../extensions/theme_ex.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.backgroundColor,
    this.minimumSize,
    this.borderRadius = 64,
    this.borderColor,
    this.textStyle,
    this.padding,
    this.maxSize,
    this.icon,
    this.elevation = 4,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.textColor,
  });

  final void Function()? onPressed;
  final String text;
  final Color? backgroundColor;
  final Size? minimumSize;
  final Size? maxSize;
  final double borderRadius;
  final Color? borderColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final double elevation;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon ?? const SizedBox.shrink(),
      style:
          ElevatedButton.styleFrom(
            backgroundColor:
                backgroundColor ??
                context.theme.buttonTheme.colorScheme!.primary,
            disabledBackgroundColor:
                disabledBackgroundColor ??
                backgroundColor ??
                context.theme.buttonTheme.colorScheme!.tertiary,
            disabledForegroundColor:
                disabledForegroundColor ??
                context.theme.buttonTheme.colorScheme!.onTertiary.withAlpha(
                  128,
                ),
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 42, vertical: 14),
            shadowColor: Theme.of(context).colorScheme.onSurface.withAlpha(64),
            elevation: elevation,
            minimumSize: minimumSize,
            maximumSize: maxSize,
            splashFactory: NoSplash.splashFactory,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(
                color: borderColor ?? backgroundColor ?? Colors.transparent,
              ),
            ),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.transparent;
              }
              if (states.contains(WidgetState.hovered)) {
                return Colors.transparent;
              }
              return null; // Defer to the widget's default.
            }),
          ),
      onPressed: onPressed,
      label: FittedBox(
        child: Text(
          text,
          style:
              textStyle ??
              context.text.headlineMedium!.copyWith(
                color:
                    textColor ?? context.theme.buttonTheme.colorScheme!.onPrimary,
              ),
        ),
      ),
    );
  }
}
