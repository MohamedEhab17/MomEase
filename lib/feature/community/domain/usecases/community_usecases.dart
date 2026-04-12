import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import '../../data/models/post_model.dart';
import '../../data/repository/community_repository.dart';

@injectable
class GetPostsUseCase {
  final CommunityRepository repository;

  GetPostsUseCase(this.repository);

  Future<Either<Failure, List<PostModel>>> call({bool refresh = false}) {
    return repository.getPosts(refresh: refresh);
  }
}

@injectable
class LoadMorePostsUseCase {
  final CommunityRepository repository;

  LoadMorePostsUseCase(this.repository);

  Future<Either<Failure, List<PostModel>>> call() {
    return repository.loadMorePosts();
  }
}

@injectable
class ToggleLikeUseCase {
  final CommunityRepository repository;

  ToggleLikeUseCase(this.repository);

  Future<Either<Failure, PostModel>> call(String postId) {
    return repository.toggleLike(postId);
  }
}

@injectable
class ToggleSaveUseCase {
  final CommunityRepository repository;

  ToggleSaveUseCase(this.repository);

  Future<Either<Failure, PostModel>> call(String postId) {
    return repository.toggleSave(postId);
  }
}

@injectable
class ToggleCommentUseCase {
  final CommunityRepository repository;

  ToggleCommentUseCase(this.repository);

  Future<Either<Failure, PostModel>> call(String postId) {
    return repository.toggleComment(postId);
  }
}

@injectable
class DeletePostUseCase {
  final CommunityRepository repository;

  DeletePostUseCase(this.repository);

  Future<Either<Failure, void>> call(String postId) {
    return repository.deletePost(postId);
  }
}

@injectable
class CreatePostUseCase {
  final CommunityRepository repository;

  CreatePostUseCase(this.repository);

  Future<Either<Failure, PostModel>> call(PostModel post) {
    return repository.createPost(post);
  }
}
