import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/core/widgets/delete_confirmation_dialog.dart';
import 'package:new_mama/feature/children/presentation/cubit/active_child_cubit.dart';
import '../widgets/crying_history_card.dart';
import '../view_model/cubit/baby_cry_cubit.dart';
import '../view_model/cubit/baby_cry_state.dart';

class CryingHistoryView extends StatefulWidget {
  const CryingHistoryView({super.key});

  @override
  State<CryingHistoryView> createState() => _CryingHistoryViewState();
}

class _CryingHistoryViewState extends State<CryingHistoryView> {
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    final activeChild = context.read<ActiveChildCubit>().state;
    if (activeChild != null) {
      context.read<BabyCryCubit>().loadChildHistory(activeChild.childId);
    } else {
      context.read<BabyCryCubit>().loadUserHistory();
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
    return BlocConsumer<BabyCryCubit, BabyCryState>(
      listener: (context, state) {
        if (state.status == BabyCryStatus.error && state.errorMessage != null) {
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
            title: context.trContext(TK.babyCryHistoryTitle),
            onPressed: () => context.pop(),
            trailingAction: const SizedBox.shrink(),
          ),
          body: () {
            // Loading
            if (state.status == BabyCryStatus.historyLoading) {
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
                      Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: context.ext.colors.primaryDark.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.history_toggle_off_rounded,
                          color: context.ext.colors.primaryDark,
                          size: 72.w,
                        ),
                      ),
                      24.height,
                      Text(
                        context.trContext(TK.babyCryHistoryEmpty),
                        style: context.text.titleMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.ext.colors.lightTextPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      12.height,
                      Text(
                        context.trContext(TK.babyCryHistoryEmptySubtitle),
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
                  key: ValueKey(analysis.cryId),
                  direction: DismissDirection.endToStart,
                  background: _buildDismissibleBackground(context),
                  confirmDismiss: (direction) async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogCtx) => DeleteConfirmationDialog(
                        title: context.trContext(TK.babyCryDeleteConfirmTitle),
                        content: context.trContext(TK.babyCryDeleteConfirmBody),
                      ),
                    );

                    if (confirmed == true) {
                      if (!context.mounted) return false;
                      context
                          .read<BabyCryCubit>()
                          .deleteCryAnalysis(analysis.cryId);
                      return true;
                    }
                    return false;
                  },
                  child: CryingHistoryCard(
                    analysis: analysis,
                    onTap: () => context.push(
                      AppRoutesPaths.cryingResultView,
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
