import 'package:new_mama/feature/articles/data/models/article_category_model.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:new_mama/feature/articles/domain/entities/article_search_result.dart';

class ArticleSearchResultModel extends ArticleSearchResult {
  const ArticleSearchResultModel({
    required super.articles,
    required super.categories,
    required super.articlesCount,
    required super.categoriesCount,
    required super.searchTerm,
  });

  factory ArticleSearchResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    
    return ArticleSearchResultModel(
      searchTerm: json['searchTerm'] as String? ?? '',
      articles: (data['articles'] as List? ?? [])
          .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (data['categories'] as List? ?? [])
          .map((e) => ArticleCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      articlesCount: data['articlesCount'] as int? ?? 0,
      categoriesCount: data['categoriesCount'] as int? ?? 0,
    );
  }
}
