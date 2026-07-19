import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/children/domain/repositories/children_repository.dart';

@injectable
class UploadChildPhotoUseCase {
  final ChildrenRepository _repository;
  UploadChildPhotoUseCase(this._repository);

  Future<Either<Failure, String>> call(int childId, File photo) =>
      _repository.uploadPhoto(childId, photo);
}

@injectable
class DeleteChildPhotoUseCase {
  final ChildrenRepository _repository;
  DeleteChildPhotoUseCase(this._repository);

  Future<Either<Failure, String>> call(int childId) =>
      _repository.deletePhoto(childId);
}
