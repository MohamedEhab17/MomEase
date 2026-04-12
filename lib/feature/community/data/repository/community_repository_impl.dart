import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';

import '../datasource/community_local_datasource.dart';
import '../models/post_model.dart';
import 'community_repository.dart';

@LazySingleton(as: CommunityRepository)
class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityLocalDataSource _localDataSource;
  
  // In-memory cache
  List<PostModel> _cachedPosts = [];
  int _currentPage = 0;

  CommunityRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<PostModel>>> getPosts({bool refresh = false}) async {
    try {
      if (!refresh && _cachedPosts.isNotEmpty) {
        return Right(_cachedPosts);
      }
      
      _currentPage = 0;
      final posts = await _localDataSource.getPosts(page: _currentPage);
      _cachedPosts = List.from(posts);
      return Right(_cachedPosts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> loadMorePosts() async {
    try {
      _currentPage++;
      final newPosts = await _localDataSource.getPosts(page: _currentPage);
      _cachedPosts.addAll(newPosts);
      return Right(_cachedPosts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostModel>> toggleLike(String postId) async {
    try {
      final index = _cachedPosts.indexWhere((p) => p.id == postId);
      if (index == -1) return const Left(CacheFailure('Post not found in cache'));
      
      final post = _cachedPosts[index];
      final updatedPost = post.copyWith(
        isLiked: !post.isLiked,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
      );
      
      _cachedPosts[index] = updatedPost;
      return Right(updatedPost);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostModel>> toggleSave(String postId) async {
    try {
      final index = _cachedPosts.indexWhere((p) => p.id == postId);
      if (index == -1) return const Left(CacheFailure('Post not found in cache'));
      
      final post = _cachedPosts[index];
      final updatedPost = post.copyWith(
        isSaved: !post.isSaved,
        saves: post.isSaved ? post.saves - 1 : post.saves + 1,
      );
      
      _cachedPosts[index] = updatedPost;
      return Right(updatedPost);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostModel>> toggleComment(String postId) async {
    try {
      final index = _cachedPosts.indexWhere((p) => p.id == postId);
      if (index == -1) return const Left(CacheFailure('Post not found in cache'));
      
      final post = _cachedPosts[index];
      final updatedPost = post.copyWith(comments: post.comments + 1);
      
      _cachedPosts[index] = updatedPost;
      return Right(updatedPost);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      _cachedPosts.removeWhere((p) => p.id == postId);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostModel>> createPost(PostModel post) async {
    try {
      _cachedPosts.insert(0, post);
      return Right(post);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
