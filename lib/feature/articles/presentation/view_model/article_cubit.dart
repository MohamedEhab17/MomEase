import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/feature/articles/presentation/view_model/article_state.dart';
import 'package:new_mama/feature/articles/dummy/article_dummy_data.dart';

@lazySingleton
class ArticleCubit extends Cubit<ArticleState> {
  ArticleCubit() : super(ArticleState(articles: [], isLoading: true)) {
    _loadArticles();
  }

  void _loadArticles() {
    emit(state.copyWith(isLoading: true));
    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () {
      emit(state.copyWith(isLoading: false, articles: dummyArticles));
    });
  }

  void toggleSaveArticle(String id) {
    if (state.isLoading) return;

    final updatedArticles = state.articles.map((article) {
      if (article.id == id) {
        return article.copyWith(isSaved: !article.isSaved);
      }
      return article;
    }).toList();

    emit(state.copyWith(articles: updatedArticles, lastSavedArticleId: id));
  }
}
