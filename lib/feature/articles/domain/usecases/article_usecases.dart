import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';
import 'package:new_mama/feature/articles/domain/repositories/articles_repository.dart';

@injectable
class GetArticlesByCategoryUseCase {
  final ArticlesRepository repository;

  GetArticlesByCategoryUseCase(this.repository);

  Future<Either<Failure, List<Article>>> call(int categoryId) {
    return repository.getArticlesByCategory(categoryId);
  }
}

@injectable
class GetArticleByIdUseCase {
  final ArticlesRepository repository;

  GetArticleByIdUseCase(this.repository);

  Future<Either<Failure, Article>> call(int id) {
    return repository.getArticleById(id);
  }
}

@injectable
class SaveArticleUseCase {
  final ArticlesRepository repository;

  SaveArticleUseCase(this.repository);

  Future<Either<Failure, void>> call(int articleId) {
    return repository.saveArticle(articleId);
  }
}

@injectable
class UnsaveArticleUseCase {
  final ArticlesRepository repository;

  UnsaveArticleUseCase(this.repository);

  Future<Either<Failure, void>> call(int articleId) {
    return repository.unsaveArticle(articleId);
  }
}

@injectable
class GetSavedArticlesUseCase {
  final ArticlesRepository repository;

  GetSavedArticlesUseCase(this.repository);

  Future<Either<Failure, List<Article>>> call() {
    return repository.getSavedArticles();
  }
}
