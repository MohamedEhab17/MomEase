import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';

import '../../data/model/notification_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
    required this.onViewPost,
  });

  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onViewPost;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: 20.hPadding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightTextPrimary.withAlpha(
              39,
            ), // 0x26 is roughly 15% opacity, blur 8-10, offset 0,4
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Slidable(
        key: ValueKey(notification.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            CustomSlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              child: const Icon(Icons.delete_outline, size: 28),
            ),
          ],
        ),
        child: Material(
          color: notification.isUnread
              ? AppColors.primaryLighter.withAlpha(153)
              : Colors.white,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  if (notification.isUnread) ...[
                    CircleAvatar(
                      radius: 4.r,
                      backgroundColor: AppColors.primaryDark, // Pink
                    ),
                    12.w.width,
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          notification.title,
                          style: AppStyles.styleInter16.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        4.h.height,
                        Text(
                          notification.body,
                          style: AppStyles.styleInter12.copyWith(
                            color: AppColors.lightTextPrimary.withAlpha(153),
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  16.w.width,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        notification.time,
                        style: AppStyles.styleInter10.copyWith(
                          color: AppColors.lightTextPrimary.withAlpha(153),
                        ),
                      ),
                      12.h.height,
                      InkWell(
                        onTap: onViewPost,
                        child: Text(
                          'View Post',
                          style: AppStyles.styleInter12.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark, // Pink color
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
