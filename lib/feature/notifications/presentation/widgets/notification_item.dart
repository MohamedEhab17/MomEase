import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/notifications/domain/entities/notification_entity.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
    required this.onViewPost,
  });

  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onViewPost;

  @override
  Widget build(BuildContext context) {
    final DateTime createdAtDate = DateTime.tryParse(notification.createdAt) ?? DateTime.now();
    final String timeString = DateFormat('hh:mm a').format(createdAtDate);
    final bool isUnread = !notification.isRead;

    return Padding(
      padding: 20.hPadding,
      child: Material(
        elevation: 8,
        shadowColor: context.colors.onSurface.withAlpha(39),
        borderRadius: BorderRadius.circular(16.r),
        color: isUnread
            ? context.ext.colors.primaryLighter.withAlpha(128)
            : context.theme.cardColor,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: isUnread
                ? context.ext.colors.primaryLighter.withAlpha(128)
                : context.theme.cardColor,
          ),
          child: Slidable(
            key: ValueKey(notification.notificationId),
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
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    if (isUnread) ...[
                      CircleAvatar(
                        radius: 4.r,
                        backgroundColor: context.ext.colors.primaryDark, // Pink
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
                            style: context.text.titleLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: context.colors.onSurface,
                            ),
                           // maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          4.h.height,
                          Text(
                            notification.body,
                            style: context.text.bodyLarge!.copyWith(
                              color: context.colors.onSurface.withAlpha(153),
                              fontWeight: FontWeight.w400,
                            ),
                           // maxLines: 2,
                            softWrap: true,
                            // overflow: TextOverflow.ellipsis,
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
                          timeString,
                          style: context.text.bodyMedium!.copyWith(
                            color: context.colors.onSurface.withAlpha(153),
                          ),
                        ),
                        if (notification.actionUrl != null) ...[
                          12.h.height,
                          InkWell(
                            onTap: onViewPost,
                            child: Text(
                              context.trContext(TK.notificationsViewPost),
                              style: context.text.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w700,
                                color: context.ext.colors.primaryDark,
                              ),
                            ),
                          ),
                        ] else ...[
                          12.h.height,
                          SizedBox(height: 18.h),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
