

import 'package:flutter/material.dart';

class SeverityService {
  static Color getColor(String levelName) {
    switch (levelName) {
      case 'Minimal':
        return Colors.green;
      case 'Mild':
        return Colors.blue;
      case 'Moderate':
        return Colors.orange;
      case 'Severe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }


  static Color getBackgroundColor(String levelName) {
    switch (levelName) {
      case 'Minimal':
        return Colors.green.withAlpha(50);
      case 'Mild':
        return Colors.blue.withAlpha(50);
      case 'Moderate':
        return Colors.orange.withAlpha(50);
      case 'Severe':
        return Colors.red.withAlpha(50);
      default:
        return Colors.grey.withAlpha(50);
    }
  }
}
