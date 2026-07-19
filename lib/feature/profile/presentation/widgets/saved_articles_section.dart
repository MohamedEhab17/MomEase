import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/feature/articles/presentation/view_model/saved_articles/saved_articles_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view_model/saved_articles/saved_articles_state.dart';
import 'package:new_mama/feature/profile/presentation/widgets/profile_article_preview_card.dart';

class SavedArticlesSection extends StatelessWidget {
  const SavedArticlesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedArticlesCubit, SavedArticlesState>(
      builder: (context, state) {
        if (state is SavedArticlesLoading) {
          return SizedBox(
            height: 240.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is SavedArticlesSuccess) {
          if (state.articles.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                context.trContext(TK.articlesNoSaved),
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            );
          }

          return SizedBox(
            height: 240.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: state.articles.length,
              separatorBuilder: (context, index) => SizedBox(width: 16.w),
              itemBuilder: (context, index) {
                return ProfileArticlePreviewCard(article: state.articles[index]);
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
