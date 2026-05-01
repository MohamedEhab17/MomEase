import 'package:injectable/injectable.dart';
import 'package:new_mama/feature/articles/domain/repositories/articles_repository.dart';

@injectable
class WatchArticleSaveStatusUseCase {
  final ArticlesRepository repository;

  WatchArticleSaveStatusUseCase(this.repository);

  Stream<(int, bool)> call() {
    return repository.articleSaveStatusStream;
  }
}
