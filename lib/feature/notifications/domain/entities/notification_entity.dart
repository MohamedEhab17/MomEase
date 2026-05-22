class NotificationEntity {
  final int notificationId;
  final String title;
  final String body;
  final String type;
  final int relatedEntityId;
  final String? actionUrl;
  final bool isRead;
  final String createdAt;
  final String? readAt;

  NotificationEntity({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.type,
    required this.relatedEntityId,
    this.actionUrl,
    required this.isRead,
    required this.createdAt,
    this.readAt,
  });
}
