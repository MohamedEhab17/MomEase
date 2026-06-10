import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

/// Standalone message box that displays the API-provided comparison message.
///
/// Previously this widget held a reference to the entire [FeedingFrequencyChart]
/// widget — that circular dependency has been removed. Only the message string
/// and colours needed for rendering are now passed in.
@Deprecated(
  'Use the inline _ReferenceMessageBox inside FeedingReferenceCard instead. '
  'Kept temporarily for any remaining call-sites outside this feature.',
)
class FeedingStatisticsComparisonWithReference extends StatelessWidget {
  const FeedingStatisticsComparisonWithReference({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.ext.colors;
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: context.theme.cardColor.withValues(alpha: 150),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              message,
              style: context.text.bodySmall!.copyWith(
                color: colors.lightTextPrimary,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
