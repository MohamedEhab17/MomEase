import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';
import 'package:new_mama/feature/articles/presentation/widgets/article_save_button_animated.dart';

class ArticleDetailsBody extends StatelessWidget {
  final Article article;

  const ArticleDetailsBody({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          16.height,
          Text(
            article.shortDescription,
            style: context.text.titleSmall!.copyWith(
              height: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (article.content != null && article.content!.isNotEmpty) ...[
            24.height,
            MarkdownBody(
              data: article.content!,
              styleSheet: MarkdownStyleSheet(
                p: context.text.titleMedium!.copyWith(
                  height: 1.6,
                  color: context.colors.onSurface.withAlpha(230),
                ),
                strong: context.text.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.onSurface,
                ),
              ),
            ),
          ],
          if (article.sourceName != null && article.sourceName!.isNotEmpty) ...[
            24.height,
            Text(
              'Source: ${article.sourceName}',
              style: context.text.bodySmall!.copyWith(
                color: context.ext.colors.greyPrimary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          40.height,
          ArticleSaveButtonAnimated(article: article),
          40.height,
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            article.categoryName,
            style: context.text.titleMedium!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        8.width,
        SvgPicture.asset(
          AppIcons.iconsClock,
          width: 14.w,
          height: 14.h,
          colorFilter: ColorFilter.mode(
            context.ext.colors.greyPrimary,
            BlendMode.srcIn,
          ),
        ),
        4.width,
        Text(
          context.tr(
            TK.articleReadMinutes,
            namedArgs: 
             { 'minutes': article.readingTimeMinutes.toString() },
          ),
          //'${article.readingTimeMinutes} min read',
          style: context.text.bodyLarge!.copyWith(
            color: context.ext.colors.greyPrimary,
          ),
        ),
      ],
    );
  }
}
