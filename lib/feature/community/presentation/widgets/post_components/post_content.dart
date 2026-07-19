import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_actions.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_body.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_header.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_reactions_summary.dart';

class PostContent extends StatelessWidget {
  final PostModel post;
  final AnimateToController controller;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final bool showDivider;
  final bool removeOnUnsave;

  const PostContent({
    super.key,
    required this.post,
    required this.controller,
    this.backgroundColor,
    this.boxShadow,
    this.showDivider = true,
    this.removeOnUnsave = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 12),
      padding: boxShadow != null ? const EdgeInsets.all(12) : null,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: boxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(post: post),
          PostBody(post: post),
          // ── Facebook-style summary bar ─────────────────────────
          if (post.reactionsCount > 0 || post.commentsCount > 0) ...[
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 0, end: 0),
              child: PostReactionsSummary(post: post),
            ),
          ],
          // ── Thin separator ────────────────────────────────────
          Divider(
            height: 1,
            color: context.ext.colors.primaryLighter.withAlpha(102),
          ),
          // ── Action buttons row ────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: PostActions(
              post: post,
              controller: controller,
              removeOnUnsave: removeOnUnsave,
            ),
          ),
          if (showDivider)
            Divider(color: context.ext.colors.primaryLighter, height: 1),
        ],
      ),
    );
  }
}
