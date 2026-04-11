import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_state.dart';
import 'package:animate_to/animate_to.dart';
import 'package:new_mama/feature/community/presentation/widgets/saved_posts_components/saved_posts_header.dart';
import 'package:new_mama/feature/community/presentation/widgets/saved_posts_components/saved_posts_body.dart';

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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<CommunityCubit, CommunityState>(
          builder: (context, state) {
            final savedPosts = state.posts.where((p) => p.isSaved).toList();

            if (savedPosts.isEmpty) {
              return Column(
                children: [
                  SavedPostsHeader(
                    postsCount: savedPosts.length,
                    showTrailing: false,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "No Saved Posts",
                        style: context.text.displaySmall!,
                      ),
                    ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: 10.vPadding,
                  child: SavedPostsHeader(postsCount: savedPosts.length),
                ),
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
      ),
    );
  }
}
