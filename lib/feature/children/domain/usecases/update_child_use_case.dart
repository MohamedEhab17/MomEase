import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/domain/repositories/children_repository.dart';

@injectable
class UpdateChildUseCase {
  final ChildrenRepository _repository;
  UpdateChildUseCase(this._repository);

  Future<Either<Failure, Child>> call(int childId, UpdateChildParams params) =>
      _repository.updateChild(childId, params);
}
