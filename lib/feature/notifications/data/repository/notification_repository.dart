import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import '../model/notification_model.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationModel>>> getNotifications({bool refresh = false, required int limit});
  Future<Either<Failure, List<NotificationModel>>> loadMoreNotifications({required int limit});
  Future<Either<Failure, void>> markAsRead(int index);
  Future<Either<Failure, void>> deleteNotification(int index);
  Future<Either<Failure, void>> clearAll();
}
