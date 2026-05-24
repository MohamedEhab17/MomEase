import '../../data/model/notification_model.dart';

enum NotificationStatus { initial, loading, success, failure }

class NotificationState {
  final NotificationStatus status;
  final List<NotificationModel> notifications;
  final bool hasReachedMax;
  final String? errorMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.hasReachedMax = false,
    this.errorMessage,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationModel>? notifications,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
