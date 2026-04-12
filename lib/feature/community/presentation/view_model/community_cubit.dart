import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import '../../data/models/post_model.dart';
import '../../domain/usecases/community_usecases.dart';
import 'community_state.dart';

@injectable
class CommunityCubit extends SafeCubit<CommunityState> {
  final GetPostsUseCase _getPostsUseCase;
  final LoadMorePostsUseCase _loadMorePostsUseCase;
  final ToggleLikeUseCase _toggleLikeUseCase;
  final ToggleSaveUseCase _toggleSaveUseCase;
  final ToggleCommentUseCase _toggleCommentUseCase;
  final DeletePostUseCase _deletePostUseCase;
  final CreatePostUseCase _createPostUseCase;

  CommunityCubit(
    this._getPostsUseCase,
    this._loadMorePostsUseCase,
    this._toggleLikeUseCase,
    this._toggleSaveUseCase,
    this._toggleCommentUseCase,
    this._deletePostUseCase,
    this._createPostUseCase,
  ) : super(const CommunityState());

  void createPost(PostModel newPost) async {
    final operation = cancelableOperation(_createPostUseCase(newPost));
    final result = await operation.value;
    result.fold(
      (failure) => safeEmit(state.copyWith(errorMessage: failure.message)), // Needs errorMessage field in state
      (post) {
        final updatedPosts = [post, ...state.posts];
        safeEmit(state.copyWith(posts: updatedPosts, errorMessage: null));
      },
    );
  }

  Future<void> loadPosts({bool refresh = false}) async {
    if (!refresh && state.posts.isNotEmpty) return;
    safeEmit(state.copyWith(isLoading: true, errorMessage: null));

    final operation = cancelableOperation(_getPostsUseCase(refresh: refresh));
    final result = await operation.value;

    result.fold(
      (failure) => safeEmit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (posts) => safeEmit(state.copyWith(posts: posts, isLoading: false, errorMessage: null)),
    );
  }

  Future<void> refresh() async {
    await loadPosts(refresh: true);
  }

  /// Pagination
  Future<void> loadMore() async {
    if (state.isLoadingMore) return;
    safeEmit(state.copyWith(isLoadingMore: true, errorMessage: null));

    final operation = cancelableOperation(_loadMorePostsUseCase());
    final result = await operation.value;

    result.fold(
      (failure) => safeEmit(state.copyWith(isLoadingMore: false, errorMessage: failure.message)),
      (posts) => safeEmit(state.copyWith(posts: posts, isLoadingMore: false, errorMessage: null)),
    );
  }

  void toggleLike(String id) {
    debounce(const Duration(milliseconds: 300), () async {
      final operation = cancelableOperation(_toggleLikeUseCase(id));
      final result = await operation.value;
      result.fold(
        (failure) => safeEmit(state.copyWith(errorMessage: failure.message)),
        (updatedPost) {
          final updatedPosts = state.posts.map((p) => p.id == id ? updatedPost : p).toList();
          safeEmit(state.copyWith(posts: updatedPosts, errorMessage: null));
        },
      );
    });
  }

  void toggleSave(String id) {
    debounce(const Duration(milliseconds: 300), () async {
      final operation = cancelableOperation(_toggleSaveUseCase(id));
      final result = await operation.value;
      result.fold(
        (failure) => safeEmit(state.copyWith(errorMessage: failure.message)),
        (updatedPost) {
          final updatedPosts = state.posts.map((p) => p.id == id ? updatedPost : p).toList();
          safeEmit(state.copyWith(posts: updatedPosts, errorMessage: null));
        },
      );
    });
  }

  void toggleComment(String id) async {
    final operation = cancelableOperation(_toggleCommentUseCase(id));
    final result = await operation.value;
    result.fold(
      (failure) => safeEmit(state.copyWith(errorMessage: failure.message)),
      (updatedPost) {
        final updatedPosts = state.posts.map((p) => p.id == id ? updatedPost : p).toList();
        safeEmit(state.copyWith(posts: updatedPosts, errorMessage: null));
      },
    );
  }

  void deletePost(String id) async {
    final operation = cancelableOperation(_deletePostUseCase(id));
    final result = await operation.value;
    result.fold(
      (failure) => safeEmit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final updatedPosts = state.posts.where((p) => p.id != id).toList();
        safeEmit(state.copyWith(posts: updatedPosts, errorMessage: null));
      },
    );
  }
}
