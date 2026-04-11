import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class SavedPostsHeader extends StatelessWidget {
  final int postsCount;
  final bool showTrailing;

  const SavedPostsHeader({
    super.key,
    required this.postsCount,
    this.showTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .start,
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colors.onSurface,
            size: 24.sp,
          ),
          padding: EdgeInsets.zero,
        ),
        Text('Saved Posts', style: context.text.displaySmall!),
        const Spacer(),
        showTrailing
            ? Text("$postsCount ${postsCount == 1 ? "post" : "posts"}")
            : const SizedBox.shrink(),
        20.width,
      ],
    );
  }
}
