import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/notifications/domain/repository/notification_repository.dart';

@lazySingleton
class DeleteNotificationUseCase {
  final NotificationRepository _repository;

  DeleteNotificationUseCase(this._repository);

  Future<Either<Failure, String>> call(int id) {
    return _repository.deleteNotification(id);
  }
}
