import 'package:equatable/equatable.dart';
import 'article.dart';
import 'article_category.dart';

class ArticleSearchResult extends Equatable {
  final List<Article> articles;
  final List<ArticleCategory> categories;
  final int articlesCount;
  final int categoriesCount;
  final String searchTerm;

  const ArticleSearchResult({
    required this.articles,
    required this.categories,
    required this.articlesCount,
    required this.categoriesCount,
    required this.searchTerm,
  });

  ArticleSearchResult copyWith({
    List<Article>? articles,
    List<ArticleCategory>? categories,
    int? articlesCount,
    int? categoriesCount,
    String? searchTerm,
  }) {
    return ArticleSearchResult(
      articles: articles ?? this.articles,
      categories: categories ?? this.categories,
      articlesCount: articlesCount ?? this.articlesCount,
      categoriesCount: categoriesCount ?? this.categoriesCount,
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }

  @override
  List<Object?> get props => [
        articles,
        categories,
        articlesCount,
        categoriesCount,
        searchTerm,
      ];
}
