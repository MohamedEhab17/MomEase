import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/articles/domain/entities/article_category.dart';
import 'package:new_mama/feature/articles/domain/repositories/articles_repository.dart';

@injectable
class GetArticlesCategoryUsecase {
  final ArticlesRepository repository;

  GetArticlesCategoryUsecase(this.repository);

  Future<Either<Failure, List< ArticleCategory>>> call() {
    return repository.getCategories();
  }
}