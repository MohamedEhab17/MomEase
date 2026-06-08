import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';

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
  final ValueNotifier<bool> isEmptyNotifier = ValueNotifier<bool>(true);

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

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    isEmptyNotifier.dispose();
    super.dispose();
  }

  void _checkEmptiness() {
    isEmptyNotifier.value = widget.controller.text.trim().isEmpty;
  }

  void _onTextChanged() {
    final isEmpty = widget.controller.text.trim().isEmpty;
    if (isEmptyNotifier.value != isEmpty) {
      isEmptyNotifier.value = isEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Container(
      color: Colors.transparent,
      alignment: Alignment.bottomCenter,
      margin: 20.hPadding,
      padding: 10.vPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          TextFormFieldHelper(
            controller: widget.controller,
            enabled: !widget.isProcessing,
            borderRadius: BorderRadius.circular(64),
            blurShadowRadius: 6,
            fillColor: context.ext.colors.darkTextPrimary,
            hint: context.trContext('chatbot.input_hint'),
            hintStyle: context.text.bodySmall!.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: context.ext.colors.lightTextDisabled,
            ),
            onFieldSubmitted: (_) {
              if (widget.controller.text.trim().isNotEmpty &&
                  !widget.isProcessing) {
                widget.onSend();
              }
            },
            suffixWidget: ValueListenableBuilder<bool>(
              valueListenable: isEmptyNotifier,
              builder: (context, isEmpty, child) {
                final bool canSend = !isEmpty && !widget.isProcessing;
                return InkWell(
                  onTap: canSend ? widget.onSend : null,
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
                                context.ext.colors.primaryExtraLight,
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
                                to: isEmpty
                                    ? context.ext.colors.primaryLighter
                                          .withAlpha(150)
                                    : context.ext.colors.primaryDark,
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          if (!isKeyboardOpen)
            FittedBox(
              child: Text(
                context.trContext('chatbot.disclaimer'),
                textAlign: TextAlign.center,
                maxLines: 1,
                style: context.text.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}
