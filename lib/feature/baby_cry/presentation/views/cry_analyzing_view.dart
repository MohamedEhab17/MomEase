import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/analyzing_view_scaffold.dart';

class CryAnalyzingView extends StatefulWidget {
  const CryAnalyzingView({super.key});

  @override
  State<CryAnalyzingView> createState() => _CryAnalyzingViewState();
}

class _CryAnalyzingViewState extends State<CryAnalyzingView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      final advices = [
        context.trContext(TK.babyCryTip1),
        context.trContext(TK.babyCryTip2),
        context.trContext(TK.babyCryTip3),
        context.trContext(TK.babyCryTip4),
      ];
      context.push(AppRoutesPaths.cryingResultView, extra: advices);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnalyzingViewScaffold(
      icon: AppIcons.iconsSound,
      headline: context.trContext(TK.babyCryAnalyzingHeadline),
      subtitle: context.trContext(TK.babyCryAnalyzingSubtitle),
    );
  }
}
