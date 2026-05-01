import 'package:flutter/material.dart';
import 'package:animate_to/animate_to.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/svg_color_mapper.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';

class CustomArticleCategoryItem extends StatelessWidget {
  final Article article;
  final AnimateToController? controller;
  final VoidCallback? onSave;

  const CustomArticleCategoryItem({
    super.key,
    required this.article,
    this.controller,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRoutesPaths.articleDetailsView, extra: article);
      },
      child: Container(
        width: double.infinity,
        // margin: 20.hPadding,
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: const Offset(0, 2),
              color: context.theme.colorScheme.onSurface.withAlpha(38),
              spreadRadius: 0,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                article.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200.h,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 200.h,
                  color: context.theme.colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            16.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                article.title,
                style: context.text.titleSmall!.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20,
                end: 20,
                bottom: 10,
              ),
              child: Row(
                spacing: 6.w,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      article.shortDescription,
                      style: context.text.bodySmall!,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      onSave?.call();
                      if (!article.isSaved && controller != null) {
                        controller!.animateTag('save_${article.articleId}');
                      }
                    },
                    child: controller != null
                        ? AnimateFrom(
                            key: controller!.tag('save_${article.articleId}'),
                            child: SvgPicture.asset(
                              article.isSaved
                                  ? AppIcons.iconsFilledSave
                                  : AppIcons.iconsUnfilledSave,
                              width: 18.w,
                              colorMapper: AppSvgColorMapper(
                                from: const Color(0xffFF3381),
                                to: context.ext.colors.primaryDark,
                              ),
                            ),
                          )
                        : SvgPicture.asset(
                            article.isSaved
                                ? AppIcons.iconsFilledSave
                                : AppIcons.iconsUnfilledSave,
                            width: 15.w,
                            colorMapper: AppSvgColorMapper(
                              from: const Color(0xffFF3381),
                              to: context.ext.colors.primaryDark,
                            ),
                          ),
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
