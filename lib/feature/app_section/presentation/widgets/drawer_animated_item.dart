import 'package:flutter/material.dart';

class DrawerAnimatedItem extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final double start;
  final double end;

  const DrawerAnimatedItem({
    super.key,
    required this.child,
    required this.animation,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Interval(start, end, curve: Curves.easeOutBack),
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (ctx, snapshot) => Transform.translate(
        offset: Offset(-40 * (1 - curved.value), 0),
        child: Opacity(opacity: curved.value.clamp(0.0, 1.0), child: child),
      ),
    );
  }
}
