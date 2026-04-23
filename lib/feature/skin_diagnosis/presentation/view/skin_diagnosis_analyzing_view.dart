import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/analyzing_view_scaffold.dart';

class SkinDiagnosisAnalyzingView extends StatefulWidget {
  const SkinDiagnosisAnalyzingView({super.key});

  @override
  State<SkinDiagnosisAnalyzingView> createState() =>
      _SkinDiagnosisAnalyzingViewState();
}

class _SkinDiagnosisAnalyzingViewState
    extends State<SkinDiagnosisAnalyzingView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      final advices = [
        context.trContext(TK.skinTip1),
        context.trContext(TK.skinTip2),
        context.trContext(TK.skinTip3),
        context.trContext(TK.skinTip4),
      ];
      context.pushReplacement(
        AppRoutesPaths.skinDiagnosisResultView,
        extra: advices,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnalyzingViewScaffold(
      appBarTitle: context.trContext(TK.skinAppBarTitle),
      icon: AppIcons.iconsScan,
      headline: context.trContext(TK.skinAnalyzingHeadline),
      subtitle: context.trContext(TK.skinAnalyzingSubtitle),
      onBackPressed: () {
        context.go(AppRoutesPaths.appSectionView);
      },
      indicator: Container(
        padding: 16.w.allPadding,
        decoration: BoxDecoration(
          color: context.ext.colors.primaryDark.withAlpha(26),
          shape: BoxShape.circle,
        ),
        child: SpinKitFadingCircle(
          color: context.ext.colors.primaryDark,
          size: 48.w,
        ),
      ),
    );
  }
}
