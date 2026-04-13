import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
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
      onCtaPressed: () {
        context.push(AppRoutesPaths.skinDiagnosisPhotoView);
      },
    );
  }
}
