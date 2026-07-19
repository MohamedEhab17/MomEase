import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/domain/repositories/children_repository.dart';

@injectable
class GetChildUseCase {
  final ChildrenRepository _repository;
  GetChildUseCase(this._repository);

  Future<Either<Failure, Child>> call(int childId) =>
      _repository.getChild(childId);
}
