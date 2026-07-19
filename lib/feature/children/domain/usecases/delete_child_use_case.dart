import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/children/domain/repositories/children_repository.dart';

@injectable
class DeleteChildUseCase {
  final ChildrenRepository _repository;
  DeleteChildUseCase(this._repository);

  Future<Either<Failure, String>> call(int childId) =>
      _repository.deleteChild(childId);
}
