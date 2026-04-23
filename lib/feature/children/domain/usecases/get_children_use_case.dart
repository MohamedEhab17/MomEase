import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/domain/repositories/children_repository.dart';

@injectable
class GetChildrenUseCase {
  final ChildrenRepository _repository;
  GetChildrenUseCase(this._repository);

  Future<Either<Failure, List<Child>>> call() => _repository.getChildren();
}
