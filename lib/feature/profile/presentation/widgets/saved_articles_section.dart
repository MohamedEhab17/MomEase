import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:new_mama/feature/profile/presentation/widgets/profile_article_preview_card.dart';

class SavedArticlesSection extends StatelessWidget {
  final List<ArticleModel> articles;

  const SavedArticlesSection({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 240.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: articles.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          return ProfileArticlePreviewCard(article: articles[index]);
        },
      ),
    );
  }
}
