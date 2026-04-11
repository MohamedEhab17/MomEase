import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_item.dart';

class CommunityPostsSection extends StatefulWidget {
  final List<PostModel> posts;

  const CommunityPostsSection({super.key, required this.posts});

  @override
  State<CommunityPostsSection> createState() => _CommunityPostsSectionState();
}

class _CommunityPostsSectionState extends State<CommunityPostsSection> {
  late AnimateToController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimateToController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          ...widget.posts.map(
            (post) => PostItem(post: post, controller: _controller),
          ),
          16.height,
          CustomElevatedButton(
            textStyle: context.text.titleSmall!.copyWith(
              color: context.ext.colors.darkTextPrimary,
              fontWeight: FontWeight.w600,
            ),
            minimumSize: Size(double.infinity, 52.h),
            text: "View All My Posts",
            onPressed: () {
              // show all posts in a new screen
            },
          ),
          16.height,
        ],
      ),
    );
  }
}
