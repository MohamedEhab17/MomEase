import 'package:new_mama/feature/articles/data/models/article_model.dart';

class ArticleState {
  final List<ArticleModel> articles;
  final bool isLoading;
  final String? lastSavedArticleId; // To trigger UI updates efficiently

  ArticleState({
    required this.articles,
    this.isLoading = false,
    this.lastSavedArticleId,
  });

  ArticleState copyWith({
    List<ArticleModel>? articles,
    bool? isLoading,
    String? lastSavedArticleId,
  }) {
    return ArticleState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      lastSavedArticleId:
          lastSavedArticleId, // We let it be null if not provided
    );
  }
}
