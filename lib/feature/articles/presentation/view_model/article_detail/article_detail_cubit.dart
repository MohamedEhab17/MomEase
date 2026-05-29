import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/articles/domain/usecases/article_usecases.dart';
import 'package:new_mama/feature/articles/domain/usecases/watch_article_save_status_usecase.dart';
import 'article_detail_state.dart';

@injectable
class ArticleDetailCubit extends SafeCubit<ArticleDetailState> {
  final GetArticleByIdUseCase _getArticleByIdUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final UnsaveArticleUseCase _unsaveArticleUseCase;
  final WatchArticleSaveStatusUseCase _watchArticleSaveStatusUseCase;
  
  StreamSubscription? _saveStatusSubscription;

  ArticleDetailCubit(
    this._getArticleByIdUseCase,
    this._saveArticleUseCase,
    this._unsaveArticleUseCase,
    this._watchArticleSaveStatusUseCase,
  ) : super(ArticleDetailInitial()) {
    _subscribeToSaveStatus();
  }

  void _subscribeToSaveStatus() {
    _saveStatusSubscription = _watchArticleSaveStatusUseCase().listen((event) {
      final articleId = event.$1;
      final isSaved = event.$2;
      
      final currentState = state;
      if (currentState is ArticleDetailSuccess) {
        if (currentState.article.articleId == articleId) {
          if (currentState.article.isSaved != isSaved) {
            safeEmit(ArticleDetailSuccess(currentState.article.copyWith(isSaved: isSaved)));
          }
        }
      }
    });
  }

  Future<void> loadArticle(int id) async {
    safeEmit(ArticleDetailLoading());

    final operation = cancelableOperation(_getArticleByIdUseCase(id));
    final result = await operation.value;

    result.fold(
      (failure) => safeEmit(ArticleDetailFailure(failure.message)),
      (article) => safeEmit(ArticleDetailSuccess(article)),
    );
  }

  Future<void> toggleSave() async {
    final currentState = state;
    if (currentState is ArticleDetailSuccess) {
      final article = currentState.article;
      final wasSaved = article.isSaved;
      
      // Optimistic update
      safeEmit(ArticleDetailSuccess(article.copyWith(isSaved: !wasSaved)));

      final result = wasSaved 
          ? await _unsaveArticleUseCase(article.articleId)
          : await _saveArticleUseCase(article.articleId);
      
      result.fold(
        (failure) {
          // Revert on failure
          safeEmit(ArticleDetailSuccess(article));
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
