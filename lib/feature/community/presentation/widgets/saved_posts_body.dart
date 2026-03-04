import 'package:flutter/material.dart';
import 'package:animate_to/animate_to.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_item.dart';

class SavedPostsBody extends StatelessWidget {
  final List<PostModel> savedPosts;
  final AnimateToController controller;

  const SavedPostsBody({
    super.key,
    required this.savedPosts,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 18.hPadding,
      child: CustomScrollView(
        clipBehavior: Clip.hardEdge,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => PostItem(post: savedPosts[i], controller: controller),
              childCount: savedPosts.length,
            ),
          ),
        ],
      ),
    );
  }
}
