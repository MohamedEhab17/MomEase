import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/articles/domain/entities/article_search_result.dart';
import 'package:new_mama/feature/articles/presentation/view_model/search_articles/search_articles_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view_model/search_articles/search_articles_state.dart';
import 'package:new_mama/feature/articles/presentation/widgets/article_category_card.dart';
import 'package:new_mama/feature/articles/presentation/widgets/custom_article_category_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ArticleSearchView extends StatefulWidget {
  const ArticleSearchView({super.key});

  @override
  State<ArticleSearchView> createState() => _ArticleSearchViewState();
}

class _ArticleSearchViewState extends State<ArticleSearchView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<SearchArticlesCubit>().loadSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String? value) {
    setState(() {}); // To show/hide clear button instantly
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchArticlesCubit>().searchArticles(value ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: context.ext.colors.primaryDark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr(TK.searchTitle),
          style: context.text.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: context.ext.colors.primaryDark,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: 20.hPadding,
            child: FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: TextFormFieldHelper(
                controller: _searchController,
                onChanged: _onSearchChanged,
                fillColor: context.theme.cardColor,
                borderColor: context.ext.colors.primaryLighter,
                borderRadius: BorderRadius.circular(64.r),
                hint: context.trContext(TK.articlesSearchHint),
                hintStyle: context.text.bodyLarge!.copyWith(
                  color: context.ext.colors.lightTextDisabled,
                ),
                prefixIcon: Padding(
                  padding: 12.allPadding,
                  child: SvgPicture.asset(
                    AppIcons.iconsSearch,
                    colorFilter: ColorFilter.mode(
                      Colors.grey[600]!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                suffixWidget: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[600]!,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                          context.read<SearchArticlesCubit>().searchArticles(
                            '',
                          );
                        },
                      )
                    : null,
              ),
            ),
          ),
          20.height,
          Expanded(
            child: BlocBuilder<SearchArticlesCubit, SearchArticlesState>(
              builder: (context, state) {
                if (state is SearchArticlesLoading) {
                  return _buildLoadingState();
                } else if (state is SearchArticlesSuccess) {
                  return _buildSuccessState(state.result);
                } else if (state is SearchArticlesHistory) {
                  return _buildHistoryState(state.history);
                } else if (state is SearchArticlesFailure) {
                  return _buildErrorState(state.message);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryState(List<String> history) {
    if (history.isEmpty) {
      return FadeIn(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.iconsSearch,
                width: 80.w,
                colorFilter: ColorFilter.mode(
                  context.ext.colors.primaryLighter,
                  BlendMode.srcIn,
                ),
              ),
              20.height,
              Text(
                context.trContext(TK.searchEmpty),
                // "Find what you're looking for",
                style: context.text.bodyLarge!.copyWith(
                  color: context.ext.colors.lightTextDisabled,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Padding(
        padding: 20.hPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    context.trContext(TK.recentSearches),
                 
                  style: context.text.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      context.read<SearchArticlesCubit>().clearHistory(),
                  child: Text(
                      context.trContext(TK.clearAll),
                   
                    style: TextStyle(color: context.ext.colors.primary),
                  ),
                ),
              ],
            ),
            10.height,
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: history
                  .map(
                    (query) => GestureDetector(
                      onTap: () {
                        _searchController.text = query;
                        context.read<SearchArticlesCubit>().searchArticles(
                          query,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: context.ext.colors.primaryLighter.withAlpha(
                            25,
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                            color: context.ext.colors.primaryLighter.withAlpha(
                              100,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.history,
                              size: 16.sp,
                              color: context.ext.colors.primary,
                            ),
                            8.width,
                            Text(query, style: context.text.bodyMedium),
                            8.width,
                            GestureDetector(
                              onTap: () {
                                context.read<SearchArticlesCubit>().removeFromHistory(query);
                              },
                              child: Icon(
                                Icons.close,
                                size: 14.sp,
                                color: context.ext.colors.greyPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: 20.hPadding,
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Container(
            height: 100.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState(ArticleSearchResult result) {
    if (result.articles.isEmpty && result.categories.isEmpty) {
      return FadeIn(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 80, color: Colors.grey),
              10.height,
              Text(
                context.trContext(TK.searchNoResults , namedArgs: {'query': _searchController.text}),
              //  "No results found for \"${_searchController.text}\"",
                style: context.text.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: 20.hPadding,
      children: [
        if (result.categories.isNotEmpty) ...[
          FadeInLeft(
            child: Text(
              "Categories (${result.categoriesCount})",
              style: context.text.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          15.height,
          SizedBox(
            height: 140.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: result.categories.length,
              separatorBuilder: (context, index) => 15.width,
              itemBuilder: (context, index) => FadeInRight(
                delay: Duration(milliseconds: 100 * index),
                child: SizedBox(
                  width: 280.w,
                  child: ArticleCategoryCard(
                    category: result.categories[index],
                    margin: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
          30.height,
        ],
        if (result.articles.isNotEmpty) ...[
          FadeInLeft(
            child: Text(
              "Articles (${result.articlesCount})",
              style: context.text.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          15.height,
          ...result.articles.map(
            (article) => FadeInUp(
              child: Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: CustomArticleCategoryItem(
                  article: article,
                  onSave: () => context.read<SearchArticlesCubit>().toggleSave(
                    article.articleId,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          10.height,
          Text(message, style: const TextStyle(color: Colors.red)),
          TextButton(
            onPressed: () => context.read<SearchArticlesCubit>().searchArticles(
              _searchController.text,
            ),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
