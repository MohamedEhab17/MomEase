import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';

class ArticlesCard extends StatelessWidget {
  const ArticlesCard({super.key, required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRoutesPaths.articleDetailsView, extra: article);
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
        width: 116.w,
        height: 114.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                article.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset(AppImages.imagesArticles, fit: BoxFit.cover),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.primary.withAlpha(80),
                    AppColors.lightTextPrimary.withAlpha(80),
                  ],
                ),
              ),
              child: Padding(
                padding: 8.allPadding,
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 4.h,
                  children: [
                    const Spacer(),
                    Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      article.title,
                      style: AppStyles.styleInter10.copyWith(
                        color: AppColors.lightBackground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 22.h,
                      child: CustomElevatedButton(
                        text: 'View full article',
                        textStyle: AppStyles.styleInter10.copyWith(
                          fontSize: 9.sp,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.5.h,
                        ),
                        backgroundColor: AppColors.lightBackground,
                        onPressed: () {
                          context.push(
                            AppRoutesPaths.articleDetailsView,
                            extra: article,
                          );
                        },
                        minimumSize: Size(69.w, 16.h),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
