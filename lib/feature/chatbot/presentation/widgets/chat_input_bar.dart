import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';

class ChatInputBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
            controller: controller,
            enabled: !isProcessing,
            borderRadius: BorderRadius.circular(64),
            blurShadowRadius: 6,
            fillColor: context.ext.colors.darkTextPrimary,
            hint: context.trContext('chatbot.input_hint'),
            hintStyle: context.text.bodySmall!.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: context.ext.colors.lightTextDisabled,
            ),
            onFieldSubmitted: (_) => onSend(),
            suffixWidget: InkWell(
              onTap: onSend,
              borderRadius: BorderRadius.circular(30.r),
              child: Container(
                width: 48.w,
                height: 48.w,
                alignment: Alignment.center,
                child: isProcessing
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
                          width: 24.w,
                          height: 24.h,
                          colorMapper: AppSvgColorMapper(
                            from: const Color(0xffFFC8DD),
                            to: context.ext.colors.primaryDark,
                          ),
                        ),
                      ),
              ),
            ),
          ),
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
