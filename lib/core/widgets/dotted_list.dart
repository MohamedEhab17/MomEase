import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

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
          padding: 10.topPadding,
          child: CircleAvatar(
            backgroundColor: context.ext.colors.primaryDark,
            radius: 4.r,
          ),
        ),
        Expanded(
          child: Text(
            text,
            maxLines: 4,
            style: context.text.titleMedium!.copyWith(
              fontWeight: FontWeight.w400,
              color: context.ext.colors.lightTextDisabled.withAlpha(178),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
