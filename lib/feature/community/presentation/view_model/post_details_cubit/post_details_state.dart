import 'package:equatable/equatable.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';

enum PostDetailsStatus { initial, loading, success, error }

class PostDetailsState extends Equatable {
  final PostDetailsStatus status;
  final PostModel? post;
  final String? errorMessage;

  const PostDetailsState({
    this.status = PostDetailsStatus.initial,
    this.post,
    this.errorMessage,
  });

  PostDetailsState copyWith({
    PostDetailsStatus? status,
    PostModel? post,
    String? errorMessage,
  }) {
    return PostDetailsState(
      status: status ?? this.status,
      post: post ?? this.post,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, post, errorMessage];
}
