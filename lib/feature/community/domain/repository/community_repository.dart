import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/post_model.dart';
import '../../data/models/post_pagination_model.dart';
import '../../data/models/reaction_model.dart';
import '../../data/models/reply_model.dart';

abstract class CommunityRepository {
  Future<Either<Failure, PostPaginationModel>> getPosts({
    required int pageNumber,
    required int pageSize,
  });
  Future<Either<Failure, PostPaginationModel>> getMyPosts({
    required int pageNumber,
    required int pageSize,
  });
  Future<Either<Failure, PostModel>> getPostById(int id);
  Future<Either<Failure, PostModel>> createPost({
    required String text,
    List<String>? mediaFiles,
  });
  Future<Either<Failure, PostModel>> updatePost({
    required int id,
    required String text,
    List<int>? mediaIdsToDelete,
    List<String>? newMediaFiles,
  });
  Future<Either<Failure, void>> deletePost(int id);
  Future<Either<Failure, void>> toggleSavePost({
    required int id,
    required bool save,
  });
  Future<Either<Failure, List<PostModel>>> getSavedPosts();
  Future<Either<Failure, void>> reportPost({
    required int postId,
    required String reason,
  });

  Future<Either<Failure, void>> addReaction({required int postId, required String reactionType});
  Future<Either<Failure, void>> updateReaction({required int postId, required String reactionType});
  Future<Either<Failure, void>> removeReaction({required int postId});
  Future<Either<Failure, List<ReactionModel>>> getPostReactions({required int postId});
  // Comments
  Future<Either<Failure, List<CommentModel>>> getComments({required int postId});
  Future<Either<Failure, CommentModel>> addComment({required int postId, required String text});
  Future<Either<Failure, CommentModel>> updateComment({required int postId, required int commentId, required String text});
  Future<Either<Failure, void>> deleteComment({required int postId, required int commentId});
  Future<Either<Failure, ReactionModel>> addCommentReaction({required int postId, required int commentId, required String reactionType});
  Future<Either<Failure, ReactionModel>> updateCommentReaction({required int postId, required int commentId, required String reactionType});
  Future<Either<Failure, void>> removeCommentReaction({required int postId, required int commentId});
  // Replies
  Future<Either<Failure, List<ReplyModel>>> getReplies({required int postId, required int commentId});
  Future<Either<Failure, ReplyModel>> addReply({required int postId, required int commentId, required String text});
  Future<Either<Failure, ReplyModel>> updateReply({required int postId, required int commentId, required int replyId, required String text});
  Future<Either<Failure, void>> deleteReply({required int postId, required int commentId, required int replyId});
}
