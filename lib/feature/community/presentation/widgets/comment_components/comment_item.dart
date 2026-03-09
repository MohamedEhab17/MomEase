import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/community/data/models/comment_model.dart';

/// A widget that displays a single comment with interactive features
/// including like button, reply functionality, and nested replies support.
class CommentItem extends StatefulWidget {
  final CommentModel comment;
  final bool isReply;
  final Function(CommentModel)? onReply;

  const CommentItem({
    super.key,
    required this.comment,
    this.isReply = false,
    this.onReply,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _showReplies = false;
  late bool _isLiked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.comment.isLiked;
    _likeCount = widget.comment.likes;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
    });
  }

  void _toggleReplies() {
    setState(() => _showReplies = !_showReplies);
  }

  void _handleReply() {
    widget.onReply?.call(widget.comment);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16, left: widget.isReply ? 40 : 0),
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
    );
  }

  Widget _buildCommentHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(widget.comment.profileUrl),
        ),
        8.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.comment.name,
                style: AppStyles.styleInter10.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.comment.timeAgo,
                style: AppStyles.styleInter8.copyWith(
                  color: AppColors.lightTextPrimary.withAlpha(128),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentText() {
    return Padding(
      padding: 28.hPadding,
      child: Text(
        widget.comment.comment,
        textAlign: TextAlign.start,
        style: AppStyles.styleInter12.copyWith(
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary.withAlpha(179),
        ),
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

  Widget _buildLikeButton() {
    return GestureDetector(
      onTap: _toggleLike,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            _isLiked ? AppIcons.iconsFilledLike : AppIcons.iconsUnfilledLike,
            height: 16.h,
            width: 16.w,
            colorFilter: _isLiked
                ? const ColorFilter.mode(AppColors.primaryDark, BlendMode.srcIn)
                : null,
          ),
          const SizedBox(width: 4),
          Text(
            '$_likeCount Likes',
            style: AppStyles.styleInter8.copyWith(
              color: AppColors.lightTextPrimary.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyButton() {
    return GestureDetector(
      onTap: _handleReply,
      child: Text(
        'Reply',
        style: AppStyles.styleInter8.copyWith(
          color: AppColors.primaryDark,
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
              color: AppColors.lightTextPrimary.withAlpha(179),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isHiding
                ? 'Hide Replies (${widget.comment.replies})'
                : 'View Replies (${widget.comment.replies})',
            style: AppStyles.styleInter8.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextPrimary.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNestedReplies() {
    return widget.comment.repliesList
        .map(
          (reply) => CommentItem(
            comment: reply,
            isReply: true,
            onReply: widget.onReply,
          ),
        )
        .toList();
  }

  bool get _shouldShowViewRepliesButton =>
      widget.comment.replies > 0 && !widget.isReply && !_showReplies;

  bool get _shouldShowReplies =>
      _showReplies && widget.comment.repliesList.isNotEmpty;
}
