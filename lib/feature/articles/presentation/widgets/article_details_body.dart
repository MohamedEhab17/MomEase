import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:new_mama/feature/articles/presentation/widgets/article_content_section_widget.dart';
import 'package:new_mama/feature/articles/presentation/widgets/article_save_button_animated.dart';

class ArticleDetailsBody extends StatelessWidget {
  final ArticleModel article;

  const ArticleDetailsBody({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 132,
            offset: const Offset(0, -72),
            color: AppColors.lightTextPrimary.withAlpha(63),
            spreadRadius: 0,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          16.height,
          Text(article.overview, style: AppStyles.styleInter14),
          24.height,
          ...article.sections.map(
            (section) => ArticleContentSectionWidget(section: section),
          ),
          76.height,
          ArticleSaveButtonAnimated(articleId: article.id),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            article.title,
            style: AppStyles.styleInter16.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        8.width,
        SvgPicture.asset(AppIcons.iconsClock, width: 22.w, height: 22.h),
        4.width,
        Text(
          article.readTime,
          style: AppStyles.styleInter12.copyWith(
            color: const Color(0xff808080),
          ),
        ),
      ],
    );
  }
}
