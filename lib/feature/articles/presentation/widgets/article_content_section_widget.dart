import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ArticleContentSectionWidget extends StatelessWidget {
  final ArticleSection section;

  const ArticleContentSectionWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.heading != null) ...[
            Text(
              section.heading!,
              style: context.text.titleMedium!.copyWith(fontWeight: .w600),
            ),
            12.height,
          ],
          if (section.content != null) ...[
            MarkdownBody(
              data: section.content!,
              styleSheet: MarkdownStyleSheet(
                p: context.text.titleSmall!.copyWith(
                  height: 1.5,
                  color: context.colors.onSurface.withAlpha(230),
                ),
                strong: context.text.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.onSurface,
                ),
              ),
            ),
            if (section.bulletPoints != null &&
                section.bulletPoints!.isNotEmpty)
              12.height,
          ],
          if (section.bulletPoints != null) ...[
            ...section.bulletPoints!.map(
              (point) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      '• ',
                      style: context.text.titleSmall!.copyWith(
                        fontWeight: .bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: context.text.titleSmall!.copyWith(
                          height: 1.4,
                          color: context.colors.onSurface.withAlpha(230),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
