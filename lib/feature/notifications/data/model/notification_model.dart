import 'package:new_mama/feature/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.notificationId,
    required super.title,
    required super.body,
    required super.type,
    required super.relatedEntityId,
    super.actionUrl,
    required super.isRead,
    required super.createdAt,
    super.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String,
      relatedEntityId: json['relatedEntityId'] as int,
      actionUrl: json['actionUrl'] as String?,
      isRead: json['isRead'] as bool,
      createdAt: json['createdAt'] as String,
      readAt: json['readAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'title': title,
      'body': body,
      'type': type,
      'relatedEntityId': relatedEntityId,
      'actionUrl': actionUrl,
      'isRead': isRead,
      'createdAt': createdAt,
      'readAt': readAt,
    };
  }
}
