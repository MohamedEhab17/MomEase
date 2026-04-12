import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view_model/article_state.dart';
import '../../domain/usecases/article_usecases.dart';

@injectable
class ArticleCubit extends SafeCubit<ArticleState> {
  final GetArticlesUseCase _getArticlesUseCase;
  final ToggleSaveArticleUseCase _toggleSaveArticleUseCase;

  ArticleCubit(
    this._getArticlesUseCase,
    this._toggleSaveArticleUseCase,
  ) : super(ArticleState(articles: [], isLoading: true)) {
    loadArticles();
  }

  Future<void> loadArticles({bool refresh = false}) async {
    if (!refresh && state.articles.isNotEmpty) return;
    safeEmit(state.copyWith(isLoading: true, errorMessage: null));

    final operation = cancelableOperation(_getArticlesUseCase(refresh: refresh));
    final result = await operation.value;

    result.fold(
      (failure) => safeEmit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (articles) => safeEmit(state.copyWith(isLoading: false, articles: articles, errorMessage: null)),
    );
  }

  void toggleSaveArticle(String id) {
    debounce(const Duration(milliseconds: 300), () async {
      final operation = cancelableOperation(_toggleSaveArticleUseCase(id));
      final result = await operation.value;
      
      result.fold(
        (failure) => safeEmit(state.copyWith(errorMessage: failure.message)),
        (updatedArticle) {
          final updatedArticles = state.articles.map((article) {
            if (article.id == id) {
              return updatedArticle;
            }
            return article;
          }).toList();

          safeEmit(state.copyWith(
            articles: updatedArticles, 
            lastSavedArticleId: id,
            errorMessage: null,
          ));
        },
      );
    });
  }
}
