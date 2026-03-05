import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/love_action_button.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/widgets/shared_components/action_button.dart';
import 'package:new_mama/feature/community/presentation/widgets/comment_components/comments_modal_sheet.dart';

class PostActions extends StatelessWidget {
  const PostActions({super.key, required this.post, required this.controller});
  final PostModel post;
  final AnimateToController controller;

  void _showCommentsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsModalSheet(
        postId: post.id,
        initialCommentCount: post.comments,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CommunityCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        LoveActionButton(
          icon: post.isLiked
              ? AppIcons.iconsFilledLike
              : AppIcons.iconsUnfilledLike,
          label: post.likes == 0 ? "Liked" : "${post.likes}",
          isLiked: post.isLiked,
          onTap: () => cubit.toggleLike(post.id),
        ),
        ActionButton(
          icon: AppIcons.iconsComment,
          label: post.comments == 0 ? "Comment" : "${post.comments}",
          onTap: () => _showCommentsModal(context),
        ),
        ActionButton(
          animateKey: controller.tag('save_${post.id}'),
          icon: post.isSaved
              ? AppIcons.iconsFilledSave
              : AppIcons.iconsUnfilledSave,
          label: post.saves == 0 ? "Saved" : "${post.saves}",
          onTap: () {
            cubit.toggleSave(post.id);
            if (!post.isSaved) {
              controller.animateTag(
                'save_${post.id}',
                // duration: const Duration(milliseconds: 300),
              );
            }
          },
        ),
      ],
    );
  }
}
