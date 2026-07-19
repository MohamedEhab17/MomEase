import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/feature/articles/domain/entities/article_category.dart';

class ArticleCategoryCard extends StatelessWidget {
  final ArticleCategory category;
  final EdgeInsetsGeometry? margin;
  const ArticleCategoryCard({super.key, required this.category, this.margin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutesPaths.articlesView, extra: category),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        margin: margin ?? 20.hPadding,
        width: double.infinity,
        height: 128.h,
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: const Offset(0, 2),
              color: context.colors.onSurface.withAlpha(38),
              spreadRadius: 0,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                category.image,
                fit: BoxFit.cover,
                width: 100.w,
                height: 100.h,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100.w,
                    height: 100.h,
                    color: context.colors.surfaceContainerHighest,
                    child: Icon(Icons.image_not_supported,
                        color: context.colors.onSurfaceVariant),
                  );
                },
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: context.text.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    category.description,
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
