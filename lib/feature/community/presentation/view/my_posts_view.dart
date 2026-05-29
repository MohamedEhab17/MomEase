import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_state.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_item.dart';

class MyPostsView extends StatefulWidget {
  const MyPostsView({super.key});

  @override
  State<MyPostsView> createState() => _MyPostsViewState();
}

class _MyPostsViewState extends State<MyPostsView> {
  late AnimateToController _controller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = AnimateToController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<CommunityCubit>().loadMore(isMyPosts: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          context.trContext(TK.profileCommunityPosts),
          style: context.text.titleLarge!.copyWith(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          if (state.status == CommunityStatus.loading && state.posts.isEmpty) {
            return const Center(child: CustomLoadingIndicator());
          }

          if (state.status == CommunityStatus.error && state.posts.isEmpty) {
            return Center(child: Text(state.errorMessage ?? 'Error'));
          }

          if (state.posts.isEmpty) {
            return Center(
              child: Text(
                context.trContext(TK.communityNoSavedPosts), // Use appropriate empty key
                style: context.text.bodyMedium,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<CommunityCubit>().refresh(isMyPosts: true),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              itemCount: state.hasNextPage ? state.posts.length + 1 : state.posts.length,
              itemBuilder: (context, index) {
                if (index >= state.posts.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CustomLoadingIndicator(),
                    ),
                  );
                }
                return PostItem(post: state.posts[index], controller: _controller);
              },
            ),
          );
        },
      ),
    );
  }
}
