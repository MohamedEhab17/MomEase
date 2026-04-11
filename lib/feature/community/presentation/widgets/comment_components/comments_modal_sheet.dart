import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/community/data/models/comment_model.dart';
import 'package:new_mama/feature/community/dummy/dummy_comment.dart';
import 'package:new_mama/feature/community/presentation/widgets/comment_components/chat_input_bar.dart';
import 'package:new_mama/feature/community/presentation/widgets/comment_components/comment_item.dart';
import 'package:new_mama/feature/community/presentation/widgets/comment_components/mention_text_controller.dart';

/// A modal bottom sheet that displays comments for a post with
/// reply functionality and mention support.
class CommentsModalSheet extends StatefulWidget {
  final String postId;
  final int initialCommentCount;

  const CommentsModalSheet({
    super.key,
    required this.postId,
    required this.initialCommentCount,
  });

  @override
  State<CommentsModalSheet> createState() => _CommentsModalSheetState();
}

class _CommentsModalSheetState extends State<CommentsModalSheet> {
  late MentionTextEditingController _commentController;
  final FocusNode _focusNode = FocusNode();
  late List<CommentModel> _comments;

  CommentModel? _replyingTo;
  String? _replyingToParentId;

  @override
  void initState() {
    super.initState();
    _commentController = MentionTextEditingController();
    _comments = List.from(dummyComments);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleReply(CommentModel comment, {String? parentId}) {
    _recreateControllerWithMention(comment.name);

    setState(() {
      _replyingTo = comment;
      _replyingToParentId = parentId;
      _commentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentController.text.length),
      );
    });

    _focusKeyboard();
  }

  void _cancelReply() {
    _recreateControllerWithoutMention();

    setState(() {
      _replyingTo = null;
      _replyingToParentId = null;
    });

    _focusNode.unfocus();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    final newComment = CommentModel(
      profileUrl: 'https://i.pravatar.cc/150?img=50',
      name: 'You',
      timeAgo: 'Just now',
      comment: _commentController.text.trim(),
      likes: 0,
    );

    setState(() {
      if (_replyingTo != null) {
        _addReplyToComment(newComment);
      } else {
        _comments.insert(0, newComment);
      }
    });

    _clearCommentInput();
  }

  void _addReplyToComment(CommentModel reply) {
    for (int i = 0; i < _comments.length; i++) {
      final shouldAddToThisComment = _replyingToParentId != null
          ? _comments[i].name == _replyingToParentId
          : _comments[i].name == _replyingTo!.name &&
                _comments[i].timeAgo == _replyingTo!.timeAgo;

      if (shouldAddToThisComment) {
        _comments[i] = _comments[i].copyWith(
          repliesList: [..._comments[i].repliesList, reply],
        );
        return;
      }
    }
  }

  void _clearCommentInput() {
    _commentController.clear();
    _focusNode.unfocus();
    _recreateControllerWithoutMention();

    setState(() {
      _replyingTo = null;
      _replyingToParentId = null;
    });
  }

  void _recreateControllerWithMention(String mentionedName) {
    _commentController.dispose();
    _commentController = MentionTextEditingController(
      mentionedName: mentionedName,
      text: '@$mentionedName ',
    );
  }

  void _recreateControllerWithoutMention() {
    _commentController.dispose();
    _commentController = MentionTextEditingController();
  }

  void _focusKeyboard() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: viewInsets.bottom.bottomPadding,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: context.ext.colors.primaryExtraLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            _buildModalHandle(),
            _buildHeader(),
            12.height,
            _buildCommentsList(),
            if (_replyingTo != null) _buildReplyIndicator(),
            _buildCommentInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildModalHandle() {
    return Column(
      children: [
        22.height,
        Container(
          width: 124.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: context.ext.colors.primaryDark,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        22.height,
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: 20.hPadding,
      child: Row(
        children: [
          Text('Comments', style: context.text.displaySmall!),
          const Spacer(),
          Text(
            '${_comments.length}',
            style: context.text.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colors.onSurface.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    return Expanded(
      child: _comments.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return CommentItem(
                  comment: _comments[index],
                  onReply: (comment) =>
                      _handleReply(comment, parentId: _comments[index].name),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No comments yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: context.ext.colors.greyMedium,
            ),
          ),
          8.height,
          Text(
            'Be the first to comment!',
            style: TextStyle(
              fontSize: 14,
              color: context.ext.colors.greyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: context.ext.colors.primaryBackground,
        border: Border(
          top: BorderSide(color: context.ext.colors.primaryLighter, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.reply, size: 16, color: context.ext.colors.primaryDark),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Replying to ${_replyingTo!.name}',
              style: context.text.bodyLarge!.copyWith(
                color: context.ext.colors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: _cancelReply,
            child: Icon(
              Icons.close,
              size: 18,
              color: context.ext.colors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: ChatInputBar(
        isProcessing: false,
        controller: _commentController,
        onSend: _addComment,
      ),
    );
  }
}
