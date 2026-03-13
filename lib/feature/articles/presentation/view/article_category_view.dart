import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/feature/articles/presentation/view_model/article_cubit.dart';
import 'package:new_mama/feature/articles/presentation/view_model/article_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/articles/presentation/widgets/article_category_card.dart';
import 'package:new_mama/feature/articles/presentation/widgets/articles_header.dart';

class ArticleCategoryView extends StatelessWidget {
  const ArticleCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ArticlesHeader(),

      body: Column(
        children: [
          Padding(
            padding: 20.hPadding,
            child: TextFormFieldHelper(
              fillColor: AppColors.lightBackground,
              borderColor: AppColors.primaryLighter,
              borderRadius: BorderRadius.circular(64.r),
              hint: 'Search articles...',
              hintStyle: AppStyles.styleInter12.copyWith(
                color: AppColors.lightTextDisabled,
              ),
              suffixWidget: SizedBox(
                width: 60.w,
                height: 40.h,
                child: Center(
                  child: SvgPicture.asset(
                    AppIcons.iconsSearch,
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
              ),
            ),
          ),
          28.height,
          Expanded(
            child: BlocBuilder<ArticleCubit, ArticleState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.articles.isEmpty) {
                  return const Center(child: Text('No articles found.'));
                }
                return ListView.separated(
                  clipBehavior: Clip.hardEdge,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) =>
                      ArticleCategoryCard(article: state.articles[index]),
                  itemCount: state.articles.length,
                  separatorBuilder: (context, index) => 16.height,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
