import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/date_time_ex.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/string_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/widgets/delete_confirmation_dialog.dart';
import 'package:new_mama/feature/community/data/models/reply_model.dart';
import 'package:new_mama/feature/community/presentation/view_model/comments_cubit.dart';

class ReplyItem extends StatefulWidget {
  final ReplyModel reply;
  final int postId;
  final int commentId;
  final int postUserId;
  final Function(ReplyModel)? onEdit;

  const ReplyItem({
    super.key,
    required this.reply,
    required this.postId,
    required this.commentId,
    required this.postUserId,
    this.onEdit,
  });

  @override
  State<ReplyItem> createState() => _ReplyItemState();
}

class _ReplyItemState extends State<ReplyItem> {
  bool _isTextExpanded = false;

  String? get _resolvedPhoto {
    final p = widget.reply.userPhoto;
    if (p == null || p.isEmpty) return null;
    return p.startsWith('http') ? p : 'http://momease.runasp.net$p';
  }

  @override
  Widget build(BuildContext context) {
    final initials = widget.reply.userName
        .trim()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0])
        .take(2)
        .join()
        .toUpperCase();
    final photo = _resolvedPhoto;
    final bool isArabicText = widget.reply.text.isArabic;
    final textLength = widget.reply.text.length;
    final bool shouldShowReadMore = textLength > 150 && !_isTextExpanded;

    return GestureDetector(
      onLongPress: () => _showReplyOptions(context),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 44.w, bottom: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 16.r,
              backgroundColor: context.ext.colors.primaryLighter.withAlpha(102),
              backgroundImage: photo != null
                  ? CachedNetworkImageProvider(photo)
                  : null,
              child: photo == null
                  ? Text(
                      initials,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: context.ext.colors.primaryDark,
                      ),
                    )
                  : null,
            ),
            8.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.reply.userName,
                        style: context.text.bodySmall!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (widget.reply.userId == widget.postUserId) ...[
                        6.width,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.ext.colors.primaryDark,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            context.isAr ? 'صاحب المنشور' : 'Author',
                            style: context.text.labelSmall!.copyWith(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      4.width,
                      Text(
                        widget.reply.createdAt.toRelativeTime(context),
                        style: context.text.labelLarge!.copyWith(
                          color: context.colors.onSurface.withAlpha(128),
                        ),
                      ),
                    ],
                  ),
                  4.height,
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.reply.text,
                      textAlign: isArabicText ? TextAlign.right : TextAlign.left,
                      textDirection: isArabicText ? TextDirection.rtl : TextDirection.ltr,
                      maxLines: _isTextExpanded ? null : 4,
                      overflow: _isTextExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: context.text.bodyMedium!.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: context.colors.onSurface.withAlpha(179),
                        height: 1.4,
                      ),
                    ),
                  ),
                  if (shouldShowReadMore)
                    GestureDetector(
                      onTap: () => setState(() => _isTextExpanded = true),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          context.isAr ? 'قراءة المزيد' : 'Read more',
                          style: context.text.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.ext.colors.primaryDark,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReplyOptions(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.copy, color: context.colors.onSurface),
              title: Text(context.isAr ? 'نسخ النص' : 'Copy Text'),
              onTap: () {
                Navigator.pop(ctx);
                Clipboard.setData(ClipboardData(text: widget.reply.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.isAr ? 'تم نسخ الرد' : 'Reply copied',
                    ),
                  ),
                );
              },
            ),
            if (widget.reply.isMyReply)
              ListTile(
                leading: Icon(Icons.edit_outlined, color: context.colors.onSurface),
                title: Text(context.isAr ? 'تعديل الرد' : 'Edit Reply'),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onEdit?.call(widget.reply);
                },
              ),
            if (widget.reply.isMyReply)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  context.isAr ? 'حذف الرد' : 'Delete Reply',
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final cubit = context.read<CommentsCubit>();
    showDialog<bool>(
      context: context,
      builder: (ctx) => DeleteConfirmationDialog(
        title: context.isAr ? 'حذف الرد' : 'Delete Reply',
        content: context.isAr ? 'هل تريد حذف هذا الرد؟' : 'Delete this reply?',
      ),
    ).then((confirm) {
      if (confirm == true) {
        cubit.deleteReply(widget.postId, widget.commentId, widget.reply.replyId);
      }
    });
  }
}
