import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

/// Widget for displaying a chat message
/// Styled to match new_mama app theme
class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({
    super.key,
    required this.text,
    required this.alignment,
    this.icon,
  });

  final String text;
  final MainAxisAlignment alignment;
  final IconData? icon;

  bool get isUser => alignment == MainAxisAlignment.end;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.primarySoft3,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
            bottomLeft: isUser ? Radius.circular(20.r) : Radius.circular(4.r),
            bottomRight: isUser ? Radius.circular(4.r) : Radius.circular(20.r),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser && icon != null) ...[
              Icon(icon, color: AppColors.primary, size: 20.sp),
              SizedBox(width: 8.w),
            ],
            Flexible(
              child: Text(
                text,
                style: AppStyles.styleRoboto16.copyWith(
                  color: isUser ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
            ),
            if (isUser) ...[
              SizedBox(width: 8.w),
              Icon(Icons.person, color: Colors.white, size: 20.sp),
            ],
          ],
        ),
      ),
    );
  }
}
