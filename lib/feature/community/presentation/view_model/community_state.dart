import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:equatable/equatable.dart';

class CommunityState extends Equatable {
  final List<PostModel> posts;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  const CommunityState({
    this.posts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  CommunityState copyWith({
    List<PostModel>? posts,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return CommunityState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage, // Note: if null, it resets the error msg
    );
  }
  
  @override
  List<Object?> get props => [posts, isLoading, isLoadingMore, errorMessage];
}