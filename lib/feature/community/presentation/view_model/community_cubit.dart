import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import '../../../../core/base/safe_cubit.dart';
import '../../../../core/error/failure.dart';
import '../../domain/usecase/community_usecases.dart';
import 'community_state.dart';

@injectable
class CommunityCubit extends SafeCubit<CommunityState> {
  final GetPostsUseCase _getPostsUseCase;
  final GetMyPostsUseCase _getMyPostsUseCase;
  final CreatePostUseCase _createPostUseCase;
  final DeletePostUseCase _deletePostUseCase;
  final AddReactionUseCase _addReactionUseCase;
  final UpdateReactionUseCase _updateReactionUseCase;
  final RemoveReactionUseCase _removeReactionUseCase;
  final ToggleSavePostUseCase _toggleSavePostUseCase;
  final GetSavedPostsUseCase _getSavedPostsUseCase;
  final ReportPostUseCase _reportPostUseCase;

  /// For professional debouncing: tracks the last known server state.
  final Map<int, String?> _serverReactions = {};
  final Map<int, bool> _serverSaves = {};

  /// Active timers for debounced syncing.
  final Map<int, Timer> _reactionTimers = {};
  final Map<int, Timer> _saveTimers = {};

  CommunityCubit(
    this._getPostsUseCase,
    this._getMyPostsUseCase,
    this._createPostUseCase,
    this._deletePostUseCase,
    this._addReactionUseCase,
    this._updateReactionUseCase,
    this._removeReactionUseCase,
    this._toggleSavePostUseCase,
    this._getSavedPostsUseCase,
    this._reportPostUseCase,
  ) : super(const CommunityState());

