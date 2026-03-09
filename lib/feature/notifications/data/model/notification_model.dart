class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String time;
  final bool isUnread;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? time,
    bool? isUnread,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      time: time ?? this.time,
      isUnread: isUnread ?? this.isUnread,
    );
  }
}
