import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_state.dart';
import 'package:animate_to/animate_to.dart';
import 'package:new_mama/feature/app_section/presentation/widgets/app_header.dart';
import 'package:new_mama/feature/community/presentation/widgets/saved_posts_header.dart';
import 'package:new_mama/feature/community/presentation/widgets/saved_posts_body.dart';

class SavedPostsView extends StatefulWidget {
  const SavedPostsView({super.key});

  @override
  State<SavedPostsView> createState() => _SavedPostsViewState();
}

class _SavedPostsViewState extends State<SavedPostsView> {
  late AnimateToController _animateToController;

  @override
  void initState() {
    super.initState();
    _animateToController = .new();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(), // Assume this works well as a header.
      body: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          final savedPosts = state.posts.where((p) => p.isSaved).toList();

          if (savedPosts.isEmpty) {
            return Center(
              child: Text("No Saved Posts", style: AppStyles.styleInter24),
            );
          }

          return Column(
            crossAxisAlignment: .start,
            children: [
              SavedPostsHeader(postsCount: savedPosts.length),
              Expanded(
                child: SavedPostsBody(
                  savedPosts: savedPosts,
                  controller: _animateToController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
