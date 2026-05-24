import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/animated_dialog_container.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_state.dart';
import 'package:new_mama/feature/community/presentation/widgets/report_post_components/report_dialog_action_buttons.dart';
import 'package:new_mama/feature/community/presentation/widgets/report_post_components/report_dialog_header.dart';
import 'package:new_mama/feature/community/presentation/widgets/report_post_components/report_dialog_text_field.dart';
import 'package:new_mama/feature/community/presentation/widgets/report_post_components/report_success_dialog.dart';

class ReportPostDialog extends StatefulWidget {
  final int postId;

  const ReportPostDialog({super.key, required this.postId});

  @override
  State<ReportPostDialog> createState() => _ReportPostDialogState();
}

class _ReportPostDialogState extends State<ReportPostDialog> {
  late final TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _onSendReport() {
    final String reason = _reasonController.text.trim();
    if (reason.isEmpty) return;

    context.read<CommunityCubit>().reportPost(
      postId: widget.postId,
      reason: reason,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommunityCubit, CommunityState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == CommunityStatus.success ||
              current.status == CommunityStatus.error),
      listener: (context, state) {
        if (state.status == CommunityStatus.success) {
          context.pop(); // Close report dialog
          showDialog(
            context: context,
            builder: (_) => const ReportSuccessDialog(),
          );
        } else if (state.status == CommunityStatus.error) {
          context.pop(); // Close report dialog on error too
          AppToast.error(
            context,
            message:
                state.errorMessage ??
                context.trContext(TK.communityReportError),
          );
        }
      },
      child: AnimatedDialogContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ReportDialogHeader(),
            34.height,
            ReportDialogTextField(controller: _reasonController),
            24.height,
            ReportDialogActionButtons(onSendReport: _onSendReport),
          ],
        ),
      ),
    );
  }
}
