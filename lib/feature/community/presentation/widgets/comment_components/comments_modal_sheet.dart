import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/community/data/models/comment_model.dart';
import 'package:new_mama/feature/community/data/models/reply_model.dart';
import 'package:new_mama/feature/community/presentation/view_model/comments_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/comments_state.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/widgets/comment_components/chat_input_bar.dart';
import 'package:new_mama/feature/community/presentation/widgets/comment_components/comment_item.dart';
import 'package:new_mama/feature/community/presentation/widgets/comment_components/mention_text_controller.dart';

class CommentsModalSheet extends StatelessWidget {
  final String postId;
  final int postUserId;
  final int initialCommentCount;

  const CommentsModalSheet({
    super.key,
    required this.postId,
    required this.postUserId,
    required this.initialCommentCount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CommentsCubit>()..loadComments(int.parse(postId)),
      child: _CommentsModalSheetBody(
        postId: postId,
        postUserId: postUserId,
        initialCommentCount: initialCommentCount,
      ),
    );
  }
}

class _CommentsModalSheetBody extends StatefulWidget {
  final String postId;
  final int postUserId;
  final int initialCommentCount;

  const _CommentsModalSheetBody({
    required this.postId,
    required this.postUserId,
    required this.initialCommentCount,
  });

  @override
  State<_CommentsModalSheetBody> createState() =>
      _CommentsModalSheetBodyState();
}

class _CommentsModalSheetBodyState extends State<_CommentsModalSheetBody> {
  late MentionTextEditingController _commentController;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  CommentModel? _replyingTo;
  CommentModel? _editingComment;
  ReplyModel? _editingReply;
  int? _editingReplyCommentId;

  @override
  void initState() {
    super.initState();
    _commentController = MentionTextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleReply(CommentModel comment) {
    _recreateControllerWithMention(comment.userName);

    setState(() {
      _replyingTo = comment;
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
    });

    _focusNode.unfocus();
  }

  void _handleEdit(CommentModel comment) {
    _cancelReply();
    _cancelEdit();
    setState(() {
      _editingComment = comment;
    });
    _recreateControllerWithoutMention();
    _commentController.text = comment.text;
    _focusKeyboard();
  }

  void _handleEditReply(ReplyModel reply, int commentId) {
    _cancelReply();
    _cancelEdit();
    setState(() {
      _editingReply = reply;
      _editingReplyCommentId = commentId;
    });
    _recreateControllerWithoutMention();
    _commentController.text = reply.text;
    _focusKeyboard();
  }

  void _cancelEdit() {
    setState(() {
      _editingComment = null;
      _editingReply = null;
      _editingReplyCommentId = null;
    });
    _commentController.clear();
    _focusNode.unfocus();
  }

  Future<void> _submitAction() async {
    final rawText = _commentController.text.trim();
    if (rawText.isEmpty) return;

    final postIdInt = int.parse(widget.postId);
    final cubit = context.read<CommentsCubit>();

    final replyTarget = _replyingTo;
    final editingCommentTarget = _editingComment;
    final editingReplyTarget = _editingReply;
    final editingReplyCommentId = _editingReplyCommentId;

    String textToSubmit = rawText;

    // Strip the mention prefix if it exists for replies
    if (replyTarget != null) {
      final mentionPrefix = '@${replyTarget.userName}';
      if (rawText.startsWith(mentionPrefix)) {
        textToSubmit = rawText.substring(mentionPrefix.length).trim();
      }
    }

    if (textToSubmit.isEmpty) return;

    // Clear input optimistically to make it feel fast
    _clearCommentInput();

    if (editingCommentTarget != null) {
      await cubit.updateComment(
        postIdInt,
        editingCommentTarget.commentId,
        textToSubmit,
      );
    } else if (editingReplyTarget != null && editingReplyCommentId != null) {
      await cubit.updateReply(
        postIdInt,
        editingReplyCommentId,
        editingReplyTarget.replyId,
        textToSubmit,
      );
    } else if (replyTarget != null) {
      await cubit.addReply(postIdInt, replyTarget.commentId, textToSubmit);
    } else {
      final success = await cubit.addComment(postIdInt, textToSubmit);
      if (success && mounted) {
        context.read<CommunityCubit>().incrementCommentCount(postIdInt);
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }
  }

  void _clearCommentInput() {
    _commentController.clear();
    _focusNode.unfocus();
    _recreateControllerWithoutMention();
    setState(() {
      _replyingTo = null;
      _editingComment = null;
      _editingReply = null;
      _editingReplyCommentId = null;
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
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: BoxDecoration(
          // color: context.ext.colors.primaryExtraLight,
          color: context.theme.cardColor,
          borderRadius: const BorderRadius.only(
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
            if (_editingComment != null || _editingReply != null)
              _buildEditIndicator(),
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
    return BlocBuilder<CommentsCubit, CommentsState>(
      builder: (context, state) {
        // Fallback to initial count if not loaded yet, otherwise use real count
        final displayCount = state.status == CommentsStatus.success
            ? state.comments.length
            : widget.initialCommentCount;

        return Container(
          padding: 20.hPadding,
          child: Row(
            children: [
              Text(
                context.trContext(TK.communityComments),
                style: context.text.displaySmall!,
              ),
              const Spacer(),
              Text(
                '$displayCount',
                style: context.text.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface.withAlpha(179),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentsList() {
    return Expanded(
      child: BlocBuilder<CommentsCubit, CommentsState>(
        builder: (context, state) {
          if (state.status == CommentsStatus.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: context.ext.colors.primaryDark,
              ),
            );
          }

          if (state.status == CommentsStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Error loading comments',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (state.comments.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: state.comments.length,
            itemBuilder: (context, index) {
              return CommentItem(
                comment: state.comments[index],
                postUserId: widget.postUserId,
                onReply: _handleReply,
                onEdit: _handleEdit,
                onEditReply: _handleEditReply,
              );
            },
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
            context.isAr ? 'لا توجد تعليقات بعد' : 'No comments yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: context.ext.colors.greyMedium,
            ),
          ),
          8.height,
          Text(
            context.isAr ? 'كن أول من يعلق!' : 'Be the first to comment!',
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
              context.isAr
                  ? 'الرد على ${_replyingTo!.userName}'
                  : 'Replying to ${_replyingTo!.userName}',
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

  Widget _buildEditIndicator() {
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
          Icon(Icons.edit, size: 16, color: context.ext.colors.primaryDark),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              context.isAr
                  ? (_editingComment != null ? 'تعديل التعليق' : 'تعديل الرد')
                  : (_editingComment != null
                        ? 'Editing comment'
                        : 'Editing reply'),
              style: context.text.bodyLarge!.copyWith(
                color: context.ext.colors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: _cancelEdit,
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
      padding: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 20),
      child: BlocBuilder<CommentsCubit, CommentsState>(
        builder: (context, state) {
          return ChatInputBar(
            isProcessing: state.isSubmitting,
            controller: _commentController,
            onSend: _submitAction,
          );
        },
      ),
    );
  }
}
