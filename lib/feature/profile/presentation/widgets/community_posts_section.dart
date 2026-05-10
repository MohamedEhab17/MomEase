import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/widgets/custom_elevated_button.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_state.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_components/post_item.dart';

class CommunityPostsSection extends StatefulWidget {
  const CommunityPostsSection({super.key});

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
      child: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          if (state.status == CommunityStatus.loading && state.posts.isEmpty) {
            return const Center(child: CustomLoadingIndicator());
          }

          if (state.status == CommunityStatus.success && state.posts.isEmpty) {
            return Center(
              child: Text(
                context.trContext(TK.communityNoSavedPosts), // Reuse empty state key or use a specific one
                style: context.text.bodyMedium,
              ),
            );
          }

          return Column(
            children: [
              ...state.posts.map(
                (post) => PostItem(post: post, controller: _controller),
              ),
              if (state.posts.isNotEmpty) ...[
                16.height,
                CustomElevatedButton(
                  textStyle: context.text.titleSmall!.copyWith(
                    color: context.ext.colors.darkTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  minimumSize: Size(double.infinity, 52.h),
                  text: context.trContext(TK.communityViewAllPosts),
                  onPressed: () {
                    // This could navigate to a dedicated My Posts screen if needed
                  },
                ),
                16.height,
              ],
            ],
          );
        },
      ),
    );
  }
}
