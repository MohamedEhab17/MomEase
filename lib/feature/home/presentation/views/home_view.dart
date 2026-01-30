import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/home/presentation/widgets/articles_card.dart';
import 'package:new_mama/feature/home/presentation/widgets/custom_quick_access_card.dart';
import 'package:new_mama/feature/home/presentation/widgets/depression_test_widget.dart';
import 'package:new_mama/feature/home/presentation/widgets/home_app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      drawer: Drawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text('Welcome again, Rana!', style: AppStyles.styleInter24),
            4.height,
            Text(
              'How can we help you today?',
              style: AppStyles.styleInter16.copyWith(
                color: AppColors.lightTextPrimary.withAlpha(178),
              ),
            ),
            13.height,
            DepressionTestWidget(),
            32.height,
            Text(
              'Quick access',
              style: AppStyles.styleInter16.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            12.height,
            CustomQuickAccessCard(
              leadingIcon: AppIcons.iconsSound,
              title: 'Crying Sound Analysis',
              subtitle: 'Understand why your baby is crying',
              onTap: () {},
            ),
            8.height,
            CustomQuickAccessCard(
              leadingIcon: AppIcons.iconsSkin,
              title: 'Skin Diagnosis',
              subtitle: 'check your baby’s skin health',
              onTap: () {},
            ),
            8.height,
            CustomQuickAccessCard(
              leadingIcon: AppIcons.iconsBabyTracing,
              title: 'Baby Tracking',
              subtitle: 'Log feeding, sleep, and diapers',
              onTap: () {},
            ),
            24.height,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Useful articles',
                  style: AppStyles.styleInter16.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.pushNamed('articlesView');
                  },
                  child: Text(
                    'View all',
                    style: AppStyles.styleInter10.copyWith(
                      color: AppColors.primaryHard,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 114.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                separatorBuilder: (context, index) => 16.width,
                itemBuilder: (context, index) {
                  return ArticlesCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
