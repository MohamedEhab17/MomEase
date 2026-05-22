import 'package:injectable/injectable.dart';
import 'package:new_mama/core/constants/api_keys.dart';
import 'package:new_mama/core/error/exceptions.dart';
import 'package:new_mama/core/network/api_client.dart';
import 'package:new_mama/feature/notifications/data/datasource/notification_remote_data_source.dart';
import 'package:new_mama/feature/notifications/data/model/notification_model.dart';

@LazySingleton(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiClient.get(Api.notifications);
    final data = response.data;
    if (data is Map<String, dynamic> && data['success'] == true) {
      final list = data['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw ServerException(
      data is Map ? (data['message'] as String? ?? 'Failed to get notifications') : 'Unexpected response',
    );
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _apiClient.get(Api.notificationsUnreadCount);
    final data = response.data;
    if (data is Map<String, dynamic> && data['success'] == true) {
      return data['count'] as int? ?? 0;
    }
    throw ServerException(
      data is Map ? (data['message'] as String? ?? 'Failed to get unread count') : 'Unexpected response',
    );
  }

  @override
  Future<String> markNotificationRead(int id) async {
    final response = await _apiClient.put(Api.notificationRead(id));
    final data = response.data;
    if (data is Map<String, dynamic> && data['success'] == true) {
      return data['message'] as String? ?? 'Notification marked as read';
    }
    throw ServerException(
      data is Map ? (data['message'] as String? ?? 'Failed to mark notification as read') : 'Unexpected response',
    );
  }

  @override
  Future<String> markAllNotificationsRead() async {
    final response = await _apiClient.put(Api.markAllNotificationsRead);
    final data = response.data;
    if (data is Map<String, dynamic> && data['success'] == true) {
      return data['message'] as String? ?? 'All notifications marked as read';
    }
    throw ServerException(
      data is Map ? (data['message'] as String? ?? 'Failed to mark all as read') : 'Unexpected response',
    );
  }

  @override
  Future<String> deleteNotification(int id) async {
    final response = await _apiClient.delete(Api.notificationById(id));
    final data = response.data;
    if (data is Map<String, dynamic> && data['success'] == true) {
      return data['message'] as String? ?? 'Notification deleted';
    }
    throw ServerException(
      data is Map ? (data['message'] as String? ?? 'Failed to delete notification') : 'Unexpected response',
    );
  }
}
