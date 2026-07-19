import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/insight_view_scaffold.dart';

class CryingInsightView extends StatelessWidget {
  const CryingInsightView({super.key});

  @override
  Widget build(BuildContext context) {
    final instructions = [
      context.trContext(TK.babyCryInsightStep1),
      context.trContext(TK.babyCryInsightStep2),
      context.trContext(TK.babyCryInsightStep3),
    ];

    return InsightViewScaffold(
      appBarTitle: context.trContext(TK.babyCryAppBarTitle),
      icon: AppIcons.iconsSound,
      headline: context.trContext(TK.babyCryInsightHeadline),
      subtitle: context.trContext(TK.babyCryInsightSubtitle),
      instructions: instructions,
      instructionsTitle: context.trContext(TK.babyCryHowItWorks),
      ctaText: context.trContext(TK.babyCryStartRecording),
      onCtaPressed: () {
        context.push(AppRoutesPaths.cryingRecordingSessionView);
      },
      trailingAction: _HistoryIconButton(
        onTap: () => context.push(AppRoutesPaths.cryingHistoryView),
        tooltip: context.trContext(TK.babyCryViewHistory),
        color: context.ext.colors.primaryDark,
      ),
    );
  }
}

class _HistoryIconButton extends StatelessWidget {
  const _HistoryIconButton({
    required this.onTap,
    required this.tooltip,
    required this.color,
  });

  final VoidCallback onTap;
  final String tooltip;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          onPressed: onTap,
          icon: Icon(
            Icons.history_rounded,
            color: color,
            size: 26.sp,
          ),
        ),
      ),
    );
  }
}
