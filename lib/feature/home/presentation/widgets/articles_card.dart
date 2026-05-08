import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_images.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';
import 'package:flutter/material.dart';
import "package:new_mama/core/localization/translation_keys.dart";
import 'package:new_mama/core/widgets/custom_network_image.dart';

class ArticlesCard extends StatelessWidget {
  const ArticlesCard({super.key, required this.article});

  final Article article;

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
              child: CustomNetworkImage(
                imageUrl: article.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) =>

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
                    context.colors.primary.withAlpha(80),
                    context.colors.onSurface.withAlpha(80),
                  ],
                ),
              ),
              child: Padding(
                padding: 8.allPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: [
                    const Spacer(),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall!.copyWith(
                        color: context.theme.buttonTheme.colorScheme!.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CustomElevatedButton(
                      text: context.trContext(TK.homeViewAllArticle),
                      textStyle: context.text.labelSmall!.copyWith(
                        color:
                            context.theme.buttonTheme.colorScheme!.onSecondary,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.5.h,
                      ),
                      backgroundColor:
                          context.theme.buttonTheme.colorScheme!.secondary,
                      onPressed: () {
                        context.push(
                          AppRoutesPaths.articleDetailsView,
                          extra: article,
                        );
                      },
                      minimumSize: Size(double.infinity, 16.h),
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
