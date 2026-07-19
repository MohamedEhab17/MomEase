import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/feature/notifications/presentation/view_model/notification_cubit.dart';
import 'package:new_mama/feature/notifications/presentation/view_model/notification_state.dart';
import '../widgets/notification_header.dart';
import '../widgets/notification_list.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>()
      ..getNotifications()
      ..getUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          AppToast.error(context, message: state.errorMessage!);
          context.read<NotificationCubit>().clearMessages();
        }
        if (state.successMessage != null && state.successMessage!.isNotEmpty) {
          AppToast.success(context, message: state.successMessage!);
          context.read<NotificationCubit>().clearMessages();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NotificationHeader(),
          8.h.height,
          const Expanded(child: NotificationList()),
        ],
      ),
    );
  }
}

