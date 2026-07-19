import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';
import 'package:new_mama/feature/articles/domain/entities/article_category.dart';
import 'package:new_mama/feature/articles/domain/entities/article_search_result.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, List<ArticleCategory>>> getCategories();
  Future<Either<Failure, List<Article>>> getArticlesByCategory(int categoryId);
  Future<Either<Failure, Article>> getArticleById(int id);
  Future<Either<Failure, ArticleSearchResult>> searchArticles(String query);
  Future<Either<Failure, List<Article>>> getSavedArticles();
  Future<Either<Failure, void>> saveArticle(int articleId);
  Future<Either<Failure, void>> unsaveArticle(int articleId);
  Future<Either<Failure, List<String>>> getSearchHistory();
  Future<void> saveSearchQuery(String query);
  Future<void> clearSearchHistory();
  Future<void> removeSearchTerm(String term);
  Stream<(int, bool)> get articleSaveStatusStream;
}
