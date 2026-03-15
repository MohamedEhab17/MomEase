import 'package:animate_to/animate_to.dart';
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
import 'package:new_mama/feature/articles/presentation/widgets/articles_header.dart';
import 'package:new_mama/feature/articles/presentation/widgets/custom_article_category_item.dart';

class ArticlesView extends StatefulWidget {
  const ArticlesView({super.key});

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  late AnimateToController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimateToController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ArticlesHeader(controller: _controller),
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
          20.height,
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
                  itemCount: state.articles.length,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) => 20.height,
                  itemBuilder: (context, index) => CustomArticleCategoryItem(
                    article: state.articles[index],
                    controller: _controller,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
