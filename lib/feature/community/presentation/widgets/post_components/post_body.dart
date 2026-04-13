import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_image_grid.dart';
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
          trimLines: post.images.isNotEmpty ? 2 : 10,
          trimMode: TrimMode.Line,
          trimCollapsedText: isArabic ? ' عرض المزيد' : ' See more',
          trimExpandedText: isArabic ? ' عرض أقل' : ' Show less',

          style: context.text.titleLarge!.copyWith(
            fontWeight: FontWeight.w400,
            color: context.colors.onSurface.withAlpha(179),
          ),

          moreStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
          colorClickableText: Theme.of(context).colorScheme.primary,

          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        ),

        if (post.images.isNotEmpty) ...[
          const SizedBox(height: 14),
          PostImageGrid(images: post.images),
        ],
      ],
    );
  }
}
