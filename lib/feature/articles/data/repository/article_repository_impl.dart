import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import '../datasource/article_local_datasource.dart';
import '../models/article_model.dart';
import 'article_repository.dart';

@LazySingleton(as: ArticleRepository)
class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleLocalDataSource _localDataSource;
  
  List<ArticleModel> _cachedArticles = [];

  ArticleRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<ArticleModel>>> getArticles({bool refresh = false}) async {
    try {
      if (!refresh && _cachedArticles.isNotEmpty) {
        return Right(_cachedArticles);
      }
      final articles = await _localDataSource.getArticles();
      _cachedArticles = List.from(articles);
      return Right(_cachedArticles);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ArticleModel>> toggleSaveArticle(String articleId) async {
    try {
      final index = _cachedArticles.indexWhere((a) => a.id == articleId);
      if (index == -1) return const Left(CacheFailure('Article not found in cache'));
      
      final article = _cachedArticles[index];
      final updatedArticle = article.copyWith(isSaved: !article.isSaved);
      
      _cachedArticles[index] = updatedArticle;
      return Right(updatedArticle);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
