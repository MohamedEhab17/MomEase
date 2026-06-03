import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/notifications/domain/entities/notification_entity.dart';
import 'package:new_mama/core/utils/notification_router.dart';
import 'package:new_mama/core/widgets/delete_confirmation_dialog.dart';
import '../view_model/notification_cubit.dart';
import '../view_model/notification_state.dart';
import 'empty_notifications.dart';
import 'notification_item.dart';
import 'notification_skeleton.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Pagination logic can be added here
    }
  }

  void _handleNotificationSelection(BuildContext context, NotificationEntity notification) {
    // 1. Mark as read in Cubit/state
    context.read<NotificationCubit>().markAsRead(notification.notificationId);

    // 2. Route dynamically using NotificationRouter
    NotificationRouter.navigate(
      context,
      actionUrl: notification.actionUrl,
      type: notification.type,
      relatedEntityId: notification.relatedEntityId,
      title: notification.title,
      body: notification.body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state.status == NotificationStatus.initial ||
            (state.status == NotificationStatus.loading &&
                state.notifications.isEmpty)) {
          return const NotificationSkeleton();
        }

        if (state.notifications.isEmpty &&
            state.status == NotificationStatus.success) {
          return const EmptyNotifications();
        }

        return RefreshIndicator(
          onRefresh: () =>
              context.read<NotificationCubit>().getNotifications(),
          color: context.ext.colors.primaryDark,
          child: ListView.separated(
            controller: _scrollController,
            padding: EdgeInsetsDirectional.only(bottom: 20.h, top: 4.h),
            itemCount: state.notifications.length,
            separatorBuilder: (context, index) => 16.h.height,
            itemBuilder: (context, index) {
              final notification = state.notifications[index];
              return NotificationItem(
                notification: notification,
                onTap: () => _handleNotificationSelection(context, notification),
                onDelete: () {
                  showDialog<bool>(
                    context: context,
                    builder: (dialogCtx) => DeleteConfirmationDialog(
                      title: context.isAr ? 'حذف الإشعار' : 'Delete Notification',
                      content: context.isAr 
                          ? 'هل أنتِ متأكدة من رغبتكِ في حذف هذا الإشعار نهائياً؟' 
                          : 'Are you sure you want to permanently delete this notification?',
                    ),
                  ).then((confirm) {
                    if (confirm == true && context.mounted) {
                      context.read<NotificationCubit>().deleteNotification(notification.notificationId);
                    }
                  });
                },
                onViewPost: () => _handleNotificationSelection(context, notification),
              );
            },
          ),
        );
      },
    );
  }
}
