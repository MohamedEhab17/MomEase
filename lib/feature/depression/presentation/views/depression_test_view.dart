import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/features_header.dart';
import 'package:new_mama/feature/depression/presentation/widgets/answers_option.dart';

class DepressionTestView extends StatefulWidget {
  const DepressionTestView({super.key});

  @override
  State<DepressionTestView> createState() => _DepressionTestViewState();
}

class _DepressionTestViewState extends State<DepressionTestView> {
  int? selectedIndex;

  final List<String> answers = [
    'Not at all',
    'Several days',
    'More than half the days',
    'Nearly everyday',
  ];

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: FeaturesHeader(title: 'Healthy check-In'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  LinearProgressIndicator(
                    backgroundColor: AppColors.secondarySoft3,
                    color: AppColors.primaryHard,
                    value: 0.2,
                    borderRadius: BorderRadius.circular(24.r),
                    minHeight: 6.h,
                  ),
                  8.height,
                  Text('Question 1 of 8', style: AppStyles.styleInter12),
                  48.height,
                  Text(
                    'Over the past two weeks, how often have you felt down, depressed, or hopeless?',
                    style: AppStyles.styleInter20,
                  ),
                  32.height,
                ],
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: AnswersOptions(
                    answer: answers[index],
                    isSelected: selectedIndex == index,
                    onTap: () => setState(() => selectedIndex = index),
                  ),
                ),
                childCount: answers.length,
              ),
            ),

            SliverToBoxAdapter(child: 44.height),

            SliverToBoxAdapter(
              child: CustomElevatedButton(
                text: 'Next Question',
                onPressed: () {},
                minimumSize: Size(double.infinity, 52.h),
                backgroundColor: AppColors.primaryHard,
                textStyle: AppStyles.styleInter20.copyWith(
                  color: AppColors.lightBackground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
