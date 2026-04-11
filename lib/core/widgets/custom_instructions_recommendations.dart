import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/widgets/dotted_list.dart';

class CustomInstructionsRecommendations extends StatelessWidget {
  const CustomInstructionsRecommendations({
    super.key,
    required this.advices,
    required this.title,
  });

  final List<String> advices;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.ext.colors.primaryLight),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            style: context.text.titleMedium!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          ...advices.map(
            (advice) => Padding(
              padding: 10.vPadding,
              child: DottedList(text: advice),
            ),
          ),
        ],
      ),
    );
  }
}
