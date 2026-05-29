import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/error_handler.dart';
import '../datasource/community_remote_datasource.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../models/post_pagination_model.dart';
import '../../domain/repository/community_repository.dart';
import '../models/reaction_model.dart';
import '../models/reply_model.dart';

@LazySingleton(as: CommunityRepository)
class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource _remoteDataSource;

  CommunityRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PostPaginationModel>> getPosts({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final result = await _remoteDataSource.getPosts(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PostPaginationModel>> getMyPosts({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final result = await _remoteDataSource.getMyPosts(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PostModel>> getPostById(int id) async {
    try {
      final result = await _remoteDataSource.getPostById(id);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PostModel>> createPost({
    required String text,
    List<String>? mediaFiles,
  }) async {
    try {
      final result = await _remoteDataSource.createPost(
        text: text,
        mediaFiles: mediaFiles,
      );
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, PostModel>> updatePost({
    required int id,
    required String text,
    List<int>? mediaIdsToDelete,
    List<String>? newMediaFiles,
  }) async {
    try {
      final result = await _remoteDataSource.updatePost(
        id: id,
        text: text,
        mediaIdsToDelete: mediaIdsToDelete,
        newMediaFiles: newMediaFiles,
      );
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(int id) async {
    try {
      await _remoteDataSource.deletePost(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> toggleSavePost({required int id, required bool save}) async {
    try {
      await _remoteDataSource.toggleSavePost(id: id, save: save);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getSavedPosts() async {
    try {
      final result = await _remoteDataSource.getSavedPosts();
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> reportPost({required int postId, required String reason}) async {
    try {
      await _remoteDataSource.reportPost(postId: postId, reason: reason);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> addReaction({required int postId, required String reactionType}) async {
    try {
      await _remoteDataSource.addReaction(postId: postId, reactionType: reactionType);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateReaction({required int postId, required String reactionType}) async {
    try {
      await _remoteDataSource.updateReaction(postId: postId, reactionType: reactionType);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> removeReaction({required int postId}) async {
    try {
      await _remoteDataSource.removeReaction(postId: postId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<ReactionModel>>> getPostReactions({required int postId}) async {
    try {
      final result = await _remoteDataSource.getPostReactions(postId: postId);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<CommentModel>>> getComments({required int postId}) async {
    try {
      final result = await _remoteDataSource.getComments(postId: postId);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, CommentModel>> addComment({required int postId, required String text}) async {
    try {
      final result = await _remoteDataSource.addComment(postId: postId, text: text);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, CommentModel>> updateComment({required int postId, required int commentId, required String text}) async {
    try {
      final result = await _remoteDataSource.updateComment(postId: postId, commentId: commentId, text: text);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment({required int postId, required int commentId}) async {
    try {
      await _remoteDataSource.deleteComment(postId: postId, commentId: commentId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ReactionModel>> addCommentReaction({required int postId, required int commentId, required String reactionType}) async {
    try {
      final result = await _remoteDataSource.addCommentReaction(postId: postId, commentId: commentId, reactionType: reactionType);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ReactionModel>> updateCommentReaction({required int postId, required int commentId, required String reactionType}) async {
    try {
      final result = await _remoteDataSource.updateCommentReaction(postId: postId, commentId: commentId, reactionType: reactionType);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> removeCommentReaction({required int postId, required int commentId}) async {
    try {
      await _remoteDataSource.removeCommentReaction(postId: postId, commentId: commentId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<ReplyModel>>> getReplies({required int postId, required int commentId}) async {
    try {
      final result = await _remoteDataSource.getReplies(postId: postId, commentId: commentId);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ReplyModel>> addReply({required int postId, required int commentId, required String text}) async {
    try {
      final result = await _remoteDataSource.addReply(postId: postId, commentId: commentId, text: text);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ReplyModel>> updateReply({required int postId, required int commentId, required int replyId, required String text}) async {
    try {
      final result = await _remoteDataSource.updateReply(postId: postId, commentId: commentId, replyId: replyId, text: text);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReply({required int postId, required int commentId, required int replyId}) async {
    try {
      await _remoteDataSource.deleteReply(postId: postId, commentId: commentId, replyId: replyId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
