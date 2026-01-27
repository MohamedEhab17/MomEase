import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

/// Widget for chat input field
/// Styled to match new_mama app theme
class ChatInputWidget extends StatelessWidget {
  const ChatInputWidget({
    super.key,
    required this.controller,
    required this.onSend,
    this.isLoading = false,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: AppColors.lightTextPrimary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primarySoft3,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: TextField(
                  controller: controller,
                  enabled: !isLoading,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  style: AppStyles.styleRoboto16,
                  decoration: InputDecoration(
                    hintText: 'Ask me anything about postpartum care...',
                    hintStyle: AppStyles.styleRoboto16.copyWith(
                      color: AppColors.lightTextSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                  ),
                  onSubmitted: isLoading ? null : (_) => onSend(),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              decoration: BoxDecoration(
                color: isLoading ? AppColors.secondarySoft : AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isLoading ? null : onSend,
                  borderRadius: BorderRadius.circular(30.r),
                  child: Container(
                    width: 48.w,
                    height: 48.w,
                    alignment: Alignment.center,
                    child: isLoading
                        ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Icon(Icons.send, color: Colors.white, size: 24.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
