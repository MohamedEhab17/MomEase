import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/dummy/dummy_post.dart';
import 'community_state.dart';

class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit() : super(const CommunityState());

  int _page = 0;

  void createPost(PostModel newPost) {
    log("Before: ${state.posts.length}");
    emit(state.copyWith(posts: [newPost, ...state.posts]));
    log("After: ${state.posts.length}");
  }

  Future<void> loadPosts() async {
    if (state.posts.isNotEmpty) return;
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(milliseconds: 500));

    emit(state.copyWith(posts: dummyPosts.take(10).toList(), isLoading: false));
  }

  Future<void> refresh() async {
    _page = 0;
    await loadPosts();
  }

  /// Pagination
  Future<void> loadMore() async {
    if (state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    await Future.delayed(const Duration(milliseconds: 500));

    _page++;

    final newPosts = dummyPosts.skip(_page * 10).take(10).toList();

    emit(
      state.copyWith(
        posts: [...state.posts, ...newPosts],
        isLoadingMore: false,
      ),
    );
  }

  void toggleLike(String id) {
    final updated = state.posts.map((p) {
      if (p.id == id) {
        return p.copyWith(
          isLiked: !p.isLiked,
          likes: p.isLiked ? p.likes - 1 : p.likes + 1,
        );
      }
      return p;
    }).toList();

    emit(state.copyWith(posts: updated));
  }

  void toggleSave(String id) {
    final updated = state.posts.map((p) {
      if (p.id == id) {
        return p.copyWith(
          isSaved: !p.isSaved,
          saves: p.isSaved ? p.saves - 1 : p.saves + 1,
        );
      }
      return p;
    }).toList();

    emit(state.copyWith(posts: updated));
  }

  void toggleComment(String id) {
    final updated = state.posts.map((p) {
      if (p.id == id) {
        return p.copyWith(comments: p.comments + 1);
      }
      return p;
    }).toList();

    emit(state.copyWith(posts: updated));
  }
}
