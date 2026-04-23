import 'package:flutter/material.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/feature/home/presentation/widgets/articles_card.dart';
import 'package:new_mama/feature/home/presentation/widgets/custom_quick_access_card.dart';
import 'package:new_mama/feature/home/presentation/widgets/depression_test_widget.dart';
import 'package:new_mama/feature/articles/dummy/article_dummy_data.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${context.trContext(TK.homeWelcome)} Rawan!",
            style: context.text.displayMedium!,
          ),
          4.height,
          Text(
            context.trContext(TK.homeOfferingHelp),
            style: context.text.titleMedium!.copyWith(
              color: context.ext.colors.lightTextPrimary.withValues(alpha: 178),
            ),
          ),
          20.height,
          DepressionTestWidget(),
          32.height,
          Text(
            context.trContext(TK.homeQuickAccessSection),
            style: context.text.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          12.height,
          CustomQuickAccessCard(
            leadingIcon: AppIcons.iconsSound,
            title: context.trContext(TK.homeQuickAccessCryTitle),
            subtitle: context.trContext(TK.homeQuickAccessCrySubtitle),
            showTrailing: true,

            onTap: () {
              context.push(AppRoutesPaths.cryingInsightView);
            },
          ),
          8.height,
          CustomQuickAccessCard(
            leadingIcon: AppIcons.iconsSkin,
            title: context.trContext(TK.homeQuickAccessSkinTitle),
            subtitle: context.trContext(TK.homeQuickAccessSkinSubtitle),
            showTrailing: true,

            onTap: () {
              context.push(AppRoutesPaths.skinDiagnosisInsightView);
            },
          ),
          8.height,
          CustomQuickAccessCard(
            leadingIcon: AppIcons.iconsBabyTracing,
            title: context.trContext(TK.homeQuickAccessTrackingTitle),
            subtitle: context.trContext(TK.homeQuickAccessTrackingSubtitle),
            showTrailing: true,
            onTap: () {
              context.push(AppRoutesPaths.babyTrackView);
            },
          ),
          24.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  context.trContext(TK.homeUsefulArticles),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              TextButton(
                onPressed: () {
                  context.push(AppRoutesPaths.articleCategoryView);
                },
                child: Text(
                  context.trContext(TK.commonViewAll),
                  style: context.text.bodyMedium!.copyWith(
                    color: context.ext.colors.primaryDark,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 114.h,
            child: ListView.separated(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: dummyArticles.length,
              separatorBuilder: (context, index) => 16.width,
              itemBuilder: (context, index) {
                return ArticlesCard(article: dummyArticles[index]);
              },
            ),
          ),
          32.height,
        ],
      ),
    );
  }
}
