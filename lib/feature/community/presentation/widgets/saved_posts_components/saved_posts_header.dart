import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';

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
      mainAxisAlignment: MainAxisAlignment.start,
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
        Expanded(
          child: Text(
            context.trContext(TK.communitySavedPosts),
            style: context.text.displaySmall!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        showTrailing
            ? Text(
                postsCount == 1
                    ? context.trContext(TK.communitySavedPostsOnePost)
                    : context.trContext(
                        TK.communitySavedPostsNPosts,
                        namedArgs: {'count': '$postsCount'},
                      ),
              )
            : const SizedBox.shrink(),
        20.width,
      ],
    );
  }
}
