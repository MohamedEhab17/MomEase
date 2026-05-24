import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/community/data/models/comment_model.dart';
import 'package:new_mama/feature/community/data/models/reply_model.dart';
import 'package:new_mama/feature/community/domain/usecase/community_usecases.dart';
import 'comments_state.dart';

@injectable
class CommentsCubit extends SafeCubit<CommentsState> {
  final GetCommentsUseCase _getCommentsUseCase;
  final AddCommentUseCase _addCommentUseCase;
  final UpdateCommentUseCase _updateCommentUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;
  final GetRepliesUseCase _getRepliesUseCase;
  final AddReplyUseCase _addReplyUseCase;
  final UpdateReplyUseCase _updateReplyUseCase;
  final DeleteReplyUseCase _deleteReplyUseCase;
  final AddCommentReactionUseCase _addReactionUseCase;
  final UpdateCommentReactionUseCase _updateReactionUseCase;
  final RemoveCommentReactionUseCase _removeReactionUseCase;

  final Map<int, Timer> _reactionDebouncers = {};

  CommentsCubit(
    this._getCommentsUseCase,
    this._addCommentUseCase,
    this._updateCommentUseCase,
    this._deleteCommentUseCase,
    this._getRepliesUseCase,
    this._addReplyUseCase,
    this._updateReplyUseCase,
    this._deleteReplyUseCase,
    this._addReactionUseCase,
    this._updateReactionUseCase,
    this._removeReactionUseCase,
  ) : super(const CommentsState());

  @override
  Future<void> close() {
    for (var timer in _reactionDebouncers.values) {
      timer.cancel();
    }
    return super.close();
  }

  // ─── Load all comments for a post ───────────────────────────────────────

  Future<void> loadComments(int postId) async {
    safeEmit(state.copyWith(status: CommentsStatus.loading));

    final result = await _getCommentsUseCase(postId: postId);

    result.fold(
      (failure) => safeEmit(
        state.copyWith(
          status: CommentsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (comments) => safeEmit(
        state.copyWith(status: CommentsStatus.success, comments: comments),
      ),
    );
  }

  // ─── Add a comment (returns true on success) ────────────────────────────

  Future<bool> addComment(int postId, String text) async {
    safeEmit(state.copyWith(isSubmitting: true));

    final result = await _addCommentUseCase(postId: postId, text: text.trim());

    return result.fold(
      (failure) {
        safeEmit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        );
        return false;
      },
      (comment) {
        // Prepend — newest first, same as comment.dart header ordering
        safeEmit(
          state.copyWith(
            isSubmitting: false,
            comments: [comment, ...state.comments],
          ),
        );
        return true;
      },
    );
  }

  // ─── Update a comment (returns true on success) ──────────────────────────

  Future<bool> updateComment(int postId, int commentId, String text) async {
    safeEmit(state.copyWith(isSubmitting: true));

    final result = await _updateCommentUseCase(
      postId: postId,
      commentId: commentId,
      text: text.trim(),
    );

    return result.fold(
      (failure) {
        safeEmit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        );
        return false;
      },
      (updatedComment) {
        safeEmit(state.copyWith(isSubmitting: false));
        _updateComment(
          commentId,
          (c) => updatedComment.copyWith(
            loadedReplies: c.loadedReplies,
            isLoadingReplies: c.isLoadingReplies,
            myReaction: c.myReaction,
            reactionsCount: c.reactionsCount,
          ),
        );
        return true;
      },
    );
  }

  // ─── Delete a comment (optimistic with rollback) ─────────────────────────

  Future<void> deleteComment(int postId, int commentId) async {
    final originalComments = List<CommentModel>.of(state.comments);
    final updated = state.comments
        .where((c) => c.commentId != commentId)
        .toList();
    safeEmit(state.copyWith(comments: updated));

    final result = await _deleteCommentUseCase(
      postId: postId,
      commentId: commentId,
    );

    result.fold((failure) {
      // Rollback
      safeEmit(
        state.copyWith(
          comments: originalComments,
          errorMessage: failure.message,
        ),
      );
    }, (_) => null);
  }

  // ─── Load replies for a comment ──────────────────────────────────────────

  Future<void> loadReplies(int postId, int commentId) async {
    _updateComment(commentId, (c) => c.copyWith(isLoadingReplies: true));

    final result = await _getRepliesUseCase(
      postId: postId,
      commentId: commentId,
    );

    result.fold(
      (failure) {
        _updateComment(commentId, (c) => c.copyWith(isLoadingReplies: false));
      },
      (replies) {
        _updateComment(
          commentId,
          (c) => c.copyWith(loadedReplies: replies, isLoadingReplies: false),
        );
      },
    );
  }

