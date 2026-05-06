import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Displays the AI confidence score as a rounded badge.
class SkinDiagnosisConfidenceBadge extends StatelessWidget {
  const SkinDiagnosisConfidenceBadge({super.key, required this.confidence});

  final double confidence;

  @override
  Widget build(BuildContext context) {
    final pct = confidence.toStringAsFixed(1);
    final Color badgeColor = _colorForConfidence(confidence);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(30),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: badgeColor.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.analytics_outlined, size: 16.w, color: badgeColor),
          6.horizontalSpace,
          Text(
            '$pct% Confidence',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _colorForConfidence(double v) {
    if (v >= 70) return const Color(0xFF4CAF50); // green
    if (v >= 40) return const Color(0xFFFFC107); // amber
    return const Color(0xFFFF5722); // orange-red
  }
}
