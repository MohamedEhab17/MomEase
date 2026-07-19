import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/insight_view_scaffold.dart';

class SkinDiagnosisInsightView extends StatelessWidget {
  const SkinDiagnosisInsightView({super.key});

  @override
  Widget build(BuildContext context) {
    final instructions = [
      context.trContext(TK.skinInsightStep1),
      context.trContext(TK.skinInsightStep2),
      context.trContext(TK.skinInsightStep3),
    ];

    return InsightViewScaffold(
      appBarTitle: context.trContext(TK.skinAppBarTitle),
      icon: AppIcons.iconsScan,
      headline: context.trContext(TK.skinInsightHeadline),
      subtitle: context.trContext(TK.skinInsightSubtitle),
      instructions: instructions,
      instructionsTitle: context.trContext(TK.skinHowItWorks),
      ctaText: context.trContext(TK.skinCtaText),
      onCtaPressed: () => context.push(AppRoutesPaths.skinDiagnosisPhotoView),
      // History lives as a clean icon in the AppBar trailing slot
      trailingAction: _HistoryIconButton(
        onTap: () => context.push(AppRoutesPaths.skinDiagnosisHistoryView),
        tooltip: context.trContext(TK.skinViewHistory),
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