  // ─── Add a reply to a comment ────────────────────────────────────────────

  Future<void> addReply(int postId, int commentId, String text) async {
    final result = await _addReplyUseCase(
      postId: postId,
      commentId: commentId,
      text: text.trim(),
    );

    result.fold(
      (failure) => safeEmit(state.copyWith(errorMessage: failure.message)),
      (reply) {
        _updateComment(commentId, (c) {
          final currentReplies = c.loadedReplies ?? [];
          return c.copyWith(
            loadedReplies: [...currentReplies, reply],
            repliesCount: c.repliesCount + 1,
          );
        });
      },
    );
  }

  // ─── Update a reply ──────────────────────────────────────────────────────

  Future<void> updateReply(
    int postId,
    int commentId,
    int replyId,
    String text,
  ) async {
    final result = await _updateReplyUseCase(
      postId: postId,
      commentId: commentId,
      replyId: replyId,
      text: text.trim(),
    );

    result.fold(
      (failure) => safeEmit(state.copyWith(errorMessage: failure.message)),
      (updatedReply) {
        _updateComment(commentId, (c) {
          final currentReplies = List<ReplyModel>.of(c.loadedReplies ?? []);
          final index = currentReplies.indexWhere((r) => r.replyId == replyId);
          if (index != -1) {
            currentReplies[index] = updatedReply;
          }
          return c.copyWith(loadedReplies: currentReplies);
        });
      },
    );
  }

  // ─── Delete a reply (optimistic with rollback) ───────────────────────────

  Future<void> deleteReply(int postId, int commentId, int replyId) async {
    final commentIndex = state.comments.indexWhere(
      (c) => c.commentId == commentId,
    );
    if (commentIndex == -1) return;

    final originalComment = state.comments[commentIndex];

    // Optimistic removal
    _updateComment(commentId, (c) {
      final updatedReplies = (c.loadedReplies ?? [])
          .where((r) => r.replyId != replyId)
          .toList();
      return c.copyWith(
        loadedReplies: updatedReplies,
        repliesCount: (c.repliesCount - 1).clamp(0, 999999),
      );
    });

    final result = await _deleteReplyUseCase(
      postId: postId,
      commentId: commentId,
      replyId: replyId,
    );

    result.fold((failure) {
      // Rollback the comment to its original state
      _updateComment(commentId, (_) => originalComment);
      safeEmit(state.copyWith(errorMessage: failure.message));
    }, (_) => null);
  }

  // ─── Reactions (Optimistic + Debounced) ──────────────────────────────────

  void toggleReaction(
    int postId,
    int commentId,
    String? currentReactionType,
    String newReactionType,
  ) {
    if (_reactionDebouncers.containsKey(commentId)) {
      _reactionDebouncers[commentId]?.cancel();
    }

    final isRemoving = currentReactionType == newReactionType;
    final isUpdating = currentReactionType != null && !isRemoving;
    final isAdding = currentReactionType == null;

    // Optimistic Update
    _updateComment(commentId, (c) {
      int newCount = c.reactionsCount;
      if (isAdding) {
        newCount++;
      } else if (isRemoving) {
        newCount = (newCount - 1).clamp(0, 999999);
      }
      return c.copyWith(
        myReaction: isRemoving ? null : newReactionType,
        clearMyReaction: isRemoving,
        reactionsCount: newCount,
      );
    });

    // Debounce API Call
    _reactionDebouncers[commentId] = Timer(
      const Duration(milliseconds: 500),
      () async {
        _reactionDebouncers.remove(commentId);

        if (isRemoving) {
          await _removeReactionUseCase(postId: postId, commentId: commentId);
        } else if (isUpdating) {
          await _updateReactionUseCase(
            postId: postId,
            commentId: commentId,
            reactionType: newReactionType,
          );
        } else if (isAdding) {
          await _addReactionUseCase(
            postId: postId,
            commentId: commentId,
            reactionType: newReactionType,
          );
        }
      },
    );
  }

  // ─── Internal helper ─────────────────────────────────────────────────────

  void _updateComment(
    int commentId,
    CommentModel Function(CommentModel) updater,
  ) {
    final index = state.comments.indexWhere((c) => c.commentId == commentId);
    if (index == -1) return;
    final updated = List<CommentModel>.of(state.comments);
    updated[index] = updater(updated[index]);
    safeEmit(state.copyWith(comments: updated));
  }
}
