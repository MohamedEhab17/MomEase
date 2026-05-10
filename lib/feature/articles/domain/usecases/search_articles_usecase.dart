import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/feature/articles/domain/entities/article_search_result.dart';
import 'package:new_mama/feature/articles/domain/repositories/articles_repository.dart';

@injectable
class SearchArticlesUseCase {
  final ArticlesRepository repository;

  SearchArticlesUseCase(this.repository);

  Future<Either<Failure, ArticleSearchResult>> call(String query) async {
    return await repository.searchArticles(query);
  }
}
