import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import '../models/post_model.dart';

abstract class CommunityRepository {
  Future<Either<Failure, List<PostModel>>> getPosts({bool refresh = false});
  Future<Either<Failure, List<PostModel>>> loadMorePosts();
  Future<Either<Failure, PostModel>> toggleLike(String postId);
  Future<Either<Failure, PostModel>> toggleSave(String postId);
  Future<Either<Failure, PostModel>> toggleComment(String postId);
  Future<Either<Failure, void>> deletePost(String postId);
  Future<Either<Failure, PostModel>> createPost(PostModel post);
}
