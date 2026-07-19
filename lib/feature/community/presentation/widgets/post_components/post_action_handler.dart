import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/delete_confirmation_dialog.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/widgets/report_post_components/report_post_dialog.dart';
import 'package:share_plus/share_plus.dart';

class PostActionHandler {
  static void handleAction(
    BuildContext context,
    String action,
    PostModel post,
  ) {
    switch (action) {
      case 'Report':
        showDialog(
          context: context,
          builder: (_) => BlocProvider.value(
            value: context.read<CommunityCubit>(),
            child: ReportPostDialog(postId: post.postId),
          ),
        );
        break;
      case 'Remove':
        showDialog<bool>(
          context: context,
          builder: (context) => DeleteConfirmationDialog(
            title: context.trContext(TK.communityDeletePostTitle),
            content: context.trContext(TK.communityDeletePostContent),
          ),
        ).then((confirm) {
          if (confirm == true) {
            context.read<CommunityCubit>().deletePost(post.postId);
          }
        });
        break;
      case 'Copy link':
        final postLink = "https://momease.runasp.net/posts/${post.postId}";
        Clipboard.setData(ClipboardData(text: postLink));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.trContext(TK.communityLinkCopied))),
        );
        break;
      case 'Share':
        final postLink = "https://momease.runasp.net/posts/${post.postId}";
        final shareText = "${post.userName} shared a post on MomEase:\n\n\"${post.text}\"\n\n${context.isAr ? 'اقرأ المزيد وتفاعل عبر الرابط:' : 'Read more and interact via link:'}\n$postLink";
        Share.share(shareText, subject: 'MomEase Post from ${post.userName}');
        break;
    }
  }
}
