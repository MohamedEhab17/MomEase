import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import '../../domain/entities/cry_analysis.dart';
import 'crying_confidence_badge.dart';

/// A single history item card shown in the CryingHistoryView.
class CryingHistoryCard extends StatelessWidget {
  const CryingHistoryCard({
    super.key,
    required this.analysis,
    required this.onTap,
  });

  final CryAnalysis analysis;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final local = analysis.createdAt.toLocal();
    final formattedDate =
        '${local.day.toString().padLeft(2, '0')} / ${local.month.toString().padLeft(2, '0')} / ${local.year}  ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: context.ext.colors.primaryDark.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: context.ext.colors.primaryDark.withAlpha(20),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: context.ext.colors.primaryDark.withAlpha(20),
          highlightColor: context.ext.colors.primaryDark.withAlpha(10),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Audio Icon placeholder
                Container(
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: context.ext.colors.primaryDark.withAlpha(30),
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(15.r),
                      bottomStart: Radius.circular(15.r),
                    ),
                  ),
                  child: Icon(
                    Icons.audiotrack_rounded,
                    color: context.ext.colors.primaryDark,
                    size: 32.w,
                  ),
                ),
                16.horizontalSpace,

                // Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          analysis.result,
                          style: context.text.titleSmall!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.ext.colors.lightTextPrimary,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        8.verticalSpace,
                        CryingConfidenceBadge(
                          confidence: analysis.confidence,
                        ),
                        12.verticalSpace,
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              size: 14.w,
                              color: context.colors.onSurface.withAlpha(110),
                            ),
                            6.horizontalSpace,
                            Flexible(
                              child: Text(
                                formattedDate,
                                style: context.text.bodySmall!.copyWith(
                                  color: context.colors.onSurface.withAlpha(
                                    130,
                                  ),
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                12.horizontalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
