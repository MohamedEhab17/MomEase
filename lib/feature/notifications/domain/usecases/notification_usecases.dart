import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:new_mama/core/error/failure.dart';
import '../../data/model/notification_model.dart';
import '../../data/repository/notification_repository.dart';

@injectable
class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationModel>>> call({bool refresh = false, required int limit}) {
    return repository.getNotifications(refresh: refresh, limit: limit);
  }
}

@injectable
class LoadMoreNotificationsUseCase {
  final NotificationRepository repository;

  LoadMoreNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationModel>>> call({required int limit}) {
    return repository.loadMoreNotifications(limit: limit);
  }
}

@injectable
class MarkAsReadUseCase {
  final NotificationRepository repository;

  MarkAsReadUseCase(this.repository);

  Future<Either<Failure, void>> call(int index) {
    return repository.markAsRead(index);
  }
}

@injectable
class DeleteNotificationUseCase {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<Either<Failure, void>> call(int index) {
    return repository.deleteNotification(index);
  }
}

@injectable
class ClearAllNotificationsUseCase {
  final NotificationRepository repository;

  ClearAllNotificationsUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.clearAll();
  }
}
