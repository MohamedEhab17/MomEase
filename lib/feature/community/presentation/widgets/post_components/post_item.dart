import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_state.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_content.dart';

class PostItem extends StatelessWidget {
  final PostModel post;
  final AnimateToController controller;
  const PostItem({super.key, required this.post, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CommunityCubit, CommunityState, PostModel>(
      selector: (state) =>
          state.posts.firstWhere((p) => p.id == post.id),

      builder: (_, updatedPost) {
        return PostContent(post: updatedPost, controller: controller);
      },
    );
  }
}
