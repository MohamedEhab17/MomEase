
import 'package:animate_do/animate_do.dart';
import 'package:flutter/widgets.dart';

class CustomAnimatedWidget extends StatelessWidget {
  final int delay;
  final Widget child;
  final bool isDown;

  const CustomAnimatedWidget({
    super.key,
    required this.delay,
    required this.child,
    this.isDown = false,
  });

  @override
  Widget build(BuildContext context) {
    return isDown
        ? FadeInDown(
            delay: Duration(milliseconds: delay),
            child: child,
          )
        : FadeInUp(
            delay: Duration(milliseconds: delay),
            child: child,
          );
  }
}
