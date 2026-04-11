import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

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
      context.read<NotificationCubit>().loadMore();
    }
  }

  void _onDelete(int index) {
    context.read<NotificationCubit>().deleteNotification(index);
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
              context.read<NotificationCubit>().loadNotifications(),
          color: context.ext.colors.primaryDark,
          child: ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.only(bottom: 20.h, top: 4.h),
            itemCount:
                state.notifications.length + (state.hasReachedMax ? 0 : 1),
            separatorBuilder: (context, index) => 16.h.height,
            itemBuilder: (context, index) {
              if (index >= state.notifications.length) {
                return Center(
                  child: Padding(
                    padding: 16.hPadding,
                    child: CircularProgressIndicator(
                      color: context.ext.colors.primaryDark,
                      strokeWidth: 3,
                    ),
                  ),
                );
              }

              final notification = state.notifications[index];
              return NotificationItem(
                notification: notification,
                onTap: () =>
                    context.read<NotificationCubit>().markAsRead(index),
                onDelete: () => _onDelete(index),
                onViewPost: () {},
              );
            },
          ),
        );
      },
    );
  }
}
