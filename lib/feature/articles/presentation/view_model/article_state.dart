import 'package:new_mama/feature/articles/data/models/article_model.dart';

class ArticleState {
  final List<ArticleModel> articles;
  final bool isLoading;
  final String? lastSavedArticleId; // To trigger UI updates efficiently
  final String? errorMessage;

  ArticleState({
    required this.articles,
    this.isLoading = false,
    this.lastSavedArticleId,
    this.errorMessage,
  });

  ArticleState copyWith({
    List<ArticleModel>? articles,
    bool? isLoading,
    String? lastSavedArticleId,
    String? errorMessage,
  }) {
    return ArticleState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      lastSavedArticleId: lastSavedArticleId,
      errorMessage: errorMessage,
    );
  }
}
