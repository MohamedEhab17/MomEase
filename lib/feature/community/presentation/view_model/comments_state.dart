import 'package:equatable/equatable.dart';
import '../../data/models/comment_model.dart';

enum CommentsStatus { initial, loading, success, error }

class CommentsState extends Equatable {
  final List<CommentModel> comments;
  final CommentsStatus status;
  final String? errorMessage;
  final bool isSubmitting; // true while posting a comment/reply

  const CommentsState({
    this.comments = const [],
    this.status = CommentsStatus.initial,
    this.errorMessage,
    this.isSubmitting = false,
  });

  CommentsState copyWith({
    List<CommentModel>? comments,
    CommentsStatus? status,
    String? errorMessage,
    bool? isSubmitting,
  }) {
    return CommentsState(
      comments: comments ?? this.comments,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [comments, status, errorMessage, isSubmitting];
}
