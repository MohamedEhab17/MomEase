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
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final bool showDivider;

  const PostContent({
    super.key,
    required this.post,
    required this.controller,
    this.backgroundColor,
    this.boxShadow,
    this.showDivider = true,
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
        crossAxisAlignment: .start,
        spacing: 12,
        children: [
          PostHeader(post: post),
          PostBody(post: post),
          PostActions(post: post, controller: controller),
          if (showDivider)
            Divider(color: context.ext.colors.primaryLighter, height: 1),
        ],
      ),
    );
  }
}
