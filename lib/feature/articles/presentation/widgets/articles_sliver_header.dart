import 'package:flutter/material.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class ArticlesSliverHeader extends StatelessWidget {
  final ArticleModel article;

  const ArticlesSliverHeader({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leadingWidth: 50.w,

      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20, top: 24),
        child: CircleAvatar(
          backgroundColor: AppColors.darkTextPrimary,
          child: Transform.translate(
            offset: const Offset(-4, -1),
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.primaryDark,
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
          Positioned(
            bottom: 16,
            left: 30,
            right: 28,
            child: Text(
              article.title,
              style: AppStyles.styleInter20.copyWith(
                color: AppColors.darkTextPrimary,
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
