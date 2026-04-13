import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_state.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:new_mama/feature/community/presentation/widgets/community_components/community_header.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_item.dart';

class CommunityBody extends StatefulWidget {
  const CommunityBody({super.key});

  @override
  State<CommunityBody> createState() => _CommunityBodyState();
}

class _CommunityBodyState extends State<CommunityBody> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<CommunityCubit>().refresh(),
      child: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          final bool showSkeleton = state.isLoading && state.posts.isEmpty;
          final List<PostModel> displayPosts = showSkeleton
              ? List.generate(3, (index) => _getDummyPost(index))
              : state.posts;

          return Column(
            children: [
              CommunityHeader(controller: _animateToController),
              Expanded(
                child: CustomScrollView(
                  clipBehavior: Clip.hardEdge,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    Skeletonizer.sliver(
                      enabled: showSkeleton,
                      child: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => PostItem(
                            post: displayPosts[i],
                            controller: _animateToController,
                          ),
                          childCount: displayPosts.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  late AnimateToController _animateToController;

  PostModel _getDummyPost(int index) => PostModel(
    id: 'skeleton_placeholder_$index',
    userName: 'Skeleton Name Loading',
    userImage: '',
    text: 'This is a detailed skeleton loading text meant to perfectly mimic the appearance of a standard community post. It spans multiple lines to ensure a realistic layout representation.',
    likes: 120,
    comments: 45,
    saves: 10,
    isLiked: false,
    isSaved: false,
  );

  @override
  void initState() {
    super.initState();
    _animateToController = AnimateToController();
  }
}
