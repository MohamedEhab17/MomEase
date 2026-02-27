import 'package:flutter/material.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;

  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
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

        const Icon(
          Icons.more_vert,
          size: 24,
          color: AppColors.lightTextPrimary,
        ),
      ],
    );
  }
}
