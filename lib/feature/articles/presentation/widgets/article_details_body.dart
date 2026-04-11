import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:new_mama/feature/articles/presentation/widgets/article_content_section_widget.dart';
import 'package:new_mama/feature/articles/presentation/widgets/article_save_button_animated.dart';

class ArticleDetailsBody extends StatelessWidget {
  final ArticleModel article;

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
            article.overview,
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(height: 1.5),
          ),
          24.height,
          ...article.sections.map(
            (section) => ArticleContentSectionWidget(section: section),
          ),
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
            article.category,
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
          article.readTime,
          style: context.text.bodyLarge!.copyWith(
            color: context.ext.colors.greyPrimary,
          ),
        ),
      ],
    );
  }
}
