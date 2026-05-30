import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/notifications/domain/repository/notification_repository.dart';

@lazySingleton
class RegisterDeviceTokenUseCase {
  final NotificationRepository _repository;

  RegisterDeviceTokenUseCase(this._repository);

  Future<Either<Failure, String>> call(String token) {
    return _repository.registerDeviceToken(token);
  }
}

@lazySingleton
class RemoveDeviceTokenUseCase {
  final NotificationRepository _repository;

  RemoveDeviceTokenUseCase(this._repository);

  Future<Either<Failure, String>> call(String token) {
    return _repository.removeDeviceToken(token);
  }
}
