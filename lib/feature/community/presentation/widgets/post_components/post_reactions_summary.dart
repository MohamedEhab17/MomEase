import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/reaction_picker.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/reactions_list_sheet.dart';
import 'package:new_mama/feature/community/presentation/widgets/comment_components/comments_modal_sheet.dart';

/// The Facebook-style summary bar:
/// e.g.  ❤️👍💡  2  •  3 comments
class PostReactionsSummary extends StatelessWidget {
  final PostModel post;

  const PostReactionsSummary({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final hasReactions = post.reactionsCount > 0;
    final hasComments = post.commentsCount > 0;

    if (!hasReactions && !hasComments) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          // ── Reaction icons + count (tappable) ─────────────────
          if (hasReactions)
            GestureDetector(
              onTap: () async {
                // Force sync of any debounced reaction before showing the list
                await context.read<CommunityCubit>().syncPendingReactionNow(post.postId);
                if (!context.mounted) return;
                
                ReactionsListSheet.show(
                  context,
                  postId: post.postId,
                  reactionsCount: post.reactionsCount,
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ReactionIcons(post: post),
                  4.width,
                  Text(
                    _formatCount(post.reactionsCount),
                    style: context.text.bodySmall!.copyWith(
                      color: context.colors.onSurface.withAlpha(140),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          const Spacer(),

          // ── Comment count ──────────────────────────────────────
          if (hasComments)
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => CommentsModalSheet(
                    postId: post.postId.toString(),
                    postUserId: post.userId,
                    initialCommentCount: post.commentsCount,
                  ),
                );
              },
              child: Text(
                post.commentsCount == 1
                    ? '1 ${context.trContext(TK.communityComment)}'
                    : '${post.commentsCount} ${context.trContext(TK.communityComments)}',
                style: context.text.bodySmall!.copyWith(
                  color: context.colors.onSurface.withAlpha(140),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '$count';
  }
}

/// Shows up to 3 stacked reaction emoji circles (like Facebook)
class _ReactionIcons extends StatelessWidget {
  final PostModel post;

  const _ReactionIcons({required this.post});

  @override
  Widget build(BuildContext context) {
    // Determine which reaction types to show — prioritize myReaction first
    final typesToShow = _getTopTypes();

    return SizedBox(
      width: typesToShow.length * 18.w + 2.w,
      height: 22.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(typesToShow.length, (i) {
          final config = ReactionConfig.byType(typesToShow[i]);
          if (config == null) return const SizedBox.shrink();
          return Positioned(
            left: i * 14.w,
            child: Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: config.color.withAlpha(38),
                border: Border.all(
                  color: context.theme.scaffoldBackgroundColor,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  config.icon,
                  size: 12.sp,
                  color: config.color,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  List<String> _getTopTypes() {
    final types = <String>[];
    if (post.myReaction != null) {
      types.add(post.myReaction!);
    }
    if (types.isEmpty && post.reactionsCount > 0) {
      types.add('LOVE'); // Default generic reaction icon for others
    }
    return types;
  }
}
