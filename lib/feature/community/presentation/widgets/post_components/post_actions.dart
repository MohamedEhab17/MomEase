import 'package:flutter/material.dart';
import 'package:animate_to/animate_to.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'actions/reaction_button.dart';
import 'actions/comment_button.dart';
import 'actions/save_button.dart';

class PostActions extends StatelessWidget {
  final PostModel post;
  final AnimateToController controller;
  final bool removeOnUnsave;

  const PostActions({
    super.key,
    required this.post,
    required this.controller,
    this.removeOnUnsave = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReactionButton(post: post),
        CommentButton(post: post),
        SaveButton(
          post: post,
          controller: controller,
          removeOnUnsave: removeOnUnsave,
        ),
      ],
    );
  }
}

