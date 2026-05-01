import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/articles/domain/usecase/search_articles_usecase.dart';
import 'package:new_mama/feature/articles/domain/usecase/search_history_usecases.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';
import 'package:new_mama/feature/articles/domain/usecases/article_usecases.dart';
import 'package:new_mama/feature/articles/domain/usecases/watch_article_save_status_usecase.dart';
import 'search_articles_state.dart';

@injectable
class SearchArticlesCubit extends Cubit<SearchArticlesState> {
  final SearchArticlesUseCase _searchArticlesUseCase;
  final GetSearchHistoryUseCase _getSearchHistoryUseCase;
  final SaveSearchQueryUseCase _saveSearchQueryUseCase;
  final ClearSearchHistoryUseCase _clearSearchHistoryUseCase;
  final RemoveSearchTermUseCase _removeSearchTermUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final UnsaveArticleUseCase _unsaveArticleUseCase;
  final WatchArticleSaveStatusUseCase _watchArticleSaveStatusUseCase;
  
  StreamSubscription? _saveStatusSubscription;

  SearchArticlesCubit(
    this._searchArticlesUseCase,
    this._getSearchHistoryUseCase,
    this._saveSearchQueryUseCase,
    this._clearSearchHistoryUseCase,
    this._removeSearchTermUseCase,
    this._saveArticleUseCase,
    this._unsaveArticleUseCase,
    this._watchArticleSaveStatusUseCase,
  ) : super(SearchArticlesInitial()) {
    _subscribeToSaveStatus();
  }

  void _subscribeToSaveStatus() {
    _saveStatusSubscription = _watchArticleSaveStatusUseCase().listen((event) {
      final articleId = event.$1;
      final isSaved = event.$2;
      
      final currentState = state;
      if (currentState is SearchArticlesSuccess) {
        final articleIndex = currentState.result.articles.indexWhere((a) => a.articleId == articleId);
        if (articleIndex != -1) {
          final article = currentState.result.articles[articleIndex];
          if (article.isSaved != isSaved) {
            final updatedArticles = List<Article>.from(currentState.result.articles);
            updatedArticles[articleIndex] = article.copyWith(isSaved: isSaved);
            emit(SearchArticlesSuccess(currentState.result.copyWith(articles: updatedArticles)));
          }
        }
      }
    });
  }

  Future<void> loadSearchHistory() async {
    final result = await _getSearchHistoryUseCase.call();
    result.fold(
      (failure) => emit(SearchArticlesHistory(const [])),
      (history) => emit(SearchArticlesHistory(history)),
    );
  }

  Future<void> searchArticles(String query) async {
    if (query.isEmpty) {
      await loadSearchHistory();
      return;
    }

    emit(SearchArticlesLoading());

    final result = await _searchArticlesUseCase.call(query);

    result.fold(
      (failure) => emit(SearchArticlesFailure(failure.message)),
      (searchResult) async {
        if (searchResult.articles.isNotEmpty || searchResult.categories.isNotEmpty) {
           await _saveSearchQueryUseCase.call(query);
        }
        emit(SearchArticlesSuccess(searchResult));
      },
    );
  }

  Future<void> toggleSave(int articleId) async {
    final currentState = state;
    if (currentState is SearchArticlesSuccess) {
      final articleIndex = currentState.result.articles.indexWhere((a) => a.articleId == articleId);
      if (articleIndex == -1) return;

      final article = currentState.result.articles[articleIndex];
      final wasSaved = article.isSaved;

      // Optimistic update
      final updatedArticles = List<Article>.from(currentState.result.articles);
      updatedArticles[articleIndex] = article.copyWith(isSaved: !wasSaved);
      
      final updatedResult = currentState.result.copyWith(articles: updatedArticles);
      emit(SearchArticlesSuccess(updatedResult));

      final result = wasSaved 
          ? await _unsaveArticleUseCase(articleId) 
          : await _saveArticleUseCase(articleId);
      
      result.fold(
        (failure) {
          // Revert
          final revertedArticles = List<Article>.from(currentState.result.articles);
          revertedArticles[articleIndex] = article;
          emit(SearchArticlesSuccess(currentState.result.copyWith(articles: revertedArticles)));
        },
        (_) => null,
      );
    }
  }

  Future<void> clearHistory() async {
    await _clearSearchHistoryUseCase.call();
    emit(const SearchArticlesHistory([]));
  }

  Future<void> removeFromHistory(String term) async {
    await _removeSearchTermUseCase.call(term);
    final currentState = state;
    if (currentState is SearchArticlesHistory) {
      final updatedHistory = List<String>.from(currentState.history);
      updatedHistory.remove(term);
      emit(SearchArticlesHistory(updatedHistory));
    }
  }

  @override
  Future<void> close() {
    _saveStatusSubscription?.cancel();
    return super.close();
  }
}
