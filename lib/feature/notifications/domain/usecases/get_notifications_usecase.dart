import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/notifications/domain/entities/notification_entity.dart';
import 'package:new_mama/feature/notifications/domain/repository/notification_repository.dart';

@lazySingleton
class GetNotificationsUseCase {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<Either<Failure, List<NotificationEntity>>> call() {
    return _repository.getNotifications();
  }
}
