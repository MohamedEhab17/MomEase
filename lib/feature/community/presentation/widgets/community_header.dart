import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import 'package:new_mama/core/utils/app_icons.dart';
import 'package:new_mama/core/utils/app_styles.dart';
import 'package:new_mama/feature/community/presentation/widgets/circle_icon_button.dart';

class CommunityHeader extends StatelessWidget {
  const CommunityHeader({super.key, required this.controller});
  final AnimateToController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Text('Community', style: AppStyles.styleInter24),

          const Spacer(),

          CircleIconButton(
            icon: Icons.add,
            onTap: () {
              context.push(AppRoutesPaths.createPostCommunityView);
            },
          ),

          const SizedBox(width: 12),

          GestureDetector(
            child: AnimateTo(
              controller: controller,
              child: SvgPicture.asset(
                AppIcons.iconsFilledSave,
                height: 24.h,
                width: 16.w,
              ),
            ),
            onTap: () {
              context.push(AppRoutesPaths.savedPostsView);
            },
          ),
        ],
      ),
    );
  }
}
