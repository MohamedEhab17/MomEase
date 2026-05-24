import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/extensions/string_ex.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_image_grid.dart';

class PostBody extends StatelessWidget {
  final PostModel post;

  const PostBody({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = post.text.isArabic;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: SelectableText(
            post.text,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: context.text.bodyLarge!.copyWith(
              fontWeight: FontWeight.w400,
              color: context.colors.onSurface,
              fontSize: 16.sp,
              height: 1.4,
            ),
          ),
        ),
        if (post.media.isNotEmpty) ...[
          const SizedBox(height: 12),
          PostImageGrid(media: post.media),
        ],
      ],
    );
  }
}
