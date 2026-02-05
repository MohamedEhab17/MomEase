import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/cubit/bottom_nav_cubit.dart';

class ScrollVisibilityWrapper extends StatefulWidget {
  final Widget child;
  final double threshold;

  const ScrollVisibilityWrapper({
    super.key,
    required this.child,
    this.threshold = 6.0,
  });

  @override
  State<ScrollVisibilityWrapper> createState() =>
      _ScrollVisibilityWrapperState();
}

class _ScrollVisibilityWrapperState extends State<ScrollVisibilityWrapper> {
  double? lastOffset;
  late BottomNavCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<BottomNavCubit>();
  }

  bool _handleScrollNotification(ScrollNotification n) {
    if (n is! ScrollUpdateNotification) return false;
    if (n.metrics.axis != Axis.vertical) return false;

    final current = n.metrics.pixels;

    if (lastOffset == null) {
      lastOffset = current;
      return false;
    }

    if (current > lastOffset! + widget.threshold) {
      cubit.hide();
    } else if (current < lastOffset! - widget.threshold) {
      cubit.show();
    }

    lastOffset = current;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: widget.child,
    );
  }
}
