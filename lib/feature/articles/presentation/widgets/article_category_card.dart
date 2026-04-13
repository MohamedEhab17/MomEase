import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';

class ArticleCategoryCard extends StatelessWidget {
  final ArticleModel article;
  const ArticleCategoryCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutesPaths.articlesView, extra: article),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        margin: 20.hPadding,
        width: double.infinity,
        height: 128.h,
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 2),
              color: context.colors.onSurface.withAlpha(38),
              spreadRadius: 0,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Row(
          spacing: 10,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                article.imageUrl,
                fit: BoxFit.cover,
                width: 100.w,
                height: 100.h,
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 6.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: context.text.bodyMedium!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    article.overview,
                    style: context.text.bodySmall!.copyWith(
                      color: context.colors.onSurface.withAlpha(179),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
