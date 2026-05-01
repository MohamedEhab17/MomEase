import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/feature/articles/presentation/view_model/category_articles/category_articles_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view_model/category_articles/category_articles_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/articles/presentation/widgets/articles_header.dart';
import 'package:new_mama/feature/articles/presentation/widgets/custom_article_category_item.dart';

class ArticlesView extends StatefulWidget {
  final int categoryId;
  const ArticlesView({super.key, required this.categoryId});

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  late AnimateToController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimateToController();
    context.read<CategoryArticlesCubit>().loadArticles(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ArticlesHeader(controller: _controller),
      body: Column(
        children: [
          Padding(
            padding: 20.hPadding,
            child: GestureDetector(
              onTap: () => context.push(AppRoutesPaths.articleSearchView),
              child: AbsorbPointer(
                child: TextFormFieldHelper(
                  fillColor: context.theme.cardColor,
                  borderColor: context.ext.colors.primaryLighter,
                  borderRadius: BorderRadius.circular(64.r),
                  hint: context.trContext(TK.articlesSearchHint),
                  hintStyle: context.text.bodyLarge!.copyWith(
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
          20.height,
          Expanded(
            child: BlocBuilder<CategoryArticlesCubit, CategoryArticlesState>(
              builder: (context, state) {
                if (state is CategoryArticlesLoading) {
                  return const Center(child: CustomLoadingIndicator());
                }
                if (state is CategoryArticlesFailure) {
                  return Center(child: Text(state.message));
                }
                if (state is CategoryArticlesSuccess) {
                  if (state.articles.isEmpty) {
                    return Center(
                      child: Text(context.trContext(TK.articlesEmpty)),
                    );
                  }
                  return Padding(
                     padding: 20.hPadding,
                    child: ListView.separated(
                      
                      itemCount: state.articles.length,
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, index) => 20.height,
                      itemBuilder: (context, index) => CustomArticleCategoryItem(
                        article: state.articles[index],
                        
                        controller: _controller,
                        onSave: () => context
                            .read<CategoryArticlesCubit>()
                            .toggleSave(state.articles[index].articleId),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
