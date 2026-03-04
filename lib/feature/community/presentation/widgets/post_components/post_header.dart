import 'package:flutter/material.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
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
        CircleAvatar(radius: 25, backgroundImage: NetworkImage(post.userImage)),
        7.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.userName,
                style: AppStyles.styleInter12.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "1 day ago",
                style: AppStyles.styleInter10.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightTextPrimary.withAlpha(128),
                ),
              ),
            ],
          ),
        ),
        CustomOverlayMenu<String>(
          onItemSelected: (value) =>
              PostActionHandler.handleAction(context, value, post),
          items: const [
            OverlayMenuItem(
              icon: Icons.copy,
              text: "Copy link",
              value: "Copy link",
            ),
            OverlayMenuItem(icon: Icons.share, text: "Share", value: "Share"),
            OverlayMenuItem(
              icon: Icons.report,
              text: "Report",
              value: "Report",
            ),
            OverlayMenuItem(
              icon: Icons.bookmark_remove,
              text: "Remove from Saves",
              value: "Remove",
            ),
          ],
          builder: (context, showMenu) => IconButton(
            icon: const Icon(
              Icons.more_vert,
              size: 24,
              color: AppColors.lightTextPrimary,
            ),
            onPressed: showMenu,
          ),
        ),
      ],
    );
  }
}
