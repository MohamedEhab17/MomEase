import 'package:new_mama/feature/notifications/domain/entities/notification_entity.dart';

enum NotificationStatus { initial, loading, success, failure }

class NotificationState {
  final NotificationStatus status;
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final String? errorMessage;
  final String? successMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.errorMessage,
    this.successMessage,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? notifications,
    int? unreadCount,
    String? errorMessage,
    String? successMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
