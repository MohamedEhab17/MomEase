import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/constants/app_colors.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_state.dart';
import 'package:new_mama/feature/community/presentation/widgets/post_item.dart';
import 'package:animate_to/animate_to.dart';
import 'package:new_mama/feature/app_section/presentation/widgets/app_header.dart';

class SavedPostsView extends StatefulWidget {
  const SavedPostsView({super.key});

  @override
  State<SavedPostsView> createState() => _SavedPostsViewState();
}

class _SavedPostsViewState extends State<SavedPostsView> {
  late AnimateToController _animateToController;

  @override
  void initState() {
    super.initState();
    _animateToController = AnimateToController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(), // Assume this works well as a header.
      body: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          final savedPosts = state.posts.where((p) => p.isSaved).toList();

          if (savedPosts.isEmpty) {
            return Center(
              child: Text("No Saved Posts", style: AppStyles.styleInter24),
            );
          }

          return Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: .start,
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.lightTextPrimary,
                      size: 24.sp,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  Text('Saved Posts', style: AppStyles.styleInter24),
                  const Spacer(),
                  Text(
                    "${savedPosts.length} ${savedPosts.length == 1 ? "post" : "posts"}",
                  ),
                  20.width,
                ],
              ),
              Expanded(
                child: Padding(
                  padding: 20.hPadding,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => PostItem(
                            post: savedPosts[i],
                            controller: _animateToController,
                          ),
                          childCount: savedPosts.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
