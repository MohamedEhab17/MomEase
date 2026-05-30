import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:new_mama/core/base/safe_cubit.dart';
import 'package:new_mama/core/services/fcm_service.dart';
import 'package:new_mama/feature/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:new_mama/feature/notifications/domain/usecases/device_token_usecases.dart';
import 'package:new_mama/feature/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:new_mama/feature/notifications/domain/usecases/get_unread_count_usecase.dart';
import 'package:new_mama/feature/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:new_mama/feature/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'notification_state.dart';

@injectable
class NotificationCubit extends SafeCubit<NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final GetUnreadCountUseCase _getUnreadCountUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase _markAllNotificationsReadUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;
  final RegisterDeviceTokenUseCase _registerDeviceTokenUseCase;
  final RemoveDeviceTokenUseCase _removeDeviceTokenUseCase;

  NotificationCubit(
    this._getNotificationsUseCase,
    this._getUnreadCountUseCase,
    this._markNotificationReadUseCase,
    this._markAllNotificationsReadUseCase,
    this._deleteNotificationUseCase,
    this._registerDeviceTokenUseCase,
    this._removeDeviceTokenUseCase,
  ) : super(const NotificationState());

  // ─────────────────────────── FCM Token ───────────────────────────────────

  /// Gets the FCM token and registers it with the backend.
  Future<void> registerFcmToken() async {
    final token = await FcmService.getToken();
    if (token == null) return;

    final result = await _registerDeviceTokenUseCase(token);
    result.fold(
      (failure) => log('[FCM] Failed to register token: ${failure.message}'),
      (msg) => log('[FCM] Token registered: $msg'),
    );
  }

  /// Removes the FCM token from the backend (call before logout).
  Future<void> removeFcmToken() async {
    final token = await FcmService.getToken();
    if (token == null) return;

    final result = await _removeDeviceTokenUseCase(token);
    result.fold(
      (failure) => log('[FCM] Failed to remove token: ${failure.message}'),
      (msg) => log('[FCM] Token removed: $msg'),
    );
  }

  // ─────────────────────────── Notifications ───────────────────────────────

  Future<void> getNotifications() async {
    safeEmit(state.copyWith(status: NotificationStatus.loading));

    final operation = cancelableOperation(_getNotificationsUseCase());
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
        ),
      ),
    );
  }

  Future<void> getUnreadCount() async {
    final operation = cancelableOperation(_getUnreadCountUseCase());
    final result = await operation.value;

    result.fold(
      (failure) {},
      (count) => safeEmit(state.copyWith(unreadCount: count)),
    );
  }

  Future<void> markAsRead(int notificationId) async {
    final operation = cancelableOperation(
      _markNotificationReadUseCase(notificationId),
    );
    final result = await operation.value;

    result.fold(
      (failure) => safeEmit(
        state.copyWith(
          status: NotificationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (message) {
        getNotifications();
        getUnreadCount();
      },
    );
  }

  Future<void> markAllAsRead() async {
    final operation = cancelableOperation(_markAllNotificationsReadUseCase());
    final result = await operation.value;

    result.fold(
      (failure) => safeEmit(
        state.copyWith(
          status: NotificationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (message) {
        getNotifications();
        getUnreadCount();
      },
    );
  }

  Future<void> deleteNotification(int notificationId) async {
    final operation = cancelableOperation(
      _deleteNotificationUseCase(notificationId),
    );
    final result = await operation.value;

    result.fold(
      (failure) => safeEmit(
        state.copyWith(
          status: NotificationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (message) {
        getNotifications();
      },
    );
  }
}
