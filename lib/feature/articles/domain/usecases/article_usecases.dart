import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import '../../data/models/article_model.dart';
import '../../data/repository/article_repository.dart';

@injectable
class GetArticlesUseCase {
  final ArticleRepository repository;

  GetArticlesUseCase(this.repository);

  Future<Either<Failure, List<ArticleModel>>> call({bool refresh = false}) {
    return repository.getArticles(refresh: refresh);
  }
}

@injectable
class ToggleSaveArticleUseCase {
  final ArticleRepository repository;

  ToggleSaveArticleUseCase(this.repository);

  Future<Either<Failure, ArticleModel>> call(String articleId) {
    return repository.toggleSaveArticle(articleId);
  }
}
