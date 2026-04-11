import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/insight_view_scaffold.dart';

class CryingInsightView extends StatelessWidget {
  const CryingInsightView({super.key});

  static const List<String> _instructions = [
    'Record your baby\'s cry for 5-10 seconds',
    'AI analyzes the sound patterns and pitch',
    'Get insights and gentle suggestions to try',
  ];

  @override
  Widget build(BuildContext context) {
    return InsightViewScaffold(
      appBarTitle: 'Crying Sound analysis',
      icon: AppIcons.iconsSound,
      headline: 'Understanding Baby\'s Cry',
      subtitle:
          'Let our AI help you understand what your baby might be trying to communicate through their cry.',
      instructions: _instructions,
      instructionsTitle: 'How It Works',
      ctaText: 'Start Recording',
      onCtaPressed: () {
        context.push(AppRoutesPaths.cryingRecordingSessionView);
      },
    );
  }
}
