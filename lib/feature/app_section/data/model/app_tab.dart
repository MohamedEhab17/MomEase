import 'package:flutter/widgets.dart';

class AppTab {
  final Widget view;
  final String activeIcon;
  final String inactiveIcon;

  const AppTab({
    required this.view,
    required this.activeIcon,
    required this.inactiveIcon,
  });
}
