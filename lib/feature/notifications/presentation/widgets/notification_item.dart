import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/notifications/domain/entities/notification_entity.dart';

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
    final DateTime createdAtDate =
        DateTime.tryParse(notification.createdAt) ?? DateTime.now();
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
                  child: Icon(Icons.delete_outline, size: 28.sp),
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
                        crossAxisAlignment: .start,
                        mainAxisAlignment: .center,
                        children: [
                          Text(
                            notification.title,
                            style: context.text.titleLarge!.copyWith(
                              fontWeight: .w500,
                              color: context.colors.onSurface,
                            ),
                            // maxLines: 1,
                            overflow: .ellipsis,
                            softWrap: true,
                          ),
                          4.h.height,
                          Text(
                            notification.body,
                            style: context.text.bodyLarge!.copyWith(
                              color: context.colors.onSurface.withAlpha(153),
                              fontWeight: .w400,
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
                      mainAxisAlignment: .spaceBetween,
                      crossAxisAlignment: .end,
                      children: [
                        Text(
                          timeString,
                          style: context.text.bodyMedium!.copyWith(
                            color: context.colors.onSurface.withAlpha(153),
                          ),
                        ),
                        if (_hasAction()) ...[
                          12.h.height,
                          InkWell(
                            onTap: onViewPost,
                            child: Text(
                              _getActionText(context),
                              style: context.text.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w700,
                                color: context.ext.colors.primaryDark,
                              ),
                            ),
                          ),
                        ] else ...[
                          25.h.height,
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

  bool _hasAction() {
    final type = notification.type;
    final actionUrl = notification.actionUrl;
    return (actionUrl != null && actionUrl.trim().isNotEmpty) ||
        type.contains('Tip') ||
        type.contains('Reminder') ||
        type.contains('Vaccination') ||
        type.contains('Comment') ||
        type.contains('Reaction') ||
        type.contains('Result');
  }

  String _getActionText(BuildContext context) {
    final type = notification.type;
    final actionUrl = notification.actionUrl;

    if (type.contains('Community') ||
        type.contains('Comment') ||
        type.contains('Reaction') ||
        (actionUrl?.contains('/posts/') ?? false)) {
      return context.isAr ? 'عرض المنشور' : 'View Post';
    } else if (type.contains('Assessment') ||
        (actionUrl?.contains('/assessments/') ?? false)) {
      if (type.contains('Reminder') || type.contains('Due')) {
        return context.isAr ? 'بدء التقييم' : 'Take Check-in';
      }
      return context.isAr ? 'عرض النتيجة' : 'View Result';
    } else if (type.contains('Tracking') ||
        type.contains('Vaccination') ||
        (actionUrl?.contains('/tracking') ?? false)) {
      return context.isAr ? 'عرض التتبع' : 'View Tracker';
    } else if (type.contains('Tip') ||
        (actionUrl?.contains('/tips/') ?? false)) {
      return context.isAr ? 'قراءة النصيحة' : 'Read Tip';
    }
    return context.isAr ? 'عرض' : 'View';
  }
}