  Future<void> loadPosts({bool refresh = false}) async {
    if (state.status == CommunityStatus.loading) return;

    if (refresh) {
      safeEmit(
        state.copyWith(
          status: CommunityStatus.loading,
          posts: [],
          pageNumber: 1,
          hasNextPage: true,
        ),
      );
    } else {
      safeEmit(state.copyWith(status: CommunityStatus.loading));
    }

    final result = await _getPostsUseCase(
      pageNumber: refresh ? 1 : state.pageNumber,
    );

    result.fold(
      (failure) => safeEmit(
        state.copyWith(
          status: CommunityStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (pagination) => safeEmit(
        state.copyWith(
          status: CommunityStatus.success,
          posts: pagination.posts,
          pageNumber: pagination.pageNumber,
          hasNextPage: pagination.hasNextPage,
          totalCount: pagination.totalCount,
        ),
      ),
    );
  }

  Future<void> loadMyPosts({bool refresh = false}) async {
    if (state.status == CommunityStatus.loading) return;

    if (refresh) {
      safeEmit(
        state.copyWith(
          status: CommunityStatus.loading,
          posts: [],
          pageNumber: 1,
          hasNextPage: true,
        ),
      );
    } else {
      safeEmit(state.copyWith(status: CommunityStatus.loading));
    }

    final result = await _getMyPostsUseCase(
      pageNumber: refresh ? 1 : state.pageNumber,
    );

    result.fold(
      (failure) => safeEmit(
        state.copyWith(
          status: CommunityStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (pagination) => safeEmit(
        state.copyWith(
          status: CommunityStatus.success,
          posts: pagination.posts,
          pageNumber: pagination.pageNumber,
          hasNextPage: pagination.hasNextPage,
          totalCount: pagination.totalCount,
        ),
      ),
    );
  }

  Future<void> loadSavedPosts() async {
    safeEmit(state.copyWith(status: CommunityStatus.loading));

    final result = await _getSavedPostsUseCase();

    result.fold(
      (failure) => safeEmit(
        state.copyWith(
          status: CommunityStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (posts) => safeEmit(
        state.copyWith(status: CommunityStatus.success, posts: posts),
      ),
    );
  }

  Future<void> loadMore({bool isMyPosts = false}) async {
    if (state.status == CommunityStatus.loadingMore || !state.hasNextPage)
      return;

    safeEmit(state.copyWith(status: CommunityStatus.loadingMore));

    final result = isMyPosts
        ? await _getMyPostsUseCase(pageNumber: state.pageNumber + 1)
        : await _getPostsUseCase(pageNumber: state.pageNumber + 1);

    result.fold(
      (failure) => safeEmit(
        state.copyWith(
          status: CommunityStatus.success, // Keep current posts
          errorMessage: failure.message,
        ),
      ),
      (pagination) {
        final updatedPosts = [...state.posts, ...pagination.posts];
        safeEmit(
          state.copyWith(
            status: CommunityStatus.success,
            posts: updatedPosts,
            pageNumber: pagination.pageNumber,
            hasNextPage: pagination.hasNextPage,
            totalCount: pagination.totalCount,
          ),
        );
      },
    );
  }

  Future<void> refresh({bool isMyPosts = false}) async {
    if (isMyPosts) {
      await loadMyPosts(refresh: true);
    } else {
      await loadPosts(refresh: true);
    }
  }

  Future<void> createPost({
    required String text,
    List<String>? mediaFiles,
  }) async {
    safeEmit(state.copyWith(status: CommunityStatus.loading));

    final result = await _createPostUseCase(text: text, mediaFiles: mediaFiles);

    result.fold(
      (failure) => safeEmit(
        state.copyWith(
          status: CommunityStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (newPost) {
        final updatedPosts = [newPost, ...state.posts];
        safeEmit(
          state.copyWith(status: CommunityStatus.success, posts: updatedPosts),
        );
      },
    );
  }

  void injectPost(PostModel post) {
    final index = state.posts.indexWhere((p) => p.postId == post.postId);
    if (index == -1) {
      safeEmit(state.copyWith(posts: [post, ...state.posts]));
    } else {
      final updated = List.of(state.posts);
      updated[index] = post;
      safeEmit(state.copyWith(posts: updated));
    }
  }

  Future<void> deletePost(int id) async {
    // Optimistic deletion
    final originalPosts = List.of(state.posts);
    final updatedPosts = state.posts.where((p) => p.postId != id).toList();
    safeEmit(state.copyWith(posts: updatedPosts));

    final result = await _deletePostUseCase(id);

    result.fold(
      (failure) {
        // Rollback on failure
        safeEmit(
          state.copyWith(posts: originalPosts, errorMessage: failure.message),
        );
      },
      (_) => null, // Already removed optimistically
    );
  }

  void toggleSave(int id, {bool removeOnUnsave = false}) {
    final postIndex = state.posts.indexWhere((p) => p.postId == id);
    if (postIndex == -1) return;

    final post = state.posts[postIndex];
    final bool currentSaveStatus = post.isSaved;

    // 1. Save original server state
    if (!_serverSaves.containsKey(id)) {
      _serverSaves[id] = currentSaveStatus;
    }

    // 2. Optimistic update
    final newSaveStatus = !currentSaveStatus;
    final updatedPosts = List.of(state.posts);
    if (removeOnUnsave && !newSaveStatus) {
      updatedPosts.removeAt(postIndex);
    } else {
      updatedPosts[postIndex] = post.copyWith(isSaved: newSaveStatus);
    }
    safeEmit(state.copyWith(posts: updatedPosts));

    // 3. Debounce Timer
    _saveTimers[id]?.cancel();
    _saveTimers[id] = Timer(const Duration(milliseconds: 800), () {
      _executeSaveSync(id, removeOnUnsave, post);
    });
  }

  Future<void> _executeSaveSync(
    int postId,
    bool removeOnUnsave,
    PostModel cachedPost,
  ) async {
    final initialServerState = _serverSaves[postId];
    if (initialServerState == null) return;

    // Clean up maps
    _serverSaves.remove(postId);
    _saveTimers.remove(postId);

    // Find the current final state from the UI
    final postIndex = state.posts.indexWhere((p) => p.postId == postId);
    final finalSaveState = postIndex != -1
        ? state.posts[postIndex].isSaved
        : false;

    // If no net change
    if (initialServerState == finalSaveState) {
      return;
    }

    // Execute API call
    final result = await _toggleSavePostUseCase(
      id: postId,
      save: finalSaveState,
    );

    result.fold((failure) {
      // Rollback gracefully
      if (!removeOnUnsave && postIndex != -1) {
        final restoredPosts = List.of(state.posts);
        restoredPosts[postIndex] = state.posts[postIndex].copyWith(
          isSaved: initialServerState,
        );
        safeEmit(state.copyWith(posts: restoredPosts));
      } else if (removeOnUnsave && initialServerState) {
        // Restore the removed post
        final restoredPosts = List.of(state.posts)
          ..insert(0, cachedPost.copyWith(isSaved: true));
        safeEmit(
          state.copyWith(posts: restoredPosts, errorMessage: failure.message),
        );
      }
    }, (_) => null);
  }

  Future<void> reportPost({required int postId, required String reason}) async {
    safeEmit(state.copyWith(status: CommunityStatus.loading));

    final result = await _reportPostUseCase(postId: postId, reason: reason);

    result.fold(
      (failure) => safeEmit(
        state.copyWith(
          status: CommunityStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => safeEmit(state.copyWith(status: CommunityStatus.success)),
    );
  }

  /// Smart reaction toggle with true professional debouncing:
  /// - Instantly updates the UI optimistically.
  /// - Caches the original server state on the first tap.
  /// - Waits 800ms after the LAST tap before sending the API request.
  /// - Only sends an API request if the final state differs from the server state.
  void toggleReaction({required int postId, required String reactionType}) {
    final postIndex = state.posts.indexWhere((p) => p.postId == postId);
    if (postIndex == -1) return;

    final post = state.posts[postIndex];
    final String? currentReaction = post.myReaction;

    // 1. Save the original server state if this is the first tap in a sequence
    if (!_serverReactions.containsKey(postId)) {
      _serverReactions[postId] = currentReaction;
    }

    // 2. Optimistic UI update ────────────────────────────────────────────
    final updatedPosts = List.of(state.posts);
    String? newMyReaction;
    int newCount = post.reactionsCount;

    if (currentReaction == null) {
      newMyReaction = reactionType;
      newCount++;
    } else if (currentReaction == reactionType) {
      newMyReaction = null;
      newCount = (newCount - 1).clamp(0, 999999);
    } else {
      newMyReaction = reactionType; // count stays same
    }

    updatedPosts[postIndex] = post.copyWith(
      myReaction: newMyReaction,
      clearReaction: newMyReaction == null,
      reactionsCount: newCount,
    );
    safeEmit(state.copyWith(posts: updatedPosts));

    // 3. Debounce Timer ──────────────────────────────────────────────────
    _reactionTimers[postId]?.cancel();
    _reactionTimers[postId] = Timer(const Duration(milliseconds: 800), () {
      _executeReactionSync(postId);
    });
  }

  /// Forces an immediate sync of any pending reaction for a post.
  /// Useful when navigating to a screen that requires up-to-date backend data.
  Future<void> syncPendingReactionNow(int postId) async {
    final timer = _reactionTimers[postId];
    if (timer != null && timer.isActive) {
      timer.cancel();
      await _executeReactionSync(postId);
    }
  }

  Future<void> _executeReactionSync(int postId) async {
    final initialServerState = _serverReactions[postId];

    // Find the current final state from the UI
    final postIndex = state.posts.indexWhere((p) => p.postId == postId);
    if (postIndex == -1) return;
    final finalReactionState = state.posts[postIndex].myReaction;

    // Clean up maps
    _serverReactions.remove(postId);
    _reactionTimers.remove(postId);

    // If the user spammed the button but ended up at the exact same state the server had, DO NOTHING!
    if (initialServerState == finalReactionState) {
      return;
    }

    // 4. Execute the appropriate API call based on the DIFFERENCE
    late final Either<Failure, void> result;

    if (initialServerState == null && finalReactionState != null) {
      // Adding a completely new reaction
      result = await _addReactionUseCase(
        postId: postId,
        reactionType: finalReactionState,
      );
    } else if (initialServerState != null && finalReactionState == null) {
      // Removing an existing reaction
      result = await _removeReactionUseCase(postId: postId);
    } else {
      // initial != null && final != null && initial != final
      // Updating an existing reaction to a different type
      result = await _updateReactionUseCase(
        postId: postId,
        reactionType: finalReactionState!,
      );
    }

    // 5. Handle potential failure gracefully
    result.fold(
      (failure) {
        // Rollback the specific post to its initial server state gracefully without disrupting the user
        final rollbackPostIndex = state.posts.indexWhere(
          (p) => p.postId == postId,
        );
        if (rollbackPostIndex != -1) {
          final rp = state.posts[rollbackPostIndex];
          int rollbackCount = rp.reactionsCount;
          if (initialServerState == null && finalReactionState != null) {
            rollbackCount = (rollbackCount - 1).clamp(0, 999999);
          } else if (initialServerState != null && finalReactionState == null) {
            rollbackCount++;
          }

          final restoredPosts = List.of(state.posts);
          restoredPosts[rollbackPostIndex] = rp.copyWith(
            myReaction: initialServerState,
            clearReaction: initialServerState == null,
            reactionsCount: rollbackCount,
          );
          safeEmit(state.copyWith(posts: restoredPosts));
        }
      },
      (_) => null, // Success!
    );
  }

  /// Called by CommentsModalSheet after successfully adding a comment.
  void incrementCommentCount(int postId) {
    final index = state.posts.indexWhere((p) => p.postId == postId);
    if (index == -1) return;
    final updated = List.of(state.posts);
    updated[index] = state.posts[index].copyWith(
      commentsCount: state.posts[index].commentsCount + 1,
    );
    safeEmit(state.copyWith(posts: updated));
  }

  /// Called by CommentsModalSheet after successfully deleting a comment.
  void decrementCommentCount(int postId) {
    final index = state.posts.indexWhere((p) => p.postId == postId);
    if (index == -1) return;
    final updated = List.of(state.posts);
    updated[index] = state.posts[index].copyWith(
      commentsCount: (state.posts[index].commentsCount - 1).clamp(0, 999999),
    );
    safeEmit(state.copyWith(posts: updated));
  }
}
