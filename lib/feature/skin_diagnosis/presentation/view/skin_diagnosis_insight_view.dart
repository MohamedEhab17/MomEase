import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/insight_view_scaffold.dart';

class SkinDiagnosisInsightView extends StatelessWidget {
  const SkinDiagnosisInsightView({super.key});

  static const List<String> _instructions = [
    'Take a clear photo of the affected skin area',
    'AI analyzes the image for common conditions',
    'Receive gentle care tips and recommendations',
  ];

  @override
  Widget build(BuildContext context) {
    return InsightViewScaffold(
      appBarTitle: 'Skin Diagnosis',
      icon: AppIcons.iconsScan,
      headline: 'Gentle Skin Guidance',
      subtitle:
          'Get AI-powered insights about common baby skin conditions and gentle care tips.',
      instructions: _instructions,
      instructionsTitle: 'How It Works',
      ctaText: 'Take or upload photo',
      onCtaPressed: () {
        context.push(AppRoutesPaths.skinDiagnosisPhotoView);
      },
    );
  }
}
