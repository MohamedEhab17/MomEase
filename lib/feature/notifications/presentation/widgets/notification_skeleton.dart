import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import '../../data/model/notification_model.dart';
import 'notification_item.dart';

class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyItem = NotificationModel(
      id: 'skeleton',
      title: '...',
      body: '...',
      time: context.trContext(TK.communityJustNow),
      isUnread: false,
    );

    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: EdgeInsetsDirectional.only(bottom: 20.h, top: 4.h),
        itemCount: 10,
        separatorBuilder: (context, index) => 16.h.height,
        itemBuilder: (context, index) {
          return NotificationItem(
            notification: dummyItem,

            onTap: () {},
            onDelete: () {},
            onViewPost: () {},
          );
        },
      ),
    );
  }
}
