import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import '../models/article_model.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<ArticleModel>>> getArticles({bool refresh = false});
  Future<Either<Failure, ArticleModel>> toggleSaveArticle(String articleId);
}
