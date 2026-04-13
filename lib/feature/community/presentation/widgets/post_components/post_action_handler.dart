import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';

import 'package:new_mama/feature/community/presentation/widgets/report_post_components/report_post_dialog.dart';

class PostActionHandler {
  static void handleAction(
    BuildContext context,
    String action,
    PostModel post,
  ) {
    switch (action) {
      case 'Report':
        showDialog(context: context, builder: (_) => const ReportPostDialog());
        break;
      case 'Remove':
        context.read<CommunityCubit>().deletePost(post.id);
        break;
      case 'Copy link':
        Clipboard.setData(ClipboardData(text: post.text));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.trContext(TK.communityLinkCopied))),
        );
        break;
      case 'Share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.trContext(TK.communityShareSoon))),
        );
        break;
    }
  }
}
