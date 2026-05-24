import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';
import 'package:new_mama/feature/articles/domain/usecases/article_usecases.dart';
import 'package:new_mama/feature/articles/domain/usecases/watch_article_save_status_usecase.dart';
import 'category_articles_state.dart';

@injectable
class CategoryArticlesCubit extends SafeCubit<CategoryArticlesState> {
  final GetArticlesByCategoryUseCase _getArticlesByCategoryUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final UnsaveArticleUseCase _unsaveArticleUseCase;
  final WatchArticleSaveStatusUseCase _watchArticleSaveStatusUseCase;
  
  StreamSubscription? _saveStatusSubscription;

  CategoryArticlesCubit(
    this._getArticlesByCategoryUseCase,
    this._saveArticleUseCase,
    this._unsaveArticleUseCase,
    this._watchArticleSaveStatusUseCase,
  ) : super(CategoryArticlesInitial()) {
    _subscribeToSaveStatus();
  }

  void _subscribeToSaveStatus() {
    _saveStatusSubscription = _watchArticleSaveStatusUseCase().listen((event) {
      final articleId = event.$1;
      final isSaved = event.$2;
      
      final currentState = state;
      if (currentState is CategoryArticlesSuccess) {
        final articleIndex = currentState.articles.indexWhere((a) => a.articleId == articleId);
        if (articleIndex != -1) {
          final article = currentState.articles[articleIndex];
          if (article.isSaved != isSaved) {
            final updatedArticles = List<Article>.from(currentState.articles);
            updatedArticles[articleIndex] = article.copyWith(isSaved: isSaved);
            safeEmit(CategoryArticlesSuccess(updatedArticles));
          }
        }
      }
    });
  }

  Future<void> loadArticles(int categoryId) async {
    safeEmit(CategoryArticlesLoading());

    final operation = cancelableOperation(_getArticlesByCategoryUseCase(categoryId));
    final result = await operation.value;

    result.fold(
      (failure) => safeEmit(CategoryArticlesFailure(failure.message)),
      (articles) => safeEmit(CategoryArticlesSuccess(articles)),
    );
  }

  Future<void> toggleSave(int articleId) async {
    final currentState = state;
    if (currentState is CategoryArticlesSuccess) {
      final articleIndex = currentState.articles.indexWhere((a) => a.articleId == articleId);
      if (articleIndex == -1) return;

      final article = currentState.articles[articleIndex];
      final wasSaved = article.isSaved;

      // Optimistic update
      final updatedArticles = List<Article>.from(currentState.articles);
      updatedArticles[articleIndex] = article.copyWith(isSaved: !wasSaved);
      
      safeEmit(CategoryArticlesSuccess(updatedArticles));

      final result = wasSaved 
          ? await _unsaveArticleUseCase(articleId) 
          : await _saveArticleUseCase(articleId);
      
      result.fold(
        (failure) {
          // Revert on failure
          final revertedArticles = List<Article>.from(currentState.articles);
          revertedArticles[articleIndex] = article; // article still has old isSaved
          safeEmit(CategoryArticlesSuccess(revertedArticles));
        },
        (_) => null,
      );
    }
  }

  @override
  Future<void> close() {
    _saveStatusSubscription?.cancel();
    return super.close();
  }
}
