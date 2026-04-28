import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class DottedList extends StatelessWidget {
  const DottedList({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: 10.topPadding,
          child: CircleAvatar(
            backgroundColor: context.ext.colors.primaryDark,
            radius: 4.r,
          ),
        ),
        10.w.width,
        Expanded(
          child: Text(
            text,
            maxLines: 4,
            style: context.text.titleLarge!.copyWith(
              fontWeight: FontWeight.w400,
              color: context.ext.colors.greyPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
