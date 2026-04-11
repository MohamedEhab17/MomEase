import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';

class CreatePostHeader extends StatelessWidget {
  const CreatePostHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colors.onSurface,
            size: 24.sp,
          ),
        ),
        Text('Create Post', style: context.text.displaySmall!),
      ],
    );
  }
}
