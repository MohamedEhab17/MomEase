import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/extensions/string_ex.dart';
import 'package:new_mama/core/extensions/date_time_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';
import 'package:new_mama/core/widgets/delete_confirmation_dialog.dart';
import 'package:new_mama/feature/community/data/models/comment_model.dart';
import 'package:new_mama/feature/community/data/models/reply_model.dart';
import 'package:new_mama/feature/community/presentation/view_model/comments_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/widgets/comment_components/reply_item.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/reaction_picker.dart';

class CommentItem extends StatefulWidget {
  final CommentModel comment;
  final int postUserId;
  final Function(CommentModel) onReply;
  final Function(CommentModel)? onEdit;
  final Function(ReplyModel, int)? onEditReply;

  const CommentItem({
    super.key,
    required this.comment,
    required this.postUserId,
    required this.onReply,
    this.onEdit,
    this.onEditReply,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _showReplies = false;
  bool _isTextExpanded = false;

  @override
  void didUpdateWidget(covariant CommentItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.comment.repliesCount > oldWidget.comment.repliesCount && 
        widget.comment.loadedReplies != null &&
        widget.comment.loadedReplies!.isNotEmpty) {
      
      final lastReply = widget.comment.loadedReplies!.last;
      if (lastReply.isMyReply && !_showReplies) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _showReplies = true);
        });
      }
    }
  }

  void _toggleReplies() {
    final show = !_showReplies;
    setState(() => _showReplies = show);
    
    if (show && widget.comment.loadedReplies == null && !widget.comment.isLoadingReplies) {
      context.read<CommentsCubit>().loadReplies(widget.comment.postId, widget.comment.commentId);
    }
  }

  void _handleReply() {
    widget.onReply.call(widget.comment);
  }

  void _showCommentOptions(BuildContext context) {
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
                Clipboard.setData(ClipboardData(text: widget.comment.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.isAr ? 'تم نسخ التعليق' : 'Comment copied')),
                );
              },
            ),
            if (widget.comment.isMyComment)
              ListTile(
                leading: Icon(Icons.edit_outlined, color: context.colors.onSurface),
                title: Text(context.isAr ? 'تعديل التعليق' : 'Edit Comment'),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onEdit?.call(widget.comment);
                },
              ),
            if (widget.comment.canDelete)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(context.isAr ? 'حذف التعليق' : 'Delete Comment', style: const TextStyle(color: Colors.red)),
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
    final communityCubit = context.read<CommunityCubit>();
    showDialog<bool>(
      context: context,
      builder: (ctx) => DeleteConfirmationDialog(
        title: context.isAr ? 'حذف التعليق' : 'Delete Comment',
        content: context.isAr ? 'هل تريد حذف هذا التعليق؟' : 'Delete this comment?',
      ),
    ).then((confirm) {
      if (confirm == true) {
        communityCubit.decrementCommentCount(widget.comment.postId);
        cubit.deleteComment(widget.comment.postId, widget.comment.commentId);
      }
    });
  }

  String? get _resolvedPhoto {
    final p = widget.comment.userPhoto;
    if (p == null || p.isEmpty) return null;
    return p.startsWith('http') ? p : 'http://momease.runasp.net$p';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showCommentOptions(context),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsetsDirectional.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCommentHeader(),
            8.height,
            _buildCommentText(),
            12.height,
            _buildActionButtons(),
            8.height,
            if (_shouldShowViewRepliesButton) ...[
              _buildReplyToggleButton(isHiding: false),
              8.height,
            ],
            if (_shouldShowReplies) ...[
              ..._buildNestedReplies(),
              _buildReplyToggleButton(isHiding: true),
              8.height,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCommentHeader() {
    final initials = widget.comment.userName.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase();
    final photo = _resolvedPhoto;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: context.ext.colors.primaryLighter.withAlpha(102),
          backgroundImage: photo != null ? CachedNetworkImageProvider(photo) : null,
          child: photo == null
              ? Text(initials, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: context.ext.colors.primaryDark))
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
                    widget.comment.userName,
                    style: context.text.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (widget.comment.userId == widget.postUserId) ...[
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
                ],
              ),
              Text(
                widget.comment.createdAt.toRelativeTime(context),
                style: context.text.labelLarge!.copyWith(
                  color: context.colors.onSurface.withAlpha(128),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentText() {
    final bool isArabicText = widget.comment.text.isArabic;
    final textLength = widget.comment.text.length;
    final bool shouldShowReadMore = textLength > 150 && !_isTextExpanded;

    return Padding(
      padding: 28.hPadding,
      child: Column(
        crossAxisAlignment: isArabicText ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              widget.comment.text,
              textAlign: isArabicText ? TextAlign.right : TextAlign.left,
              textDirection: isArabicText ? TextDirection.rtl : TextDirection.ltr,
              maxLines: _isTextExpanded ? null : 4,
              overflow: _isTextExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: context.text.bodyLarge!.copyWith(
                fontSize: 16.sp,
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
                  style: context.text.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.ext.colors.primaryDark,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: 8.hPadding,
      child: Row(
        children: [
          _buildLikeButton(),
          const SizedBox(width: 16),
          _buildReplyButton(),
        ],
      ),
    );
  }

  void _handleReactionSelect(String type) {
    context.read<CommentsCubit>().toggleReaction(
      widget.comment.postId,
      widget.comment.commentId,
      widget.comment.myReaction,
      type,
    );
  }

  void _toggleReaction() {
    final current = widget.comment.myReaction;
    // If no reaction, default to 'LOVE'. If exists, remove it.
    final newReaction = current == null ? 'LOVE' : current;
    
    context.read<CommentsCubit>().toggleReaction(
      widget.comment.postId,
      widget.comment.commentId,
      current,
      newReaction,
    );
  }

  Widget _buildLikeButton() {
    final reactionType = widget.comment.myReaction;
    final config = ReactionConfig.byType(reactionType);

    return Builder(
      builder: (btnContext) {
        return GestureDetector(
          onTap: _toggleReaction,
          onLongPress: () {
            final box = btnContext.findRenderObject() as RenderBox?;
            if (box == null) return;
            final offset = box.localToGlobal(const Offset(0, -10));
            ReactionPickerOverlay.show(context, offset, _handleReactionSelect);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.elasticOut,
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: child,
                ),
                child: config != null
                    ? Icon(
                        key: ValueKey(config.type),
                        config.icon,
                        color: config.color,
                        size: 16.r,
                      )
                    : SvgPicture.asset(
                        key: const ValueKey('unfilled'),
                        AppIcons.iconsUnfilledLike,
                        height: 16.h,
                        width: 16.w,
                        colorMapper: AppSvgColorMapper(
                          from: context.ext.colors.primaryDark,
                          to: context.ext.colors.primaryDark,
                        ),
                      ),
              ),
              const SizedBox(width: 4),
              Text(
                context.trContext(TK.communityLikesCount, namedArgs: {'count': '${widget.comment.reactionsCount}'}),
                style: context.text.labelLarge!.copyWith(
                  color: config?.color ?? context.colors.onSurface.withAlpha(179),
                  fontWeight: config != null ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildReplyButton() {
    return GestureDetector(
      onTap: _handleReply,
      child: Text(
        context.trContext(TK.communityReply),
        style: context.text.labelLarge!.copyWith(
          color: context.ext.colors.primaryDark,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildReplyToggleButton({required bool isHiding}) {
    return GestureDetector(
      onTap: _toggleReplies,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          40.width,
          SizedBox(
            width: 17,
            child: Divider(
              height: 1,
              thickness: 1,
              color: context.colors.onSurface.withAlpha(179),
            ),
          ),
          const SizedBox(width: 6),
          if (widget.comment.isLoadingReplies && !isHiding)
            SizedBox(
              width: 12.r,
              height: 12.r,
              child: CircularProgressIndicator(strokeWidth: 2, color: context.colors.onSurface.withAlpha(179)),
            )
          else
            Text(
              isHiding
                  ? context.trContext(TK.communityHideReplies, namedArgs: {'count': widget.comment.repliesCount.toString()})
                  : context.trContext(TK.communityViewReplies, namedArgs: {'count': widget.comment.repliesCount.toString()}),
              style: context.text.labelLarge!.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colors.onSurface.withAlpha(179),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildNestedReplies() {
    if (widget.comment.loadedReplies == null) return [];
    
    return widget.comment.loadedReplies!
        .map(
          (reply) => ReplyItem(
            reply: reply,
            postId: widget.comment.postId,
            commentId: widget.comment.commentId,
            postUserId: widget.postUserId,
            onEdit: (replyToEdit) =>
                widget.onEditReply?.call(replyToEdit, widget.comment.commentId),
          ),
        )
        .toList();
  }

  bool get _shouldShowViewRepliesButton =>
      widget.comment.repliesCount > 0 && !_showReplies;

  bool get _shouldShowReplies =>
      _showReplies;
}
