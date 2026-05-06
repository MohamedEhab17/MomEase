import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view_model/skin_diagnosis_cubit.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/view_model/skin_diagnosis_state.dart';
import 'package:new_mama/feature/skin_diagnosis/presentation/widgets/skin_diagnosis_history_card.dart';

class SkinDiagnosisHistoryView extends StatefulWidget {
  const SkinDiagnosisHistoryView({super.key});

  @override
  State<SkinDiagnosisHistoryView> createState() =>
      _SkinDiagnosisHistoryViewState();
}

class _SkinDiagnosisHistoryViewState extends State<SkinDiagnosisHistoryView> {
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    final activeChild = context.read<ActiveChildCubit>().state;
    if (activeChild != null) {
      context
          .read<SkinDiagnosisCubit>()
          .loadChildHistory(activeChild.childId);
    } else {
      context.read<SkinDiagnosisCubit>().loadUserHistory();
    }
  }


  Widget _buildDismissibleBackground(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.redAccent.withAlpha(200),
        borderRadius: BorderRadius.circular(16.r),
      ),
      alignment: AlignmentDirectional.centerEnd,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28.w),
          4.verticalSpace,
          Text(
            context.trContext(TK.childrenRemove),
            style: context.text.labelMedium!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SkinDiagnosisCubit, SkinDiagnosisState>(
      listener: (context, state) {
        if (state.status == SkinDiagnosisStatus.error &&
            state.errorMessage != null) {
          AppToast.error(
            context,
            message: state.errorMessage!,
          );
        }
      },
      builder: (context, state) {
        final list = state.historyList;

        return Scaffold(
          appBar: FeaturesHeader(
            title: context.trContext(TK.skinHistoryTitle),
            onPressed: () => context.pop(),
            trailingAction: const SizedBox.shrink(),
          ),
          body: () {
            // Loading
            if (state.status == SkinDiagnosisStatus.historyLoading) {
              return const Center(
                child: CustomLoadingIndicator(),
              );
            }

            // Empty state
            if (list.isEmpty) {
              return Center(
                child: Padding(
                  padding: 24.hPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        AppIcons.iconsSuccess,
                        width: 140.w,
                        height: 140.w,
                      ),
                      24.height,
                      Text(
                        context.trContext(TK.skinHistoryEmpty),
                        style: context.text.titleMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.ext.colors.lightTextPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      12.height,
                      Text(
                        context.trContext(TK.skinHistoryEmptySubtitle),
                        style: context.text.bodyMedium!.copyWith(
                          color: context.colors.onSurface.withAlpha(150),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            // History list
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final analysis = list[index];
                return Dismissible(
                  key: ValueKey(analysis.skinAnalysisId),
                  direction: DismissDirection.endToStart,
                  background: _buildDismissibleBackground(context),
                  confirmDismiss: (direction) async {
                    bool confirmed = false;
                    await showDialog<void>(
                      context: context,
                      builder: (dialogCtx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r)),
                        title: Text(
                          context.trContext(TK.skinDeleteConfirmTitle),
                          style: context.text.titleMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        content: Text(
                          context.trContext(TK.skinDeleteConfirmBody),
                          style: context.text.bodyMedium,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogCtx).pop(),
                            child: Text(context.trContext(TK.childrenCancel)),
                          ),
                          TextButton(
                            onPressed: () {
                              confirmed = true;
                              Navigator.of(dialogCtx).pop();
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.redAccent),
                            child: Text(context.trContext(TK.childrenRemove)),
                          ),
                        ],
                      ),
                    );

                    if (confirmed) {
                      if (!context.mounted) return false;
                      context
                          .read<SkinDiagnosisCubit>()
                          .deleteAnalysis(analysis.skinAnalysisId);
                      return true;
                    }
                    return false;
                  },
                  child: SkinDiagnosisHistoryCard(
                    analysis: analysis,
                    onTap: () => context.push(
                      AppRoutesPaths.skinDiagnosisResultView,
                      extra: analysis,
                    ),
                  ),
                );
              },
            );
          }(),
        );
      },
    );
  }
}

