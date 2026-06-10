import 'package:dartz/dartz.dart';
import 'package:new_mama/core/error/failure.dart';
import 'package:new_mama/feature/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, String>> markNotificationRead(int id);
  Future<Either<Failure, String>> markAllNotificationsRead();
  Future<Either<Failure, String>> deleteNotification(int id);
  Future<Either<Failure, String>> registerDeviceToken(String token);
  Future<Either<Failure, String>> removeDeviceToken(String token);
}
