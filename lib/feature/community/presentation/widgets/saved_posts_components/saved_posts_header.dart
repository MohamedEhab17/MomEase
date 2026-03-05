import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class SavedPostsHeader extends StatelessWidget {
  final int postsCount;

  const SavedPostsHeader({super.key, required this.postsCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.lightTextPrimary,
            size: 24.sp,
          ),
          padding: EdgeInsets.zero,
        ),
        Text('Saved Posts', style: AppStyles.styleInter24),
        const Spacer(),
        Text("$postsCount ${postsCount == 1 ? "post" : "posts"}"),
        20.width,
      ],
    );
  }
}
