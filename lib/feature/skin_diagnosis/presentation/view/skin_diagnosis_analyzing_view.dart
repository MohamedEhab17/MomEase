import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/analyzing_view_scaffold.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view_model/skin_diagnosis_cubit.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view_model/skin_diagnosis_state.dart';

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
    _startAnalysis();
  }

  void _startAnalysis() {
    final activeChild = context.read<ActiveChildCubit>().state;
    if (activeChild == null) {
      // No child selected – go back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(AppRoutesPaths.skinDiagnosisPhotoView);
      });
      return;
    }
    context
        .read<SkinDiagnosisCubit>()
        .analyzeImage(childId: activeChild.childId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SkinDiagnosisCubit, SkinDiagnosisState>(
      listener: (context, state) {
        if (state.status == SkinDiagnosisStatus.success &&
            state.analysisResult != null) {
          context.pushReplacement(
            AppRoutesPaths.skinDiagnosisResultView,
            extra: state.analysisResult,
          );
        } else if (state.status == SkinDiagnosisStatus.error) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutesPaths.skinDiagnosisPhotoView);
          }
        }
      },
      child: AnalyzingViewScaffold(
        appBarTitle: context.trContext(TK.skinAppBarTitle),
        icon: AppIcons.iconsScan,
        headline: context.trContext(TK.skinAnalyzingHeadline),
        subtitle: context.trContext(TK.skinAnalyzingSubtitle),
        onBackPressed: () => context.go(AppRoutesPaths.appSectionView),
        indicator: Container(
          padding: 16.w.allPadding,
          decoration: BoxDecoration(
            color: context.ext.colors.primaryDark.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: CustomLoadingIndicator(
            color: context.ext.colors.primaryDark,
            size: 48.w,
          ),
        ),
      ),
    );
  }
}
