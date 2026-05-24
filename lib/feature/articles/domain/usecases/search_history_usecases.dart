import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/articles/domain/repositories/articles_repository.dart';

@injectable
class GetSearchHistoryUseCase {
  final ArticlesRepository repository;
  GetSearchHistoryUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getSearchHistory();
  }
}

@injectable
class SaveSearchQueryUseCase {
  final ArticlesRepository repository;
  SaveSearchQueryUseCase(this.repository);

  Future<void> call(String query) async {
    await repository.saveSearchQuery(query);
  }
}

@injectable
class ClearSearchHistoryUseCase {
  final ArticlesRepository repository;
  ClearSearchHistoryUseCase(this.repository);

  Future<void> call() async {
    await repository.clearSearchHistory();
  }
}

@injectable
class RemoveSearchTermUseCase {
  final ArticlesRepository repository;
  RemoveSearchTermUseCase(this.repository);

  Future<void> call(String term) async {
    await repository.removeSearchTerm(term);
  }
}
