import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
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
  final isEmptyNotifier = ValueNotifier<bool>(true);
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      isEmptyNotifier.value = widget.controller.text.isEmpty;
    });
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
      suffixWidget: InkWell(
        onTap: widget.onSend,
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
              : ValueListenableBuilder(
                  valueListenable: isEmptyNotifier,
                  builder: (context, value, child) {
                    return SvgPicture.asset(
                      AppIcons.iconsSend,
                      width: 40.w,
                      height: 40.h,
                      colorMapper: AppSvgColorMapper(
                        from: Color(0xffFFC8DD),
                        to: value
                            ? context.ext.colors.primaryLighter
                            : context.ext.colors.primaryDark,
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
