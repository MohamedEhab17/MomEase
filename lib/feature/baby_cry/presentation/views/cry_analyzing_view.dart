import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/analyzing_view_scaffold.dart';
import '../view_model/cubit/baby_cry_cubit.dart';
import '../view_model/cubit/baby_cry_state.dart';

class CryAnalyzingView extends StatelessWidget {
  const CryAnalyzingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BabyCryCubit, BabyCryState>(
      listener: (context, state) {
        if (state.status == BabyCryStatus.success &&
            state.analysisResult != null) {
          context.pushReplacement(
            AppRoutesPaths.cryingResultView,
            extra: state.analysisResult,
          );
        } else if (state.status == BabyCryStatus.error) {
          AppToast.error(
            context,
            message: state.errorMessage ?? context.trContext(TK.babyCryError),
          );
          context.go(AppRoutesPaths.cryingInsightView);
        }
      },
      child: AnalyzingViewScaffold(
        icon: AppIcons.iconsSound,
        headline: context.trContext(TK.babyCryAnalyzingHeadline),
        subtitle: context.trContext(TK.babyCryAnalyzingSubtitle),
      ),
    );
  }
}
