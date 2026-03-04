import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/widgets/animated_dialog_container.dart';
import 'package:new_mama/feature/community/presentation/widgets/report_post_components/report_dialog_action_buttons.dart';
import 'package:new_mama/feature/community/presentation/widgets/report_post_components/report_dialog_header.dart';
import 'package:new_mama/feature/community/presentation/widgets/report_post_components/report_dialog_text_field.dart';
import 'package:new_mama/feature/community/presentation/widgets/report_post_components/report_success_dialog.dart';

class ReportPostDialog extends StatefulWidget {
  const ReportPostDialog({super.key});

  @override
  State<ReportPostDialog> createState() => _ReportPostDialogState();
}

class _ReportPostDialogState extends State<ReportPostDialog> {
  late final TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = .new();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _onSendReport() {
    context.pop();
    showDialog(context: context, builder: (_) => const ReportSuccessDialog());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogContainer(
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
    );
  }
}
