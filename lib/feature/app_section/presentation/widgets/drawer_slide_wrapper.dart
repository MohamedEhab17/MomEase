import 'package:flutter/material.dart';

class DrawerSlideWrapper extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const DrawerSlideWrapper({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.82;

    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final offsetX = isRTL
            ? width - (width * animation.value)
            : -width + (width * animation.value);

        return Transform.translate(
          offset: Offset(offsetX, 0),
          child: Container(
            width: width,
            decoration: BoxDecoration(
              boxShadow: [
                if (animation.value > 0)
                  BoxShadow(
                    // 0.15 opacity → 0.15 * 255 ≈ 38
                    color: Colors.black.withAlpha(38),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: Offset(isRTL ? -5 : 5, 0),
                  ),
              ],
            ),
            child: child,
          ),
        );
      },
    );
  }
}
