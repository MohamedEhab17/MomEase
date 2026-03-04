import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/core/widgets/dotted_list.dart';

class CustomInstructionsRecommendations extends StatelessWidget {
  const CustomInstructionsRecommendations({super.key, required this.advices, required this.title});

  final List<String> advices;
final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primarySoft5),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
           title ,
            style: AppStyles.styleInter16.copyWith(fontWeight: FontWeight.w700),
          ),
          ...advices.map(
            (advice) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: DottedList(text: advice),
            ),
          ),
        ],
      ),
    );
  }
}
