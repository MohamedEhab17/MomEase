import 'package:new_mama/feature/notifications/data/model/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<int> getUnreadCount();
  Future<String> markNotificationRead(int id);
  Future<String> markAllNotificationsRead();
  Future<String> deleteNotification(int id);
}
