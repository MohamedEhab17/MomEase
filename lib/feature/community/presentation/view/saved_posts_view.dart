import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_state.dart';
import 'package:new_mama/feature/community/presentation/widgets/saved_posts_components/saved_posts_body.dart';
import 'package:new_mama/feature/community/presentation/widgets/saved_posts_components/saved_posts_header.dart';

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
    _animateToController = AnimateToController();
  }

  @override
  void dispose() {
    _animateToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<CommunityCubit, CommunityState>(
          builder: (context, state) {
            if (state.status == CommunityStatus.loading) {
              return const Center(child: CustomLoadingIndicator());
            }

            if (state.status == CommunityStatus.error) {
              return Center(child: Text(state.errorMessage ?? "Error"));
            }

            return Column(
              children: [
                SavedPostsHeader(postsCount: state.posts.length),
                16.height,
                Expanded(
                  child: state.posts.isEmpty
                      ? Center(
                          child: Text(
                            "No saved posts",
                            style: context.text.titleSmall!.copyWith(
                              color: context.theme.hintColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ) // Localized later if needed
                      : SavedPostsBody(
                          savedPosts: state.posts,
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
