import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
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
              style: AppStyles.styleInter16.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            12.height,
          ],
          if (section.content != null) ...[
            MarkdownBody(
              data: section.content!,
              styleSheet: MarkdownStyleSheet(
                p: AppStyles.styleInter14.copyWith(
                  height: 1.5,
                  color: AppColors.lightTextPrimary.withOpacity(0.9),
                ),
                strong: AppStyles.styleInter14.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightTextPrimary,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: AppStyles.styleInter14.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: AppStyles.styleInter14.copyWith(
                          height: 1.4,
                          color: AppColors.lightTextPrimary.withOpacity(0.9),
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
