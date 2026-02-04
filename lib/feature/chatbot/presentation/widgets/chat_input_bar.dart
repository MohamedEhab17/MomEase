import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
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
        mainAxisSize: .min,
        spacing: 6,
        children: [
          TextFormFieldHelper(
            controller: controller,
            enabled: !isProcessing,
            borderRadius: BorderRadius.circular(64),
            blurShadowRadius: 6,
            fillColor: AppColors.darkTextPrimary,
            hint: 'Type your message here..',
            hintStyle: AppStyles.styleInter10.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.lightTextDisabled,
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
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primarySoft2,
                          ),
                        ),
                      )
                    : SvgPicture.asset(
                        AppIcons.iconsSend,
                        width: 24.w,
                        height: 24.h,
                      ),
              ),
            ),
          ),
          FittedBox(
            child: Text(
              "AI can make mistakes. please double-check responses",
              textAlign: TextAlign.center,
              maxLines: 1,
              style: AppStyles.styleInter10,
            ),
          ),
        ],
      ),
    );
  }
}
