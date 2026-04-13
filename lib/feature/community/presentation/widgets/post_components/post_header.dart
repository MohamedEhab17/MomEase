import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_overlay_menu.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_action_handler.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;

  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 25, 
          backgroundImage: post.userImage.isNotEmpty ? NetworkImage(post.userImage) : null,
        ),
        7.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.userName,
                style: context.text.titleSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colors.onSurface,
                ),
              ),
              Text(
                context.trContext(TK.communityJustNow),
                style: context.text.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                  color: context.ext.colors.lightTextDisabled,
                ),
              ),
            ],
          ),
        ),
        CustomOverlayMenu<String>(
          onItemSelected: (value) =>
              PostActionHandler.handleAction(context, value, post),
          items: [
            OverlayMenuItem(
              icon: Icons.copy,
              text: context.trContext(TK.communityCopyLink),
              value: "Copy link",
            ),
            OverlayMenuItem(
              icon: Icons.share,
              text: context.trContext(TK.communityShare),
              value: "Share",
            ),
            OverlayMenuItem(
              icon: Icons.report,
              text: context.trContext(TK.communityReportPost),
              value: "Report",
            ),
            OverlayMenuItem(
              icon: Icons.bookmark_remove,
              text: context.trContext(TK.communityRemovePost),
              value: "Remove",
            ),
          ],
          builder: (context, showMenu) => IconButton(
            icon: Icon(
              Icons.more_vert,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: showMenu,
          ),
        ),
      ],
    );
  }
}
