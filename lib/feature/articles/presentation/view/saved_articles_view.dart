import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/feature/articles/presentation/view_model/saved_articles/saved_articles_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view_model/saved_articles/saved_articles_state.dart';
import 'package:new_mama/feature/articles/presentation/widgets/articles_header.dart';
import 'package:new_mama/feature/articles/presentation/widgets/custom_article_category_item.dart';

class SavedArticlesView extends StatefulWidget {
  const SavedArticlesView({super.key});

  @override
  State<SavedArticlesView> createState() => _SavedArticlesViewState();
}

class _SavedArticlesViewState extends State<SavedArticlesView> {
  late AnimateToController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimateToController();
    context.read<SavedArticlesCubit>().loadSavedArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: ArticlesHeader(controller: _controller, showSaveIcon: false),
      body: BlocBuilder<SavedArticlesCubit, SavedArticlesState>(
        builder: (context, state) {
          if (state is SavedArticlesLoading) {
            return const Center(child: CustomLoadingIndicator());
          }

          if (state is SavedArticlesFailure) {
            return Center(child: Text(state.message));
          }

          if (state is SavedArticlesSuccess) {
            if (state.articles.isEmpty) {
              return Center(
                child: Text(
                  context.trContext(TK.articlesNoSaved),
                  style: context.text.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.onSurface,
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: 20.hPadding,
                  child: Text(
                    context.trContext(TK.articlesSaved),
                    style: context.text.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                  ),
                ),
                16.height,
                Expanded(
                  child: Padding(
                    padding: 20.hPadding,
                    child: ListView.separated(
                      clipBehavior: Clip.hardEdge,
                      padding: EdgeInsets.zero,
                      itemCount: state.articles.length,
                      separatorBuilder: (context, index) => 16.height,
                      itemBuilder: (context, index) =>
                          CustomArticleCategoryItem(
                            article: state.articles[index],
                            controller: _controller,
                            onSave: () => context
                                .read<SavedArticlesCubit>()
                                .toggleSave(state.articles[index].articleId),
                          ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
