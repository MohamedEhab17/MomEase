import 'package:new_mama/feature/articles/data/models/article_category_model.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:new_mama/feature/articles/data/models/article_search_result_model.dart';

abstract class ArticleRemoteDataSourceContract {
  Future<List<ArticleCategoryModel>> getCategories();
  Future<List<ArticleModel>> getArticlesByCategory(int categoryId);
  Future<ArticleModel> getArticleById(int id);
  Future<ArticleSearchResultModel> searchArticles(String query);
  Future<List<ArticleModel>> getSavedArticles();
  Future<void> saveArticle(int articleId);
  Future<void> unsaveArticle(int articleId);
  
  // Search History
  Future<List<String>> getSearchHistory();
  Future<void> clearSearchHistory();
  Future<void> removeSearchTerm(String term);
}