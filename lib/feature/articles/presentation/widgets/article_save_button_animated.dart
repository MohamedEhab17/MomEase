import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_animated_button.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';
import 'package:new_mama/feature/articles/presentation/view_model/article_detail/article_detail_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view_model/article_detail/article_detail_state.dart';

class ArticleSaveButtonAnimated extends StatelessWidget {
  final Article article;

  const ArticleSaveButtonAnimated({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleDetailCubit, ArticleDetailState>(
      builder: (context, state) {
        final currentArticle = (state is ArticleDetailSuccess) 
            ? state.article 
            : article;

        return CustomAnimatedButton(
          text: currentArticle.isSaved
              ? context.trContext(TK.articlesSaved)
              : context.trContext(TK.articlesSave),
          minimumSize: Size(double.infinity, 52.h),
          onPressed: () {
            context.read<ArticleDetailCubit>().toggleSave();
          },
          textStyle: context.text.titleLarge!.copyWith(
            color: context.theme.buttonTheme.colorScheme!.onPrimary,
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
