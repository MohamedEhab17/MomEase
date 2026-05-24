import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import '../../domain/usecases/notification_usecases.dart';
import 'notification_state.dart';

@injectable
class NotificationCubit extends SafeCubit<NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final LoadMoreNotificationsUseCase _loadMoreNotificationsUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;
  final ClearAllNotificationsUseCase _clearAllNotificationsUseCase;

  NotificationCubit(
    this._getNotificationsUseCase,
    this._loadMoreNotificationsUseCase,
    this._markAsReadUseCase,
    this._deleteNotificationUseCase,
    this._clearAllNotificationsUseCase,
  ) : super(const NotificationState());

  static const int _pageSize = 10;
  static const int _maxItems = 20;

  Future<void> loadNotifications() async {
    safeEmit(state.copyWith(status: NotificationStatus.loading));

    final operation = cancelableOperation(_getNotificationsUseCase(limit: _pageSize));
    final result = await operation.value;

    result.fold(
      (failure) => safeEmit(
        state.copyWith(
          status: NotificationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (notifications) => safeEmit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
          hasReachedMax: notifications.length >= _maxItems,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.hasReachedMax ||
        state.status == NotificationStatus.loading ||
        state.notifications.length >= _maxItems) {
      return;
    }

    final operation = cancelableOperation(_loadMoreNotificationsUseCase(limit: _pageSize));
    final result = await operation.value;

    result.fold(
      (failure) => safeEmit(
        state.copyWith(
          status: NotificationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (notifications) => safeEmit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
          hasReachedMax: notifications.length >= _maxItems,
        ),
      ),
    );
  }

  void markAsRead(int index) async {
    final operation = cancelableOperation(_markAsReadUseCase(index));
    await operation.value;
    
    // We can optimistically update the state locally 
    // to avoid waiting for the repository if needed, 
    // but fetching from cached notifications is fine too.
    // For simplicity, let's optimistically update:
    final currentList = List.of(state.notifications);
    if (index >= 0 && index < currentList.length && currentList[index].isUnread) {
      currentList[index] = currentList[index].copyWith(isUnread: false);
      safeEmit(state.copyWith(notifications: currentList));
    }
  }

  void deleteNotification(int index) async {
    final operation = cancelableOperation(_deleteNotificationUseCase(index));
    await operation.value;

    final currentList = List.of(state.notifications);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      safeEmit(state.copyWith(notifications: currentList));
    }
  }

  void clearAll() async {
    final operation = cancelableOperation(_clearAllNotificationsUseCase());
    await operation.value;
    safeEmit(state.copyWith(notifications: [], hasReachedMax: false));
  }
}
