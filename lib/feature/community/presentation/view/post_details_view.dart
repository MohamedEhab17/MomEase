import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_state.dart';
import 'package:new_mama/feature/community/presentation/view_model/post_details_cubit/post_details_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/post_details_cubit/post_details_state.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_item.dart';
import 'package:animate_to/animate_to.dart';

class PostDetailsView extends StatelessWidget {
  final int postId;

  const PostDetailsView({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.isAr ? 'تفاصيل المنشور' : 'Post Details'),
      ),
      body: BlocConsumer<PostDetailsCubit, PostDetailsState>(
        listener: (context, state) {
          if (state.status == PostDetailsStatus.success && state.post != null) {
            context.read<CommunityCubit>().injectPost(state.post!);
          }
        },
        builder: (context, state) {
          if (state.status == PostDetailsStatus.loading ||
              state.status == PostDetailsStatus.initial) {
            return const Center(child: CustomLoadingIndicator());
          }
          if (state.status == PostDetailsStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'Error loading post'),
            );
          }
          if (state.status == PostDetailsStatus.success && state.post != null) {
            return BlocBuilder<CommunityCubit, CommunityState>(
              builder: (context, communityState) {
                final post = communityState.posts.firstWhere(
                  (p) => p.postId == postId,
                  orElse: () => state.post!,
                );
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: PostItem(
                    post: post,
                    controller: AnimateToController(),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
