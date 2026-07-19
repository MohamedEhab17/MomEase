import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_state.dart';
import 'package:new_mama/feature/community/presentation/view_model/post_details_cubit/post_details_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/post_details_cubit/post_details_state.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_item.dart';
import 'package:new_mama/feature/community/presentation/widgets/comment_components/comments_modal_sheet.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/reactions_list_sheet.dart';
import 'package:animate_to/animate_to.dart';

class PostDetailsView extends StatelessWidget {
  final int postId;
  final String? action;

  const PostDetailsView({super.key, required this.postId, this.action});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          context.isAr ? 'تفاصيل المنشور' : 'Post Details',
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
      body: BlocConsumer<PostDetailsCubit, PostDetailsState>(
        listener: (context, state) {
          if (state.status == PostDetailsStatus.success && state.post != null) {
            context.read<CommunityCubit>().injectPost(state.post!);

            // Auto-open comments or reactions sheet if navigated from a comment/reaction notification
            if (action == 'comments') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final communityCubit = context.read<CommunityCubit>();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BlocProvider.value(
                    value: communityCubit,
                    child: CommentsModalSheet(
                      postId: state.post!.postId.toString(),
                      postUserId: state.post!.userId,
                      initialCommentCount: state.post!.commentsCount,
                    ),
                  ),
                );
              });
            } else if (action == 'reactions') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Sync any pending reactions before opening list sheet
                context.read<CommunityCubit>().syncPendingReactionNow(state.post!.postId).then((_) {
                  if (!context.mounted) return;
                  ReactionsListSheet.show(
                    context,
                    postId: state.post!.postId,
                    reactionsCount: state.post!.reactionsCount,
                  );
                });
              });
            }
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
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
