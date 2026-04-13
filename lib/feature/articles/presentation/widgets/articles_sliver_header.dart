import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ArticlesSliverHeader extends StatelessWidget {
  final ArticleModel article;

  const ArticlesSliverHeader({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leadingWidth: 50.w,

      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 20, top: 24),
        child: CircleAvatar(
          backgroundColor: context.colors.onSurface,
          child: Transform.translate(
            offset: const Offset(-4, -1),
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: context.ext.colors.primaryDark,
                size: 20.sp,
              ),
            ),
          ),
        ),
      ),
      expandedHeight: 250.h,
      pinned: true,
      flexibleSpace: Stack(
        clipBehavior: Clip.none,

        children: [
          Image.network(
            article.imageUrl,
            width: double.infinity,
            height: 250.h,
            fit: BoxFit.cover,
          ),
          PositionedDirectional(
            bottom: 16,
            start: 30,
            end: 28,
            child: Text(
              article.title,
              style: context.text.headlineMedium!.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
