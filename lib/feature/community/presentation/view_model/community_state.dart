import 'package:new_mama/feature/community/data/models/post_model.dart';

class CommunityState {
  final List<PostModel> posts;
  final bool isLoading;
  final bool isLoadingMore;

  const CommunityState({
    this.posts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
  });

  CommunityState copyWith({
    List<PostModel>? posts,
    bool? isLoading,
    bool? isLoadingMore,
  }) {
    return CommunityState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}