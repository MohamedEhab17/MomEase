import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';
import 'package:new_mama/feature/articles/domain/usecases/article_usecases.dart';
import 'package:new_mama/feature/articles/domain/usecases/watch_article_save_status_usecase.dart';
import 'saved_articles_state.dart';

@injectable
class SavedArticlesCubit extends SafeCubit<SavedArticlesState> {
  final GetSavedArticlesUseCase _getSavedArticlesUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final UnsaveArticleUseCase _unsaveArticleUseCase;
  final WatchArticleSaveStatusUseCase _watchArticleSaveStatusUseCase;
  
  StreamSubscription? _saveStatusSubscription;

  SavedArticlesCubit(
    this._getSavedArticlesUseCase,
    this._saveArticleUseCase,
    this._unsaveArticleUseCase,
    this._watchArticleSaveStatusUseCase,
  ) : super(SavedArticlesInitial()) {
    _subscribeToSaveStatus();
  }

  void _subscribeToSaveStatus() {
    _saveStatusSubscription = _watchArticleSaveStatusUseCase().listen((event) {
      final articleId = event.$1;
      final isSaved = event.$2;
      
      final currentState = state;
      if (currentState is SavedArticlesSuccess) {
        if (!isSaved) {
          // Remove if unsaved from elsewhere
          final updatedArticles = List<Article>.from(currentState.articles);
          final index = updatedArticles.indexWhere((a) => a.articleId == articleId);
          if (index != -1) {
            updatedArticles.removeAt(index);
            safeEmit(SavedArticlesSuccess(updatedArticles));
          }
        } else {
           // If saved from elsewhere, we might want to refresh or add it.
           // For simplicity and to avoid inconsistency with sorting, we can just reload or do nothing.
           // Usually, if a user saves from outside, we reload to get the correct order.
           loadSavedArticles();
        }
      }
    });
  }

  Future<void> loadSavedArticles() async {
    safeEmit(SavedArticlesLoading());

    final operation = cancelableOperation(_getSavedArticlesUseCase());
    final result = await operation.value;

    result.fold(
      (failure) => safeEmit(SavedArticlesFailure(failure.message)),
      (articles) => safeEmit(SavedArticlesSuccess(articles)),
    );
  }

  Future<void> toggleSave(int articleId) async {
    final currentState = state;
    if (currentState is SavedArticlesSuccess) {
      final articleIndex = currentState.articles.indexWhere((a) => a.articleId == articleId);
      if (articleIndex == -1) return;

      final article = currentState.articles[articleIndex];
      final wasSaved = article.isSaved;

      if (wasSaved) {
        // Optimistic UI: 1. Change icon first
        final intermediateArticles = List<Article>.from(currentState.articles);
        intermediateArticles[articleIndex] = article.copyWith(isSaved: false);
        safeEmit(SavedArticlesSuccess(intermediateArticles));

        // 2. Call API
        final result = await _unsaveArticleUseCase(articleId);

        result.fold(
          (failure) {
            // Revert to original state if API fails
            safeEmit(SavedArticlesSuccess(currentState.articles));
          },
          (_) async {
            // 3. Small delay to let user see the "unsaved" state before it disappears
            await Future.delayed(const Duration(milliseconds: 300));
            
            // 4. Final removal from screen
            final finalArticles = List<Article>.from(currentState.articles);
            finalArticles.removeWhere((a) => a.articleId == articleId);
            safeEmit(SavedArticlesSuccess(finalArticles));
          },
        );
      } else {
        final result = await _saveArticleUseCase(articleId);
        result.fold(
          (failure) => null,
          (_) => loadSavedArticles(), 
        );
      }
    }
  }

  @override
  Future<void> close() {
    _saveStatusSubscription?.cancel();
    return super.close();
  }
}
