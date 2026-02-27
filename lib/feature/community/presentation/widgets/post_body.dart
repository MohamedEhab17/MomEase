import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:readmore/readmore.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';

class PostBody extends StatelessWidget {
  final PostModel post;

  const PostBody({super.key, required this.post});

  bool _isArabic(String text) {
    final arabic = RegExp(r'^[\u0600-\u06FF]');
    return arabic.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _isArabic(post.text);

    return Column(
      crossAxisAlignment: isArabic
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        ReadMoreText(
          post.text,
          trimLines: post.image != null ? 2 : 10,
          trimMode: TrimMode.Line,
          trimCollapsedText: isArabic ? ' عرض المزيد' : ' See more',
          trimExpandedText: isArabic ? ' عرض أقل' : ' Show less',

          style: AppStyles.styleInter16.copyWith(
            fontWeight: FontWeight.w400,
            color: AppColors.lightTextPrimary.withAlpha(179),
          ),

          moreStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          colorClickableText: AppColors.primary,

          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        ),

        if (post.image != null) ...[
          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: post.image!,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (_, _) => const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
