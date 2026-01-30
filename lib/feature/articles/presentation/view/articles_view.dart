import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/text_form_field_helper.dart';
import 'package:new_mama/feature/articles/presentation/widgets/article_category_card.dart';
import 'package:new_mama/feature/articles/presentation/widgets/articles_header.dart';

class ArticlesView extends StatelessWidget {
  const ArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ArticlesHeader(),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          children: [
            TextFormFieldHelper(
              fillColor: AppColors.lightBackground,
              borderColor: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(64.r),
              hint: 'Search articles...',
              hintStyle: AppStyles.styleInter12.copyWith(
                color: AppColors.lightTextDisabled,
              ),
              suffixWidget: SvgPicture.asset(
                AppIcons.iconsSearch,
                width: 15.w,
                height: 15.h,
              ),
            ),
            28.height,
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => ArticleCategoryCard(),
                itemCount: 20,
                separatorBuilder: (context, index) => 16.height,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
