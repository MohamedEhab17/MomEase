// import '../data/model/notification_model.dart';

// List<NotificationModel> generateDummyNotifications(
//   int count, {
//   int startIndex = 0,
// }) {
//   final List<NotificationModel> notifications = [];

//   final List<Map<String, String>> templates = [
//     {'title': 'New post likes', 'body': 'A mom has liked your recent post'},
//     {
//       'title': 'New comment on your post',
//       'body': 'Someone added a comment to your discussion',
//     },
//     {
//       'title': 'Someone followed you',
//       'body': 'A new mom started following your profile',
//     },
//     {
//       'title': 'Your article got saved',
//       'body': 'Your recent post was saved by another user',
//     },
//     {
//       'title': 'Reminder notification',
//       'body': 'Don\'t forget to log your baby\'s milestones today',
//     },
//   ];

//   final List<String> times = [
//     'Just now',
//     '1 hour ago',
//     '2h ago',
//     'Yesterday',
//     '2 days ago',
//   ];

//   for (int i = 0; i < count; i++) {
//     final index = startIndex + i;
//     final template = templates[index % templates.length];
//     final time = times[index % times.length];

//     // First few notifications will be unread initially
//     final isUnread = index < 5;

//     notifications.add(
//       NotificationModel(
//         id: 'notif_$index',
//         title: template['title']!,
//         body: template['body']!,
//         time: time,
//         isUnread: isUnread,
//       ),
//     );
//   }

//   return notifications;
// }
