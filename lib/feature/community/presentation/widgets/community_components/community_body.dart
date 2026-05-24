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
  final ScrollController _scrollController = ScrollController();
  late AnimateToController _animateToController;

  @override
  void initState() {
    super.initState();
    _animateToController = AnimateToController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CommunityCubit>().loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<CommunityCubit>().refresh(),
      child: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          final bool showSkeleton = state.status == CommunityStatus.loading && state.posts.isEmpty;
          final List<PostModel> displayPosts = showSkeleton
              ? List.generate(3, (index) => _getDummyPost(index))
              : state.posts;

          if (state.status == CommunityStatus.error && state.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'Error loading posts'),
                  ElevatedButton(
                    onPressed: () => context.read<CommunityCubit>().loadPosts(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              CommunityHeader(controller: _animateToController),
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
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
                    if (state.status == CommunityStatus.loadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
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

  PostModel _getDummyPost(int index) => PostModel(
        postId: index,
        userId: 0,
        userName: 'Skeleton Name Loading',
        userPhoto: null,
        text: 'This is a detailed skeleton loading text meant to perfectly mimic the appearance of a standard community post.',
        media: const [],
        commentsCount: 0,
        reactionsCount: 0,
        createdAt: DateTime.now(),
      );
}
