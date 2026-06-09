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
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/core/widgets/delete_confirmation_dialog.dart';
import 'package:new_mama/feature/depression/domain/entities/assessment_result.dart';
import 'package:new_mama/feature/depression/presentation/view_model/depression_history_cubit/depression_history_cubit.dart';
import 'package:new_mama/feature/depression/presentation/view_model/depression_history_cubit/depression_history_state.dart';
import 'package:new_mama/feature/depression/presentation/widgets/depression_history_card.dart';

class DepressionHistoryView extends StatefulWidget {
  const DepressionHistoryView({super.key});

  @override
  State<DepressionHistoryView> createState() => _DepressionHistoryViewState();
}

class _DepressionHistoryViewState extends State<DepressionHistoryView> {
  @override
  void initState() {
    super.initState();
    context.read<DepressionHistoryCubit>().fetchHistory();
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
    return BlocConsumer<DepressionHistoryCubit, DepressionHistoryState>(
      listener: (context, state) {
        if (state is DepressionHistoryError) {
          AppToast.error(
            context,
            message: state.message,
          );
        }
      },
      builder: (context, state) {
        final list = (state is DepressionHistoryLoaded)
            ? state.historyList
            : (state is DepressionHistoryDeleting)
                ? state.currentList
                : <AssessmentResult>[];

        return Scaffold(
          appBar: FeaturesHeader(
            title: context.trContext(TK.skinHistoryTitle), // Or a specific key if available, reusing skin's "History"
            onPressed: () => context.pop(),
            trailingAction: const SizedBox.shrink(),
          ),
          body: () {
            if (state is DepressionHistoryInitial || state is DepressionHistoryLoading) {
              return const Center(
                child: CustomLoadingIndicator(),
              );
            }

            if (state is DepressionHistoryLoaded || state is DepressionHistoryDeleting) {
              if (list.isEmpty) {
                return Center(
                  child: Padding(
                    padding: 24.hPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          AppIcons.iconsSuccess, // Reusing success icon for empty state
                          width: 140.w,
                          height: 140.w,
                        ),
                        24.height,
                        Text(
                          context.trContext(TK.skinHistoryEmpty), // "No History Found"
                          style: context.text.titleMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.ext.colors.lightTextPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        12.height,
                        Text(
                          context.trContext(TK.skinHistoryEmptySubtitle), // "Your past records will appear here"
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

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final result = list[index];
                  return Dismissible(
                    key: ValueKey(result.id),
                    direction: DismissDirection.endToStart,
                    background: _buildDismissibleBackground(context),
                    confirmDismiss: (direction) async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (dialogCtx) => DeleteConfirmationDialog(
                          title: context.trContext(TK.skinDeleteConfirmTitle),
                          content: context.trContext(TK.skinDeleteConfirmBody),
                        ),
                      );
                      
                      if (confirmed == true) {
                        if (!context.mounted) return false;
                        context.read<DepressionHistoryCubit>().deleteHistoryItem(result.id);
                        return true;
                      }
                      return false;
                    },
                    child: DepressionHistoryCard(
                      result: result,
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          }(),
        );
      },
    );
  }
}
