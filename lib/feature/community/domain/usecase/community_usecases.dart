import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/post_model.dart';
import '../../data/models/post_pagination_model.dart';
import '../../data/models/reaction_model.dart';
import '../../data/models/reply_model.dart';
import '../repository/community_repository.dart';

@injectable
class GetPostsUseCase {
  final CommunityRepository repository;
  GetPostsUseCase(this.repository);

  Future<Either<Failure, PostPaginationModel>> call({required int pageNumber, int pageSize = 10}) {
    return repository.getPosts(pageNumber: pageNumber, pageSize: pageSize);
  }
}

@injectable
class GetMyPostsUseCase {
  final CommunityRepository repository;
  GetMyPostsUseCase(this.repository);

  Future<Either<Failure, PostPaginationModel>> call({required int pageNumber, int pageSize = 10}) {
    return repository.getMyPosts(pageNumber: pageNumber, pageSize: pageSize);
  }
}

@injectable
class GetPostByIdUseCase {
  final CommunityRepository repository;
  GetPostByIdUseCase(this.repository);

  Future<Either<Failure, PostModel>> call(int id) {
    return repository.getPostById(id);
  }
}

@injectable
class CreatePostUseCase {
  final CommunityRepository repository;
  CreatePostUseCase(this.repository);

  Future<Either<Failure, PostModel>> call({required String text, List<String>? mediaFiles}) {
    return repository.createPost(text: text, mediaFiles: mediaFiles);
  }
}

@injectable
class UpdatePostUseCase {
  final CommunityRepository repository;
  UpdatePostUseCase(this.repository);

  Future<Either<Failure, PostModel>> call({
    required int id,
    required String text,
    List<int>? mediaIdsToDelete,
    List<String>? newMediaFiles,
  }) {
    return repository.updatePost(
      id: id,
      text: text,
      mediaIdsToDelete: mediaIdsToDelete,
      newMediaFiles: newMediaFiles,
    );
  }
}

@injectable
class DeletePostUseCase {
  final CommunityRepository repository;
  DeletePostUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deletePost(id);
  }
}

@injectable
class AddReactionUseCase {
  final CommunityRepository repository;
  AddReactionUseCase(this.repository);
  Future<Either<Failure, void>> call({required int postId, required String reactionType}) {
    return repository.addReaction(postId: postId, reactionType: reactionType);
  }
}

@injectable
class UpdateReactionUseCase {
  final CommunityRepository repository;
  UpdateReactionUseCase(this.repository);
  Future<Either<Failure, void>> call({required int postId, required String reactionType}) {
    return repository.updateReaction(postId: postId, reactionType: reactionType);
  }
}

@injectable
class RemoveReactionUseCase {
  final CommunityRepository repository;
  RemoveReactionUseCase(this.repository);
  Future<Either<Failure, void>> call({required int postId}) {
    return repository.removeReaction(postId: postId);
  }
}

@injectable
class ToggleSavePostUseCase {
  final CommunityRepository repository;
  ToggleSavePostUseCase(this.repository);

  Future<Either<Failure, void>> call({required int id, required bool save}) {
    return repository.toggleSavePost(id: id, save: save);
  }
}

@injectable
class GetSavedPostsUseCase {
  final CommunityRepository repository;
  GetSavedPostsUseCase(this.repository);

  Future<Either<Failure, List<PostModel>>> call() {
    return repository.getSavedPosts();
  }
}

@injectable
class ReportPostUseCase {
  final CommunityRepository repository;
  ReportPostUseCase(this.repository);

  Future<Either<Failure, void>> call({required int postId, required String reason}) {
    return repository.reportPost(postId: postId, reason: reason);
  }
}

@injectable
class GetPostReactionsUseCase {
  final CommunityRepository repository;
  GetPostReactionsUseCase(this.repository);

  Future<Either<Failure, List<ReactionModel>>> call({required int postId}) {
    return repository.getPostReactions(postId: postId);
  }
}

@injectable
class GetCommentsUseCase {
  final CommunityRepository repository;
  GetCommentsUseCase(this.repository);

  Future<Either<Failure, List<CommentModel>>> call({required int postId}) {
    return repository.getComments(postId: postId);
  }
}

@injectable
class AddCommentUseCase {
  final CommunityRepository repository;
  AddCommentUseCase(this.repository);

  Future<Either<Failure, CommentModel>> call({required int postId, required String text}) {
    return repository.addComment(postId: postId, text: text);
  }
}

@injectable
class UpdateCommentUseCase {
  final CommunityRepository repository;
  UpdateCommentUseCase(this.repository);

  Future<Either<Failure, CommentModel>> call({required int postId, required int commentId, required String text}) {
    return repository.updateComment(postId: postId, commentId: commentId, text: text);
  }
}

@injectable
class DeleteCommentUseCase {
  final CommunityRepository repository;
  DeleteCommentUseCase(this.repository);

  Future<Either<Failure, void>> call({required int postId, required int commentId}) {
    return repository.deleteComment(postId: postId, commentId: commentId);
  }
}

@injectable
class AddCommentReactionUseCase {
  final CommunityRepository repository;
  AddCommentReactionUseCase(this.repository);

  Future<Either<Failure, ReactionModel>> call({required int postId, required int commentId, required String reactionType}) {
    return repository.addCommentReaction(postId: postId, commentId: commentId, reactionType: reactionType);
  }
}

@injectable
class UpdateCommentReactionUseCase {
  final CommunityRepository repository;
  UpdateCommentReactionUseCase(this.repository);

  Future<Either<Failure, ReactionModel>> call({required int postId, required int commentId, required String reactionType}) {
    return repository.updateCommentReaction(postId: postId, commentId: commentId, reactionType: reactionType);
  }
}

@injectable
class RemoveCommentReactionUseCase {
  final CommunityRepository repository;
  RemoveCommentReactionUseCase(this.repository);

  Future<Either<Failure, void>> call({required int postId, required int commentId}) {
    return repository.removeCommentReaction(postId: postId, commentId: commentId);
  }
}

@injectable
class GetRepliesUseCase {
  final CommunityRepository repository;
  GetRepliesUseCase(this.repository);

  Future<Either<Failure, List<ReplyModel>>> call({required int postId, required int commentId}) {
    return repository.getReplies(postId: postId, commentId: commentId);
  }
}

@injectable
class AddReplyUseCase {
  final CommunityRepository repository;
  AddReplyUseCase(this.repository);

  Future<Either<Failure, ReplyModel>> call({required int postId, required int commentId, required String text}) {
    return repository.addReply(postId: postId, commentId: commentId, text: text);
  }
}

@injectable
class UpdateReplyUseCase {
  final CommunityRepository repository;
  UpdateReplyUseCase(this.repository);

  Future<Either<Failure, ReplyModel>> call({required int postId, required int commentId, required int replyId, required String text}) {
    return repository.updateReply(postId: postId, commentId: commentId, replyId: replyId, text: text);
  }
}

@injectable
class DeleteReplyUseCase {
  final CommunityRepository repository;
  DeleteReplyUseCase(this.repository);

  Future<Either<Failure, void>> call({required int postId, required int commentId, required int replyId}) {
    return repository.deleteReply(postId: postId, commentId: commentId, replyId: replyId);
  }
}
