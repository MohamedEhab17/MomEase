import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';

class MentionInputBar extends StatefulWidget {
  const MentionInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.mentionedName,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final String? mentionedName;

  @override
  State<MentionInputBar> createState() => _MentionInputBarState();
}

class _MentionInputBarState extends State<MentionInputBar> {
  late FocusNode _focusNode;
  final isEmptyNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget.controller.addListener(_onTextChanged);
    widget.controller.addListener(() {
      isEmptyNotifier.value = widget.controller.text.isEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {}); // Rebuild to update send button color
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(64),
        color: context.colors.surface,
        boxShadow: [
          BoxShadow(
            color: context.colors.onSurface.withAlpha(38),
            blurRadius: 6,
            offset: const Offset(0, 0),
            spreadRadius: 0,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => widget.onSend(),
              style: context.text.bodySmall!.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: context.colors.onSurface,
              ),
              decoration: InputDecoration(
                hintText: context.trContext(TK.communityWriteComment),
                hintStyle: context.text.bodySmall!.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: context.ext.colors.lightTextDisabled,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: widget.onSend,
            borderRadius: BorderRadius.circular(30.r),
            child: Container(
              width: 48.w,
              height: 48.w,
              alignment: Alignment.center,
              child: ValueListenableBuilder(
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
        ],
      ),
    );
  }
}
