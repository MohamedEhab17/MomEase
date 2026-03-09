import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';

import '../view_model/notification_cubit.dart';
import '../widgets/notification_header.dart';
import '../widgets/notification_list.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit()..loadNotifications(),
      child: Column(
        children: [
          const NotificationHeader(),
          8.h.height,
          const Expanded(child: NotificationList()),
        ],
      ),
    );
  }
}
