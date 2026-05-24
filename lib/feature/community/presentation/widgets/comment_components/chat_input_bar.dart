import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/community/presentation/widgets/comment_components/mention_text_controller.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.isProcessing,
    required this.controller,
    required this.onSend,
  });

  final bool isProcessing;
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final isEmptyNotifier = ValueNotifier<bool>(true);
  @override
  void initState() {
    super.initState();
    _checkEmptiness();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant ChatInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
      _checkEmptiness();
    }
  }

  void _checkEmptiness() {
    String currentText = widget.controller.text.trim();
    if (widget.controller is MentionTextEditingController) {
      final mentionCtrl = widget.controller as MentionTextEditingController;
      if (mentionCtrl.mentionedName != null) {
        final mentionStr = '@${mentionCtrl.mentionedName}';
        if (currentText.startsWith(mentionStr)) {
          currentText = currentText.substring(mentionStr.length).trim();
        }
      }
    }
    isEmptyNotifier.value = currentText.isEmpty;
  }

  void _onTextChanged() {
    String currentText = widget.controller.text.trim();
    if (widget.controller is MentionTextEditingController) {
      final mentionCtrl = widget.controller as MentionTextEditingController;
      if (mentionCtrl.mentionedName != null) {
        final mentionStr = '@${mentionCtrl.mentionedName}';
        if (currentText.startsWith(mentionStr)) {
          currentText = currentText.substring(mentionStr.length).trim();
        }
      }
    }
    final isEmpty = currentText.isEmpty;
    if (isEmptyNotifier.value != isEmpty) {
      isEmptyNotifier.value = isEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormFieldHelper(
      controller: widget.controller,
      enabled: !widget.isProcessing,
      borderRadius: BorderRadius.circular(64),
      fillColor: context.theme.colorScheme.surface,
      hint: context.trContext(TK.communityWriteComment),
      hintStyle: context.text.bodySmall!.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: context.ext.colors.lightTextDisabled,
      ),
      onFieldSubmitted: (_) => widget.onSend(),
      suffixWidget: ValueListenableBuilder(
        valueListenable: isEmptyNotifier,
        builder: (context, value, child) {
          return InkWell(
            onTap: (value || widget.isProcessing) ? null : widget.onSend,
            borderRadius: BorderRadius.circular(30.r),
            child: Container(
              width: 48.w,
              height: 48.w,
              alignment: Alignment.center,
              child: widget.isProcessing
                  ? SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.ext.colors.primaryTint,
                        ),
                      ),
                    )
                  : Transform.flip(
                      flipX: context.isAr,
                      child: SvgPicture.asset(
                        AppIcons.iconsSend,
                        width: 40.w,
                        height: 40.h,
                        colorMapper: AppSvgColorMapper(
                          from: const Color(0xffFFC8DD),
                          to: value
                              ? context.ext.colors.primaryLighter.withAlpha(150)
                              : context.ext.colors.primaryDark,
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
