import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class AnimatedDottedContainer extends StatefulWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;
  final BorderRadius borderRadius;
  final Duration duration;

  const AnimatedDottedContainer({
    super.key,
    required this.child,
    this.color = Colors.blue,
    this.strokeWidth = 2,
    this.dashPattern = const [6, 4],
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedDottedContainer> createState() =>
      _AnimatedDottedContainerState();
}

class _AnimatedDottedContainerState extends State<AnimatedDottedContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: DottedBorder(
        animation: _controller,

        options: RectDottedBorderOptions(
          dashPattern: widget.dashPattern,
          strokeWidth: widget.strokeWidth,
          color: widget.color,
        ),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
