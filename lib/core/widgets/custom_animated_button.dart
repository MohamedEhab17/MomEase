import 'package:flutter/material.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';

class CustomAnimatedButton extends StatefulWidget {
  final String text;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Size? minimumSize;
  final Size? maxSize;
  final double borderRadius;
  final Color? borderColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final Duration animationDuration;
  final double scaleDownTo;

  const CustomAnimatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.minimumSize,
    this.maxSize,
    this.borderRadius = 64,
    this.borderColor,
    this.textStyle,
    this.padding,
    this.icon,
    this.animationDuration = const Duration(milliseconds: 200),
    this.scaleDownTo = 0.9,
  });

  @override
  State<CustomAnimatedButton> createState() => _CustomAnimatedButtonState();
}

class _CustomAnimatedButtonState extends State<CustomAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDownTo,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (widget.onPressed == null) return;

    await _controller.forward();
    if (mounted) {
      widget.onPressed!();
    }
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: CustomElevatedButton(
        text: widget.text,
        onPressed: widget.onPressed == null ? null : _handleTap,
        backgroundColor: widget.backgroundColor,
        minimumSize: widget.minimumSize,
        maxSize: widget.maxSize,
        borderRadius: widget.borderRadius,
        borderColor: widget.borderColor,
        textStyle: widget.textStyle,
        padding: widget.padding,
        icon: widget.icon,
      ),
    );
  }
}
