import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/articles/presentation/view_model/article_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view_model/article_state.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ArticlesHeader(
        controller: _controller,
        showSaveIcon: false, // We are already in Saved view
      ),
      body: BlocBuilder<ArticleCubit, ArticleState>(
        builder: (context, state) {
          final savedArticles = state.articles.where((a) => a.isSaved).toList();

          if (savedArticles.isEmpty) {
            return Center(
              child: Text(
                'No saved articles yet.',
                style: AppStyles.styleInter16,
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: 20.hPadding,
                child: Text(
                  'Saved Articles',
                  style: AppStyles.styleInter20.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              16.height,
              Expanded(
                child: ListView.separated(
                  clipBehavior: Clip.hardEdge,
                  padding: EdgeInsets.zero,
                  itemCount: savedArticles.length,
                  separatorBuilder: (context, index) => 16.height,
                  itemBuilder: (context, index) => CustomArticleCategoryItem(
                    article: savedArticles[index],
                    controller: _controller,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
