import 'package:injectable/injectable.dart';
import '../../data/model/notification_model.dart';
import '../../dummy/dummy_notifications.dart';

abstract class NotificationLocalDataSource {
  Future<List<NotificationModel>> getNotifications({required int limit, int startIndex = 0});
}

@LazySingleton(as: NotificationLocalDataSource)
class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  @override
  Future<List<NotificationModel>> getNotifications({required int limit, int startIndex = 0}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return generateDummyNotifications(limit, startIndex: startIndex);
  }
}
