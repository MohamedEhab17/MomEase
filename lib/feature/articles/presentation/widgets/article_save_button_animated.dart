import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/widgets/custom_animated_button.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:new_mama/feature/articles/presentation/view_model/article_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view_model/article_state.dart';

class ArticleSaveButtonAnimated extends StatelessWidget {
  final ArticleModel article;

  const ArticleSaveButtonAnimated({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCubit, ArticleState>(
      builder: (context, state) {
        final currentArticle = state.articles.firstWhere(
          (a) => a.id == article.id,
          orElse: () => article,
        );

        return CustomAnimatedButton(
          text: currentArticle.isSaved ? "Saved" : "Save Article",
          minimumSize: Size(double.infinity, 52.h),
          onPressed: () {
            context.read<ArticleCubit>().toggleSaveArticle(article.id);
          },
          textStyle: context.text.titleLarge!.copyWith(
            color: currentArticle.isSaved
                ? context.theme.buttonTheme.colorScheme!.onPrimary
                : context.theme.buttonTheme.colorScheme!.onPrimary,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: currentArticle.isSaved
              ? context.ext.colors.primaryLighter
              : context.theme.buttonTheme.colorScheme!.primary,
        );
      },
    );
  }
}
