import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/analyzing_view_scaffold.dart';

class CryAnalyzingView extends StatefulWidget {
  const CryAnalyzingView({super.key});

  @override
  State<CryAnalyzingView> createState() => _CryAnalyzingViewState();
}

class _CryAnalyzingViewState extends State<CryAnalyzingView> {
  final List<String> advices = [
    'Take small moments for yourself, even 5 minutes of quiet time.',
    'Connect with loved ones or join a mother\'s support group.',
    'If you\'re concerned, reach out to your healthcare provider.',
    'Remember: asking for help is a sign of strength, not weakness.',
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      context.push(AppRoutesPaths.cryingResultView, extra: advices);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnalyzingViewScaffold(
      appBarTitle: 'Crying Sound Analysis',
      icon: AppIcons.iconsSound,
      headline: 'Analyzing Crying Condition',
      subtitle: 'Our AI is Carefully examining the Sound',
    );
  }
}
