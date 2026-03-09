import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dummy/dummy_notifications.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState());

  static const int _pageSize = 10;
  static const int _maxItems = 20;

  Future<void> loadNotifications() async {
    emit(state.copyWith(status: NotificationStatus.loading));

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      final initialData = generateDummyNotifications(_pageSize);
      emit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: initialData,
          hasReachedMax: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.hasReachedMax ||
        state.status == NotificationStatus.loading ||
        state.notifications.length >= _maxItems) {
      return;
    }

    try {
      // Simulate pagination delay
      await Future.delayed(const Duration(seconds: 1));

      final currentLength = state.notifications.length;
      final newItems = generateDummyNotifications(
        _pageSize,
        startIndex: currentLength,
      );

      final updatedList = List.of(state.notifications)..addAll(newItems);

      emit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: updatedList,
          hasReachedMax: updatedList.length >= _maxItems,
        ),
      );
    } catch (e) {
      // Handle error gracefully without overriding list
      emit(
        state.copyWith(
          status: NotificationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void markAsRead(int index) {
    final currentList = List.of(state.notifications);
    if (index >= 0 &&
        index < currentList.length &&
        currentList[index].isUnread) {
      currentList[index] = currentList[index].copyWith(isUnread: false);
      emit(state.copyWith(notifications: currentList));
    }
  }

  void deleteNotification(int index) {
    final currentList = List.of(state.notifications);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      emit(state.copyWith(notifications: currentList));
    }
  }

  void clearAll() {
    emit(state.copyWith(notifications: [], hasReachedMax: false));
  }
}
