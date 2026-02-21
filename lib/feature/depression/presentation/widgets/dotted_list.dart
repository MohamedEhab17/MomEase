
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/utils/app_styles.dart';

class DottedList extends StatelessWidget {
  const DottedList({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10.w,
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: CircleAvatar(
            backgroundColor: AppColors.primaryHard,
            radius: 4.r,
          ),
        ),
        Expanded(
          child: Text(
            text,
            maxLines: 4,
            style: AppStyles.styleInter16,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
