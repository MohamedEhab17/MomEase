import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/articles/presentation/view_model/categories_cubit/category_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view_model/categories_cubit/category_state.dart';
import 'package:new_mama/feature/articles/presentation/widgets/article_category_card.dart';
import 'package:new_mama/feature/articles/presentation/widgets/articles_header.dart';

import '../../../../core/routers/app_router_paths.dart';

class ArticleCategoryView extends StatelessWidget {
  const ArticleCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: ArticlesHeader(),
      body: Column(
        children: [
          Padding(
            padding: 20.hPadding,
            child: GestureDetector(
              onTap: () => context.push(AppRoutesPaths.articleSearchView),
              child: AbsorbPointer(
                child: TextFormFieldHelper(
                  fillColor: context.theme.cardColor,
                  borderColor: context.theme.buttonTheme.colorScheme!.primary,
                  borderRadius: BorderRadius.circular(64.r),
                  hint: context.trContext(TK.articlesSearchHint),
                  hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: context.ext.colors.lightTextDisabled,
                      ),
                  suffixWidget: SizedBox(
                    width: 60.w,
                    height: 40.h,
                    child: Center(
                      child: SvgPicture.asset(
                        AppIcons.iconsSearch,
                        width: 20.w,
                        height: 20.h,
                        colorFilter: ColorFilter.mode(
                          context.ext.colors.greyPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          28.height,
          Expanded(
            child: BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                if (state is CategoryError) {
                  return Center(child: Text(state.message));
                  // return Center(child: Text(context.trContext(TK.articlesEmpty)));
                }

                if (state is CategoryLoaded) {
                  if (state.categories.isEmpty) {
                    return Center(
                      child: Text(context.trContext(TK.articlesEmpty)),
                    );
                  }
                  return ListView.separated(
                    clipBehavior: Clip.hardEdge,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) =>
                        ArticleCategoryCard(category: state.categories[index]),
                    itemCount: state.categories.length,
                    separatorBuilder: (context, index) => 16.height,
                  );
                }
                return const Center(child: CustomLoadingIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
