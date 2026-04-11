import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_actions.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_body.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_header.dart';

class PostContent extends StatelessWidget {
  final PostModel post;
  final AnimateToController controller;

  const PostContent({super.key, required this.post, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.ext.colors.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withAlpha(21),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: .start,
        spacing: 12,
        children: [
          PostHeader(post: post),
          PostBody(post: post),
          PostActions(post: post, controller: controller),
        ],
      ),
    );
  }
}
